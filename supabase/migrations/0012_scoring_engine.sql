-- Ajoute le stockage des points calculés, et les fonctions qui les calculent.
--
-- Principe retenu (voir conversation) :
-- 1. Le socle de points vient de la note officielle du match (`official_rating`),
--    pas des stats brutes — ça évite le biais "plus de buts = toujours mieux".
-- 2. Les bonus buts/passes/clean sheet sont différenciés par poste (un but de
--    défenseur vaut plus qu'un but d'attaquant, plus rare).
-- 3. Pour chaque poste (GARDIEN/DEFENSEUR/MILIEU/ATTAQUANT), seuls les N
--    meilleures notes (titulaires + remplaçants confondus, N = nombre de
--    titulaires prévus à ce poste) comptent dans le score final. Les autres
--    (titulaires évincés ou remplaçants moins bons) ne rapportent rien.
-- 4. Si, pour un poste donné, aucun joueur (titulaire ni remplaçant) n'a de
--    stats du tout (personne n'a joué), ce poste reçoit une pénalité de -6
--    plutôt qu'un simple 0 — volontairement aussi sévère que le pire cas
--    d'un joueur réellement sur le terrain (pire note -3 + carton rouge -3).
--    Un poste laissé sans solution ne doit jamais être "gratuit" ni
--    préférable à un joueur qui a au moins joué, même mal.

alter table lineup_slots add column if not exists points int;
alter table lineup_slots add column if not exists counted boolean not null default false;
alter table lineups add column if not exists total_points int;

-- Calcule (et stocke) le score d'une seule composition pour la journée à
-- laquelle elle appartient.
create or replace function compute_lineup_score(p_lineup_id bigint) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_gameweek_id bigint;
begin
  select gameweek_id into v_gameweek_id from lineups where id = p_lineup_id;
  if v_gameweek_id is null then
    raise exception 'LINEUP_NOT_FOUND';
  end if;

  with slot_stats as (
    select
      ls.id as slot_id,
      ls.position,
      ls.is_starter,
      ls.slot_order,
      pgs.official_rating as rating,
      coalesce(pgs.goals, 0) as goals,
      coalesce(pgs.assists, 0) as assists,
      coalesce(pgs.yellow_cards, 0) as yellow_cards,
      coalesce(pgs.red_cards, 0) as red_cards,
      coalesce(pgs.own_goals, 0) as own_goals,
      coalesce(pgs.clean_sheet, false) as clean_sheet,
      coalesce(pgs.minutes_played, 0) as minutes_played
    from lineup_slots ls
    left join player_gameweek_stats pgs
      on pgs.player_id = ls.player_id and pgs.gameweek_id = v_gameweek_id
    where ls.lineup_id = p_lineup_id
  ),
  starter_counts as (
    select position, count(*) filter (where is_starter) as n_starters
    from slot_stats
    group by position
  ),
  ranked as (
    select
      ss.*,
      sc.n_starters,
      row_number() over (
        partition by ss.position
        order by ss.rating desc nulls last, ss.is_starter desc, ss.slot_order asc
      ) as rn
    from slot_stats ss
    join starter_counts sc on sc.position = ss.position
  ),
  computed as (
    select
      slot_id,
      (rn <= n_starters) as is_counted,
      case when rn > n_starters then 0 else
        (case
          -- Aucun joueur (titulaire ou remplaçant) n'a pu être trouvé pour ce
          -- poste : pénalité volontairement plus sévère que le pire cas d'un
          -- joueur réellement sur le terrain (pire note + carton rouge, soit
          -- -3 + -3 = -6), pour qu'un poste laissé sans solution ne soit
          -- jamais préférable à un joueur expulsé qui a au moins joué.
          when rating is null then -6
          when rating >= 8 then 5
          when rating >= 7 then 3
          when rating >= 6 then 1
          when rating >= 5 then 0
          when rating >= 4 then -1
          else -3
        end)
        + goals * (case position
            when 'GARDIEN' then 10
            when 'DEFENSEUR' then 6
            when 'MILIEU' then 5
            else 4 end)
        + assists * (case position when 'DEFENSEUR' then 4 else 3 end)
        + (case when clean_sheet and minutes_played >= 60 then
            (case position
              when 'GARDIEN' then 4
              when 'DEFENSEUR' then 4
              when 'MILIEU' then 1
              else 0 end)
          else 0 end)
        - yellow_cards * 1
        - red_cards * 3
        - own_goals * 2
      end as points
    from ranked
  )
  update lineup_slots ls
  set counted = c.is_counted, points = c.points
  from computed c
  where ls.id = c.slot_id;

  update lineups
  set total_points = (
    select coalesce(sum(points), 0) from lineup_slots where lineup_id = p_lineup_id and counted
  )
  where id = p_lineup_id;
end;
$$;

-- Calcule le score de toutes les compositions d'une journée d'un coup (à
-- lancer une fois les stats de la journée saisies).
create or replace function compute_gameweek_scores(p_gameweek_id bigint) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  r record;
begin
  for r in select id from lineups where gameweek_id = p_gameweek_id loop
    perform compute_lineup_score(r.id);
  end loop;
end;
$$;
