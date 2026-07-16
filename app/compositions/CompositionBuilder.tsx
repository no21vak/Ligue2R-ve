"use client";

import { useEffect, useMemo, useState, useTransition } from "react";
import {
  BENCH_SLOT_OFFSET,
  BENCH_STRUCTURE,
  DEFAULT_FORMATION,
  FORMATIONS,
} from "@/lib/formations";
import { saveLineup } from "./actions";
import PlayerCombobox from "./PlayerCombobox";
import type { Club, ExistingLineup, PlayerRow, Position, SlotState } from "@/lib/types";

interface Props {
  leagueId: number;
  gameweekId: number;
  gameweekLabel: string;
  clubs: Club[];
  players: PlayerRow[];
  existingLineup?: ExistingLineup;
  username: string;
  isLocked: boolean;
  lockAt: string | null;
}

const POSITION_LABEL: Record<Position, string> = {
  GARDIEN: "G",
  DEFENSEUR: "D",
  MILIEU: "M",
  ATTAQUANT: "A",
};

function buildSlots(formationKey: string, existing?: ExistingLineup): SlotState[] {
  const formation = FORMATIONS[formationKey];
  const findExisting = (slotOrder: number) =>
    existing?.slots.find((s) => s.slot_order === slotOrder)?.player_id ?? null;

  const starters: SlotState[] = formation.slots.map((def, i) => ({
    id: `starter-${i}`,
    slotOrder: i,
    position: def.position,
    isStarter: true,
    x: def.x,
    y: def.y,
    playerId: existing ? findExisting(i) : null,
  }));

  const bench: SlotState[] = BENCH_STRUCTURE.map((position, i) => ({
    id: `bench-${i}`,
    slotOrder: BENCH_SLOT_OFFSET + i,
    position,
    isStarter: false,
    playerId: existing ? findExisting(BENCH_SLOT_OFFSET + i) : null,
  }));

  return [...starters, ...bench];
}

export default function CompositionBuilder({
  leagueId,
  gameweekId,
  gameweekLabel,
  clubs,
  players,
  existingLineup,
  username,
  isLocked: isLockedFromServer,
  lockAt,
}: Props) {
  const [now, setNow] = useState(() => new Date());

  useEffect(() => {
    if (isLockedFromServer || !lockAt) return; // déjà verrouillé, ou pas d'heure précise à surveiller
    const interval = setInterval(() => setNow(new Date()), 15_000);
    return () => clearInterval(interval);
  }, [isLockedFromServer, lockAt]);

  const isLocked = isLockedFromServer || (lockAt !== null && now >= new Date(lockAt));

  const [formationKey, setFormationKey] = useState(existingLineup?.formation ?? DEFAULT_FORMATION);
  const [slots, setSlots] = useState<SlotState[]>(() => buildSlots(formationKey, existingLineup));
  const [isPending, startTransition] = useTransition();
  const [feedback, setFeedback] = useState<{ type: "error" | "success"; message: string } | null>(
    null
  );

  const clubById = useMemo(() => new Map(clubs.map((c) => [c.id, c])), [clubs]);
  const playerById = useMemo(() => new Map(players.map((p) => [p.id, p])), [players]);

  const usedClubIds = useMemo(() => {
    const set = new Set<number>();
    for (const s of slots) {
      if (s.playerId) {
        const p = playerById.get(s.playerId);
        if (p) set.add(p.club_id);
      }
    }
    return set;
  }, [slots, playerById]);

  function handleFormationChange(newKey: string) {
    if (isLocked) return;
    const newFormation = FORMATIONS[newKey];
    setFormationKey(newKey);
    setSlots((prev) => {
      const bench = prev.filter((s) => !s.isStarter);
      const starters: SlotState[] = newFormation.slots.map((def, i) => ({
        id: `starter-${i}`,
        slotOrder: i,
        position: def.position,
        isStarter: true,
        x: def.x,
        y: def.y,
        playerId: null,
      }));
      return [...starters, ...bench];
    });
    setFeedback(null);
  }

  function handleSlotChange(slotId: string, playerId: number | null) {
    if (isLocked) return;
    setSlots((prev) => prev.map((s) => (s.id === slotId ? { ...s, playerId } : s)));
    setFeedback(null);
  }

  function availablePlayersFor(slot: SlotState) {
    return players
      .filter((p) => p.positions.includes(slot.position))
      .filter((p) => p.is_active || p.id === slot.playerId)
      .filter((p) => !usedClubIds.has(p.club_id) || p.id === slot.playerId)
      .sort((a, b) => {
        const clubA = clubById.get(a.club_id)?.name ?? "";
        const clubB = clubById.get(b.club_id)?.name ?? "";
        return clubA.localeCompare(clubB) || a.last_name.localeCompare(b.last_name);
      });
  }

  function handleSave() {
    setFeedback(null);
    startTransition(async () => {
      const result = await saveLineup({
        leagueId,
        gameweekId,
        formation: formationKey,
        slots: slots.map((s) => ({
          player_id: s.playerId as number,
          position: s.position,
          is_starter: s.isStarter,
          slot_order: s.slotOrder,
        })),
      });
      setFeedback(
        result.success
          ? { type: "success", message: "Composition enregistrée." }
          : { type: "error", message: result.error }
      );
    });
  }

  const starters = slots.filter((s) => s.isStarter);
  const bench = slots.filter((s) => !s.isStarter);
  const filledCount = slots.filter((s) => s.playerId).length;
  const inactiveSlotsCount = slots.filter(
    (s) => s.playerId && playerById.get(s.playerId)?.is_active === false
  ).length;
  const canSave = filledCount === 18 && inactiveSlotsCount === 0;

  return (
    <main className="min-h-screen bg-chalk pb-32">
      <header className="border-b border-ink/10 bg-white px-4 py-4">
        <div className="mx-auto flex max-w-3xl items-center justify-between">
          <div>
            <p className="font-display text-lg font-semibold uppercase tracking-wide text-ink">
              Ta composition
            </p>
            <p className="text-sm text-ink/60">
              {username} · {gameweekLabel}
            </p>
          </div>
          <div className="flex items-center gap-3">
            {isLocked && (
              <span className="rounded-full bg-clay/10 px-3 py-1 text-xs font-semibold uppercase tracking-wide text-clay">
                Verrouillée
              </span>
            )}
            <select
              value={formationKey}
              onChange={(e) => handleFormationChange(e.target.value)}
              disabled={isLocked}
              className="rounded-lg border border-ink/15 bg-white px-3 py-2 text-sm font-semibold disabled:cursor-not-allowed disabled:opacity-50"
            >
              {Object.values(FORMATIONS).map((f) => (
                <option key={f.key} value={f.key}>
                  {f.label}
                </option>
              ))}
            </select>
          </div>
        </div>
      </header>

      <div className="mx-auto max-w-3xl px-4">
        {/* Terrain */}
        <div className="relative mt-6 aspect-[3/4] w-full overflow-hidden rounded-2xl border-4 border-white pitch-stripes shadow-inner">
          {starters.map((slot) => (
            <div
              key={slot.id}
              className="absolute flex -translate-x-1/2 -translate-y-1/2 flex-col items-center gap-1"
              style={{ left: `${slot.x}%`, top: `${slot.y}%` }}
            >
              <span className="rounded-full bg-ink/60 px-2 py-0.5 text-[10px] font-semibold text-chalk">
                {POSITION_LABEL[slot.position]}
              </span>
              <PlayerCombobox
                players={availablePlayersFor(slot)}
                clubById={clubById}
                value={slot.playerId}
                onChange={(playerId) => handleSlotChange(slot.id, playerId)}
                placeholder={`— ${POSITION_LABEL[slot.position]} —`}
                variant="pitch"
                disabled={isLocked}
              />
            </div>
          ))}
        </div>

        {/* Banc */}
        <section className="mt-6">
          <h2 className="font-display text-sm font-semibold uppercase tracking-wide text-ink/70">
            Remplaçants
          </h2>
          <div className="mt-3 grid grid-cols-4 gap-2 sm:grid-cols-7">
            {bench.map((slot) => (
              <div key={slot.id} className="flex flex-col items-center gap-1">
                <span className="rounded-full bg-pitch/10 px-2 py-0.5 text-[10px] font-semibold text-pitch-dark">
                  {POSITION_LABEL[slot.position]}
                </span>
                <PlayerCombobox
                  players={availablePlayersFor(slot)}
                  clubById={clubById}
                  value={slot.playerId}
                  onChange={(playerId) => handleSlotChange(slot.id, playerId)}
                  placeholder="—"
                  variant="bench"
                  disabled={isLocked}
                />
              </div>
            ))}
          </div>
        </section>
      </div>

      {/* Barre d'action fixe */}
      <div className="fixed inset-x-0 bottom-0 border-t border-ink/10 bg-white/95 px-4 py-3 backdrop-blur">
        <div className="mx-auto flex max-w-3xl items-center justify-between gap-4">
          {isLocked ? (
            <p className="text-sm text-ink/70">
              🔒 La journée a débuté, ta composition est figée jusqu'à la prochaine.
            </p>
          ) : (
            <div className="text-sm text-ink/70">
              <span className="font-semibold text-ink">{filledCount}/18</span> postes remplis
              {inactiveSlotsCount > 0 && (
                <p className="text-clay">
                  {inactiveSlotsCount} joueur{inactiveSlotsCount > 1 ? "s" : ""} sélectionné
                  {inactiveSlotsCount > 1 ? "s" : ""} ne {inactiveSlotsCount > 1 ? "sont" : "l'est"} plus
                  disponible{inactiveSlotsCount > 1 ? "s" : ""} — remplace-{inactiveSlotsCount > 1 ? "les" : "le"} avant d'enregistrer.
                </p>
              )}
              {lockAt && (
                <p className="text-xs text-ink/50">
                  Verrouillage automatique le{" "}
                  {new Date(lockAt).toLocaleString("fr-FR", {
                    day: "numeric",
                    month: "short",
                    hour: "2-digit",
                    minute: "2-digit",
                  })}
                </p>
              )}
              {feedback && (
                <p className={feedback.type === "error" ? "text-clay" : "text-pitch-dark"}>
                  {feedback.message}
                </p>
              )}
            </div>
          )}
          {!isLocked && (
            <button
              onClick={handleSave}
              disabled={isPending || !canSave}
              className="rounded-lg bg-pitch px-5 py-3 text-sm font-semibold text-chalk transition hover:bg-pitch-dark disabled:opacity-40"
            >
              {isPending ? "Enregistrement..." : "Enregistrer ma compo"}
            </button>
          )}
        </div>
      </div>
    </main>
  );
}
