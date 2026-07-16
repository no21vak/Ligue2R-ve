import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { completeOnboarding } from "./actions";

export default async function OnboardingPage({
  searchParams,
}: {
  searchParams: { error?: string };
}) {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: existing } = await supabase
    .from("users")
    .select("id")
    .eq("id", user.id)
    .maybeSingle();

  if (existing) redirect("/compositions");

  return (
    <main className="flex min-h-screen items-center justify-center bg-chalk px-4">
      <form action={completeOnboarding} className="w-full max-w-sm">
        <h1 className="font-display text-2xl font-semibold uppercase tracking-wide text-ink">
          Choisis ton pseudo
        </h1>
        <p className="mt-2 text-sm text-ink/70">
          C&apos;est lui qui apparaîtra dans le classement de la ligue.
        </p>
        {searchParams.error === "taken" && (
          <p className="mt-3 text-sm text-clay">Ce pseudo est déjà pris, choisis-en un autre.</p>
        )}
        {searchParams.error === "empty" && (
          <p className="mt-3 text-sm text-clay">Choisis un pseudo.</p>
        )}
        <input
          name="username"
          required
          minLength={3}
          maxLength={24}
          placeholder="ex. Toto93"
          className="mt-6 w-full rounded-lg border border-ink/15 bg-white px-4 py-3 text-sm outline-none focus:border-pitch focus:ring-2 focus:ring-pitch/30"
        />
        <button
          type="submit"
          className="mt-3 w-full rounded-lg bg-pitch px-4 py-3 text-sm font-semibold text-chalk transition hover:bg-pitch-dark"
        >
          C&apos;est parti
        </button>
      </form>
    </main>
  );
}
