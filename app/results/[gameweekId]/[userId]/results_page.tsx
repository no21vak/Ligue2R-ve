import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";

const POSITION_LABEL: Record<string, string> = {
  GARDIEN: "Gardien",
  DEFENSEUR: "Défenseur",
  MILIEU: "Milieu",
  ATTAQUANT: "Attaquant",
};

interface SlotRecord {
  id: number;
  player_id: number;
  position: string;
  is_starter: boolean;
  slot_order: number;
  points: number | null;
  counted: boolean;
}

function describeSlot(slot: SlotRecord) {
  if (slot.counted && slot.points === -6) {
    return { label: "Poste vide — personne n'a joué à ce poste", tone: "bad" as const };
  }
  if (slot.is_starter && slot.counted) {
    return { label: "Titulaire", tone: "good" as const };
  }
  if (slot.is_starter && !slot.counted) {
    return { label: "Évincé — un remplaçant mieux noté a pris sa place", tone: "muted" as const };
  }
  if (!slot.is_starter && slot.counted) {
    return { label: "Entré depuis le banc — mieux noté qu'un titulaire", tone: "good" as const };
  }
  return { label: "Resté sur le banc", tone: "muted" as const };
}

export default async function ResultsPage({
  params,
}: {
  params: { gameweekId: string; userId: string };
}) {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const gameweekId = Number(params.gameweekId);

  const { data: lineup } = await supabase
    .from("lineups")
    .select("id, formation, total_points, user_id")
    .eq("gameweek_id", gameweekId)
    .eq("user_id", params.userId)
    .maybeSingle();

  if (!lineup) {
    return (
      <EmptyState message="Cette composition n'est pas (encore) visible — soit elle n'existe pas, soit la journée n'est pas encore verrouillée." />
    );
  }

  const [{ data: gameweek }, { data: owner }, { data: slots }] = await Promise.all([
    supabase.from("gameweeks").select("number, season").eq("id", gameweekId).maybeSingle(),
    supabase.from("users").select("username").eq("id", params.userId).maybeSingle(),
    supabase
      .from("lineup_slots")
      .select("id, player_id, position, is_starter, slot_order, points, counted")
      .eq("lineup_id", lineup.id)
      .order("slot_order"),
  ]);

  const playerIds = (slots ?? []).map((s) => s.player_id);

  const [{ data: players }, { data: stats }] = await Promise.all([
    supabase.from("players").select("id, club_id, first_name, last_name").in("id", playerIds),
    supabase
      .from("player_gameweek_stats")
      .select(
        "player_id, official_rating, goals, assists, yellow_cards, red_cards, own_goals, clean_sheet, minutes_played"
      )
      .eq("gameweek_id", gameweekId)
      .in("player_id", playerIds),
  ]);

  const clubIds = [...new Set((players ?? []).map((p) => p.club_id))];
  const { data: clubs } = await supabase
    .from("clubs")
    .select("id, name, short_name")
    .in("id", clubIds.length > 0 ? clubIds : [-1]);

  const clubById = new Map((clubs ?? []).map((c) => [c.id, c]));
  const playerById = new Map((players ?? []).map((p) => [p.id, p]));
  const statsByPlayerId = new Map((stats ?? []).map((s) => [s.player_id, s]));

  const starters = (slots ?? []).filter((s) => s.is_starter) as SlotRecord[];
  const bench = (slots ?? []).filter((s) => !s.is_starter) as SlotRecord[];

  return (
    <main className="min-h-screen bg-chalk px-4 py-6 pb-16">
      <div className="mx-auto max-w-2xl">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="font-display text-xl font-semibold uppercase tracking-wide text-ink">
              {owner?.username ?? "Compo"} {gameweek && `— J${gameweek.number}`}
            </h1>
            <p className="text-sm text-ink/60">{lineup.formation}</p>
          </div>
          <Link href="/classement" className="text-sm font-medium text-pitch-dark underline">
            ← Classement
          </Link>
        </div>

        <p className="mt-4 font-display text-4xl font-bold text-pitch-dark">
          {lineup.total_points ?? 0} <span className="text-lg font-medium text-ink/50">pts</span>
        </p>

        <SlotSection
          title="Titulaires"
          slots={starters}
          playerById={playerById}
          clubById={clubById}
          statsByPlayerId={statsByPlayerId}
        />
        <SlotSection
          title="Remplaçants"
          slots={bench}
          playerById={playerById}
          clubById={clubById}
          statsByPlayerId={statsByPlayerId}
        />
      </div>
    </main>
  );
}

function SlotSection({
  title,
  slots,
  playerById,
  clubById,
  statsByPlayerId,
}: {
  title: string;
  slots: SlotRecord[];
  playerById: Map<number, any>;
  clubById: Map<number, any>;
  statsByPlayerId: Map<number, any>;
}) {
  if (slots.length === 0) return null;
  return (
    <section className="mt-6">
      <h2 className="font-display text-sm font-semibold uppercase tracking-wide text-ink/70">
        {title}
      </h2>
      <div className="mt-2 space-y-2">
        {slots.map((slot) => {
          const player = playerById.get(slot.player_id);
          const club = player ? clubById.get(player.club_id) : undefined;
          const stat = statsByPlayerId.get(slot.player_id);
          const { label, tone } = describeSlot(slot);
          const toneClasses =
            tone === "good"
              ? "border-pitch/30 bg-pitch/5"
              : tone === "bad"
                ? "border-clay/40 bg-clay/5"
                : "border-ink/10 bg-ink/[0.02] opacity-70";

          return (
            <div
              key={slot.id}
              className={`rounded-xl border px-4 py-3 ${toneClasses}`}
            >
              <div className="flex items-center justify-between gap-3">
                <div>
                  <p className="text-sm font-semibold text-ink">
                    {player
                      ? `${player.first_name ?? ""} ${player.last_name}`.trim()
                      : "Joueur inconnu"}
                    <span className="ml-1 font-normal text-ink/50">
                      ({club?.short_name ?? club?.name ?? "?"})
                    </span>
                  </p>
                  <p className="text-xs uppercase tracking-wide text-ink/40">
                    {POSITION_LABEL[slot.position] ?? slot.position}
                  </p>
                </div>
                <p
                  className={`font-display text-lg font-bold ${
                    slot.counted && (slot.points ?? 0) < 0 ? "text-clay" : "text-ink"
                  }`}
                >
                  {slot.counted ? slot.points ?? 0 : "—"}
                </p>
              </div>

              <p className="mt-1 text-xs text-ink/60">{label}</p>

              {stat && (
                <p className="mt-2 text-xs text-ink/50">
                  Note {stat.official_rating ?? "—"} · {stat.goals} but{stat.goals > 1 ? "s" : ""} ·{" "}
                  {stat.assists} passe{stat.assists > 1 ? "s" : ""}
                  {stat.yellow_cards > 0 && ` · ${stat.yellow_cards} jaune`}
                  {stat.red_cards > 0 && " · rouge"}
                  {stat.clean_sheet && " · clean sheet"}
                </p>
              )}
              {!stat && slot.counted && (
                <p className="mt-2 text-xs text-clay">Aucune stat trouvée pour ce joueur.</p>
              )}
            </div>
          );
        })}
      </div>
    </section>
  );
}

function EmptyState({ message }: { message: string }) {
  return (
    <main className="flex min-h-screen items-center justify-center bg-chalk px-4 text-center">
      <p className="max-w-sm text-ink/70">{message}</p>
    </main>
  );
}
