-- Fonction atomique : upsert du lineup + remplacement complet de ses slots.
-- Le trigger existant sync_lineup_slot_club se charge de renseigner club_id.
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
begin
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

-- Seed de dev : une ligue par défaut + une journée ouverte, pour pouvoir
-- tester l'écran de composition sans avoir à créer ça manuellement.
-- À adapter/supprimer une fois l'écran de création de ligue codé.
insert into leagues (name, owner_id)
select 'Les amis du dimanche', null
where not exists (select 1 from leagues);

insert into gameweeks (number, season, start_date, end_date, status)
select 1, '2026-2027', current_date, current_date + interval '2 days', 'open'
where not exists (select 1 from gameweeks);
