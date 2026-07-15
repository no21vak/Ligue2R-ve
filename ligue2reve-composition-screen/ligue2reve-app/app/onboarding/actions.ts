"use server";

import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export async function completeOnboarding(formData: FormData) {
  const username = String(formData.get("username") || "").trim();
  if (!username) redirect("/onboarding?error=empty");

  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { error: insertError } = await supabase
    .from("users")
    .insert({ id: user!.id, username });

  if (insertError) {
    redirect("/onboarding?error=taken");
  }

  // V1 : une seule ligue existe (voir migration de seed). On y rattache
  // automatiquement tout nouvel utilisateur.
  const { data: league } = await supabase
    .from("leagues")
    .select("id")
    .order("created_at", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (league) {
    await supabase
      .from("league_members")
      .insert({ league_id: league.id, user_id: user!.id })
      .select()
      .maybeSingle();
  }

  redirect("/compositions");
}
