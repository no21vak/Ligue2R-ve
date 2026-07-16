"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import type { Position } from "@/lib/types";

export interface SaveLineupSlotInput {
  player_id: number;
  position: Position;
  is_starter: boolean;
  slot_order: number;
}

export interface SaveLineupInput {
  leagueId: number;
  gameweekId: number;
  formation: string;
  slots: SaveLineupSlotInput[];
}

export async function saveLineup(
  input: SaveLineupInput
): Promise<{ success: true } | { success: false; error: string }> {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return { success: false, error: "Tu dois être connecté." };
  }

  if (input.slots.length !== 18 || input.slots.some((s) => !s.player_id)) {
    return { success: false, error: "Complète les 18 postes avant d'enregistrer." };
  }

  const clubIds = input.slots.map((s) => s.player_id);
  if (new Set(clubIds).size !== clubIds.length) {
    return { success: false, error: "Un même joueur ne peut occuper qu'un seul poste." };
  }

  const { data: inactivePlayers } = await supabase
    .from("players")
    .select("id")
    .in("id", clubIds)
    .eq("is_active", false);

  if (inactivePlayers && inactivePlayers.length > 0) {
    return {
      success: false,
      error: "Un ou plusieurs joueurs sélectionnés ne sont plus disponibles, remplace-les avant d'enregistrer.",
    };
  }

  const { error } = await supabase.rpc("save_lineup", {
    p_user_id: user.id,
    p_league_id: input.leagueId,
    p_gameweek_id: input.gameweekId,
    p_formation: input.formation,
    p_slots: input.slots,
  });

  if (error) {
    if (error.message.includes("GAMEWEEK_LOCKED")) {
      return {
        success: false,
        error: "La journée a débuté (ou a été verrouillée), tu ne peux plus modifier ta composition.",
      };
    }
    // La contrainte "un joueur par club" (lineup_slots_lineup_id_club_id_key)
    // est appliquée par la base ; si elle se déclenche ici, c'est qu'il reste
    // un bug côté filtre client plutôt qu'une vraie tentative invalide.
    if (error.message.includes("lineup_id_club_id")) {
      return { success: false, error: "Deux postes utilisent le même club, corrige avant de valider." };
    }
    return { success: false, error: "Erreur lors de l'enregistrement, réessaie." };
  }

  revalidatePath("/compositions");
  return { success: true };
}
