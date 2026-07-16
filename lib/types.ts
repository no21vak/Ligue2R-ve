export type Position = "GARDIEN" | "DEFENSEUR" | "MILIEU" | "ATTAQUANT";

export interface Club {
  id: number;
  name: string;
  short_name: string | null;
  logo_url: string | null;
}

export interface PlayerRow {
  id: number;
  club_id: number;
  first_name: string | null;
  last_name: string;
  jersey_number: number | null;
  photo_url: string | null;
  positions: Position[];
}

export interface SlotState {
  id: string; // identifiant stable côté UI (ex: "starter-3", "bench-1")
  slotOrder: number; // aligné avec lineup_slots.slot_order
  position: Position;
  isStarter: boolean;
  x?: number; // position en % sur le terrain (titulaires uniquement)
  y?: number;
  playerId: number | null;
}

export interface ExistingLineup {
  formation: string;
  slots: {
    player_id: number;
    position: Position;
    is_starter: boolean;
    slot_order: number;
  }[];
}
