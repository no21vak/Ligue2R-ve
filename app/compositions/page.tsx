import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import CompositionBuilder from "./CompositionBuilder";
import type { Club, ExistingLineup, PlayerRow } from "@/lib/types";

export default async function CompositionsPage() {
  const supabase = createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("users")
    .select("id, username")
    .eq("id", user.id)
    .maybeSingle();
  if (!profile) redirect("/onboarding");

  const { data: membership } = await supabase
    .from("league_members")
    .select("league_id, leagues(id, name)")
    .eq("user_id", user.id)
    .limit(1)
    .maybeSingle();

  if (!membership) {
    return (
      <EmptyState message="Tu n'es rattaché à aucune ligue pour le moment. Demande à l'admin de t'y ajouter." />
    );
  }

  const { data: gameweek } = await supabase
    .from("gameweeks")
    .select("id, number, season, status, lock_at")
    .in("status", ["open", "locked"])
    .order("number", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!gameweek) {
    return (
      <EmptyState message="Aucune journée n'est ouverte à la composition pour le moment. Reviens un peu plus tard." />
    );
  }

  const isLocked =
    gameweek.status !== "open" ||
    (gameweek.lock_at !== null && new Date(gameweek.lock_at) <= new Date());

  const [{ data: clubs }, { data: playerRows }, { data: lineup }] = await Promise.all([
    supabase.from("clubs").select("id, name, short_name, logo_url").order("name"),
    supabase
      .from("players")
      .select("id, club_id, first_name, last_name, jersey_number, photo_url, player_positions(position)")
      .eq("is_active", true),
    supabase
      .from("lineups")
      .select("formation, id")
      .eq("user_id", user.id)
      .eq("league_id", membership.league_id)
      .eq("gameweek_id", gameweek.id)
      .maybeSingle(),
  ]);

  let existingLineup: ExistingLineup | undefined;
  if (lineup) {
    const { data: slots } = await supabase
      .from("lineup_slots")
      .select("player_id, position, is_starter, slot_order")
      .eq("lineup_id", lineup.id);
    existingLineup = { formation: lineup.formation, slots: slots ?? [] };
  }

  const players: PlayerRow[] = (playerRows ?? []).map((p: any) => ({
    id: p.id,
    club_id: p.club_id,
    first_name: p.first_name,
    last_name: p.last_name,
    jersey_number: p.jersey_number,
    photo_url: p.photo_url,
    positions: (p.player_positions ?? []).map((pp: any) => pp.position),
  }));

  return (
    <CompositionBuilder
      leagueId={membership.league_id}
      gameweekId={gameweek.id}
      gameweekLabel={`J${gameweek.number} — ${gameweek.season}`}
      clubs={(clubs ?? []) as Club[]}
      players={players}
      existingLineup={existingLineup}
      username={profile.username}
      isLocked={isLocked}
      lockAt={gameweek.lock_at}
    />
  );
}

function EmptyState({ message }: { message: string }) {
  return (
    <main className="flex min-h-screen items-center justify-center bg-chalk px-4 text-center">
      <p className="max-w-sm text-ink/70">{message}</p>
    </main>
  );
}
