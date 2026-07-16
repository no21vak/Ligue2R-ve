"use client";

import { useState } from "react";
import { createClient } from "@/lib/supabase/client";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState<"idle" | "sending" | "sent" | "error">("idle");

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setStatus("sending");
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback`,
      },
    });
    setStatus(error ? "error" : "sent");
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-chalk px-4">
      <div className="w-full max-w-sm">
        <h1 className="font-display text-3xl font-semibold uppercase tracking-wide text-ink">
          Ligue2Rêve
        </h1>
        <p className="mt-2 text-sm text-ink/70">
          Reçois un lien de connexion par email, pas de mot de passe à retenir.
        </p>

        {status === "sent" ? (
          <p className="mt-6 rounded-lg border border-pitch/20 bg-pitch/5 p-4 text-sm text-pitch-dark">
            Regarde ta boîte mail : clique sur le lien pour te connecter.
          </p>
        ) : (
          <form onSubmit={handleSubmit} className="mt-6 space-y-3">
            <input
              type="email"
              required
              placeholder="ton@email.fr"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full rounded-lg border border-ink/15 bg-white px-4 py-3 text-sm outline-none focus:border-pitch focus:ring-2 focus:ring-pitch/30"
            />
            <button
              type="submit"
              disabled={status === "sending"}
              className="w-full rounded-lg bg-pitch px-4 py-3 text-sm font-semibold text-chalk transition hover:bg-pitch-dark disabled:opacity-60"
            >
              {status === "sending" ? "Envoi..." : "Recevoir le lien"}
            </button>
            {status === "error" && (
              <p className="text-sm text-clay">Une erreur est survenue, réessaie.</p>
            )}
          </form>
        )}
      </div>
    </main>
  );
}
