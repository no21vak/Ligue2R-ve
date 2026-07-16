import type { Position } from "@/lib/types";

export interface FormationSlotDef {
  position: Position;
  x: number; // % depuis la gauche
  y: number; // % depuis le haut (0 = but adverse, 100 = ton but)
}

export interface Formation {
  key: string;
  label: string;
  slots: FormationSlotDef[]; // toujours 11, index = slot_order des titulaires
}

export const FORMATIONS: Record<string, Formation> = {
  "4-4-2": {
    key: "4-4-2",
    label: "4-4-2",
    slots: [
      { position: "GARDIEN", x: 50, y: 92 },
      { position: "DEFENSEUR", x: 12, y: 70 },
      { position: "DEFENSEUR", x: 37, y: 72 },
      { position: "DEFENSEUR", x: 63, y: 72 },
      { position: "DEFENSEUR", x: 88, y: 70 },
      { position: "MILIEU", x: 12, y: 42 },
      { position: "MILIEU", x: 37, y: 45 },
      { position: "MILIEU", x: 63, y: 45 },
      { position: "MILIEU", x: 88, y: 42 },
      { position: "ATTAQUANT", x: 35, y: 15 },
      { position: "ATTAQUANT", x: 65, y: 15 },
    ],
  },
  "4-3-3": {
    key: "4-3-3",
    label: "4-3-3",
    slots: [
      { position: "GARDIEN", x: 50, y: 92 },
      { position: "DEFENSEUR", x: 12, y: 70 },
      { position: "DEFENSEUR", x: 37, y: 72 },
      { position: "DEFENSEUR", x: 63, y: 72 },
      { position: "DEFENSEUR", x: 88, y: 70 },
      { position: "MILIEU", x: 25, y: 46 },
      { position: "MILIEU", x: 50, y: 42 },
      { position: "MILIEU", x: 75, y: 46 },
      { position: "ATTAQUANT", x: 15, y: 16 },
      { position: "ATTAQUANT", x: 50, y: 12 },
      { position: "ATTAQUANT", x: 85, y: 16 },
    ],
  },
  "4-2-3-1": {
    key: "4-2-3-1",
    label: "4-2-3-1",
    slots: [
      { position: "GARDIEN", x: 50, y: 92 },
      { position: "DEFENSEUR", x: 12, y: 70 },
      { position: "DEFENSEUR", x: 37, y: 72 },
      { position: "DEFENSEUR", x: 63, y: 72 },
      { position: "DEFENSEUR", x: 88, y: 70 },
      { position: "MILIEU", x: 35, y: 54 },
      { position: "MILIEU", x: 65, y: 54 },
      { position: "MILIEU", x: 18, y: 32 },
      { position: "MILIEU", x: 50, y: 28 },
      { position: "MILIEU", x: 82, y: 32 },
      { position: "ATTAQUANT", x: 50, y: 12 },
    ],
  },
  "3-5-2": {
    key: "3-5-2",
    label: "3-5-2",
    slots: [
      { position: "GARDIEN", x: 50, y: 92 },
      { position: "DEFENSEUR", x: 25, y: 72 },
      { position: "DEFENSEUR", x: 50, y: 75 },
      { position: "DEFENSEUR", x: 75, y: 72 },
      { position: "MILIEU", x: 10, y: 46 },
      { position: "MILIEU", x: 32, y: 50 },
      { position: "MILIEU", x: 50, y: 44 },
      { position: "MILIEU", x: 68, y: 50 },
      { position: "MILIEU", x: 90, y: 46 },
      { position: "ATTAQUANT", x: 35, y: 15 },
      { position: "ATTAQUANT", x: 65, y: 15 },
    ],
  },
};

export const DEFAULT_FORMATION = "4-4-2";

// Le banc est fixe en V1, indépendant de la formation des titulaires.
export const BENCH_STRUCTURE: Position[] = [
  "GARDIEN",
  "DEFENSEUR",
  "DEFENSEUR",
  "MILIEU",
  "MILIEU",
  "ATTAQUANT",
  "ATTAQUANT",
];

export const BENCH_SLOT_OFFSET = 100; // slot_order des remplaçants = 100 + index
