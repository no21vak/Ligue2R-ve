-- Ajoute un instant précis de verrouillage (coup d'envoi du premier match de
-- la journée). `status` reste utilisable pour un verrouillage manuel par un
-- admin ; `lock_at` permet un verrouillage automatique à l'heure dite, sans
-- action manuelle nécessaire.
alter table gameweeks add column if not exists lock_at timestamptz;

-- Redéfinition de save_lineup : ajoute la vérification du verrou. C'est le
-- rempart qui compte vraiment (le fait de désactiver les champs côté écran
-- n'est qu'un confort d'affichage, pas une protection).
create or replace function save_lineup(
  p_user_id uuid,
  p_league_id bigint,
  p_gameweek_id bigint,
  p_formation text,
  p_slots jsonb
) returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare
  v_lineup_id bigint;
  v_status text;
  v_lock_at timestamptz;
begin
  select status, lock_at into v_status, v_lock_at
  from gameweeks
  where id = p_gameweek_id;

  if v_status is null then
    raise exception 'GAMEWEEK_NOT_FOUND';
  end if;

  if v_status <> 'open' or (v_lock_at is not null and now() >= v_lock_at) then
    raise exception 'GAMEWEEK_LOCKED';
  end if;

  insert into lineups (user_id, league_id, gameweek_id, formation, submitted_at)
  values (p_user_id, p_league_id, p_gameweek_id, p_formation, now())
  on conflict (user_id, league_id, gameweek_id)
  do update set formation = excluded.formation, submitted_at = now()
  returning id into v_lineup_id;

  delete from lineup_slots where lineup_id = v_lineup_id;

  insert into lineup_slots (lineup_id, player_id, position, is_starter, slot_order)
  select
    v_lineup_id,
    (elem->>'player_id')::bigint,
    (elem->>'position')::text,
    (elem->>'is_starter')::boolean,
    (elem->>'slot_order')::int
  from jsonb_array_elements(p_slots) as elem;

  return v_lineup_id;
end;
$$;

-- Pour tester tout de suite : donne un coup d'envoi dans 15 minutes à la
-- journée de seed créée en 0009 (si elle existe et n'a pas déjà de lock_at).
update gameweeks
set lock_at = now() + interval '15 minutes'
where status = 'open' and lock_at is null;
