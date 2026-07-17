-- Calcule le classement d'une ligue : cumul de points sur toutes les
-- journées verrouillées/terminées, plus le détail de la dernière journée
-- jouée. Fonction SECURITY DEFINER : elle contourne la RLS, donc elle doit
-- elle-même vérifier que l'appelant fait partie de la ligue demandée.
create or replace function get_league_standings(p_league_id bigint)
returns table (
  user_id uuid,
  username text,
  cumulative_points bigint,
  last_gameweek_id bigint,
  last_gameweek_number int,
  last_gameweek_points int
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_last_gameweek_id bigint;
  v_last_gameweek_number int;
begin
  if not exists (
    select 1 from league_members lm
    where lm.league_id = p_league_id and lm.user_id = auth.uid()
  ) then
    raise exception 'NOT_A_LEAGUE_MEMBER';
  end if;

  select gw.id, gw.number into v_last_gameweek_id, v_last_gameweek_number
  from gameweeks gw
  where gw.status in ('locked', 'completed')
  order by gw.number desc
  limit 1;

  return query
  select
    u.id as user_id,
    u.username,
    coalesce((
      select sum(l.total_points)
      from lineups l
      join gameweeks gw on gw.id = l.gameweek_id
      where l.user_id = u.id
      and l.league_id = p_league_id
      and gw.status in ('locked', 'completed')
    ), 0) as cumulative_points,
    v_last_gameweek_id as last_gameweek_id,
    v_last_gameweek_number as last_gameweek_number,
    (
      select l2.total_points
      from lineups l2
      where l2.user_id = u.id
      and l2.league_id = p_league_id
      and l2.gameweek_id = v_last_gameweek_id
    ) as last_gameweek_points
  from league_members lm
  join users u on u.id = lm.user_id
  where lm.league_id = p_league_id
  order by cumulative_points desc nulls last;
end;
$$;
