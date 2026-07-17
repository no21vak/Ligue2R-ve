-- Élargit la lecture des compositions : en plus de voir la sienne (déjà
-- permis), chaque membre d'une ligue peut désormais voir la compo complète
-- des autres membres de sa ligue, mais UNIQUEMENT une fois la journée
-- verrouillée ou terminée — jamais tant qu'elle est encore modifiable
-- (sinon ça reviendrait à pouvoir copier la stratégie des autres avant le
-- coup d'envoi).
-- Ces policies s'ajoutent à lineups_select_own / lineup_slots_select_own
-- (elles ne les remplacent pas) : Postgres les combine avec un "OU".

create policy "lineups_select_league_after_lock" on lineups
  for select to authenticated using (
    exists (
      select 1 from league_members lm
      where lm.league_id = lineups.league_id
      and lm.user_id = auth.uid()
    )
    and exists (
      select 1 from gameweeks gw
      where gw.id = lineups.gameweek_id
      and (gw.status <> 'open' or (gw.lock_at is not null and now() >= gw.lock_at))
    )
  );

create policy "lineup_slots_select_league_after_lock" on lineup_slots
  for select to authenticated using (
    exists (
      select 1 from lineups l
      join league_members lm on lm.league_id = l.league_id and lm.user_id = auth.uid()
      join gameweeks gw on gw.id = l.gameweek_id
      where l.id = lineup_slots.lineup_id
      and (gw.status <> 'open' or (gw.lock_at is not null and now() >= gw.lock_at))
    )
  );
