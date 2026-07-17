import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";

interface StandingRow {
  user_id: string;
  username: string;
  cumulative_points: number;
  last_gameweek_id: number | null;
  last_gameweek_number: number | null;
  last_gameweek_points: number | null;
}

export default async function ClassementPage() {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("users")
    .select("id")
    .eq("id", user.id)
    .maybeSingle();
  if (!profile) redirect("/onboarding");

  const { data: membership } = await supabase
    .from("league_members")
    .select("league_id, leagues(name)")
    .eq("user_id", user.id)
    .order("league_id", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (!membership) {
    return <EmptyState message="Tu n'es rattaché à aucune ligue pour le moment." />;
  }

  const { data: standings, error } = await supabase.rpc("get_league_standings", {
    p_league_id: membership.league_id,
  });

  if (error || !standings || standings.length === 0) {
    return (
      <EmptyState message="Aucun résultat pour l'instant — reviens une fois la première journée verrouillée." />
    );
  }

  const rows = [...(standings as StandingRow[])].sort(
    (a, b) => b.cumulative_points - a.cumulative_points
  );
  const lastGameweekId = rows[0]?.last_gameweek_id;
  const lastGameweekNumber = rows[0]?.last_gameweek_number;

  const leagueName = (membership as any).leagues?.name ?? "Ta ligue";

  return (
    <main className="min-h-screen bg-chalk px-4 py-6">
      <div className="mx-auto max-w-2xl">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="font-display text-2xl font-semibold uppercase tracking-wide text-ink">
              Classement
            </h1>
            <p className="text-sm text-ink/60">{leagueName}</p>
          </div>
          <Link href="/compositions" className="text-sm font-medium text-pitch-dark underline">
            Ma compo
          </Link>
        </div>

        {lastGameweekNumber && (
          <p className="mt-1 text-xs uppercase tracking-wide text-ink/40">
            Après la journée {lastGameweekNumber}
          </p>
        )}

        <div className="mt-6 overflow-hidden rounded-xl border border-ink/10 bg-white">
          <table className="w-full text-sm">
            <thead className="bg-pitch/5 text-left text-xs uppercase tracking-wide text-ink/50">
              <tr>
                <th className="px-4 py-3">#</th>
                <th className="px-4 py-3">Pseudo</th>
                <th className="px-4 py-3 text-right">Dernière journée</th>
                <th className="px-4 py-3 text-right">Total</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row, i) => (
                <tr key={row.user_id} className="border-t border-ink/5">
                  <td className="px-4 py-3 font-semibold text-ink/60">{i + 1}</td>
                  <td className="px-4 py-3 font-medium text-ink">
                    {row.username}
                    {row.user_id === user.id && <span className="text-ink/40"> (toi)</span>}
                  </td>
                  <td className="px-4 py-3 text-right">
                    {lastGameweekId && row.last_gameweek_points !== null ? (
                      <Link
                        href={`/results/${lastGameweekId}/${row.user_id}`}
                        className="text-pitch-dark underline"
                      >
                        {row.last_gameweek_points}
                      </Link>
                    ) : (
                      <span className="text-ink/30">—</span>
                    )}
                  </td>
                  <td className="px-4 py-3 text-right font-semibold text-ink">
                    {row.cumulative_points}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <p className="mt-4 text-xs text-ink/40">
          Clique sur un score de dernière journée pour voir la compo complète.
        </p>
      </div>
    </main>
  );
}

function EmptyState({ message }: { message: string }) {
  return (
    <main className="flex min-h-screen items-center justify-center bg-chalk px-4 text-center">
      <p className="max-w-sm text-ink/70">{message}</p>
    </main>
  );
}
