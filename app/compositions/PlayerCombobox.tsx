"use client";

import { useMemo, useRef, useState } from "react";
import type { Club, PlayerRow } from "@/lib/types";

interface Props {
  players: PlayerRow[]; // déjà filtrés par poste + disponibilité de club
  clubById: Map<number, Club>;
  value: number | null;
  onChange: (playerId: number | null) => void;
  placeholder: string;
  variant: "pitch" | "bench";
  disabled?: boolean;
}

function normalize(s: string) {
  return s
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase();
}

function playerLabel(p: PlayerRow, club: Club | undefined) {
  const name = [p.first_name, p.last_name].filter(Boolean).join(" ");
  const clubName = club?.short_name ?? club?.name ?? "?";
  return `${name} (${clubName})`;
}

export default function PlayerCombobox({
  players,
  clubById,
  value,
  onChange,
  placeholder,
  variant,
  disabled = false,
}: Props) {
  const [query, setQuery] = useState("");
  const [isOpen, setIsOpen] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  const selected = value ? players.find((p) => p.id === value) : undefined;
  const isSelectedInactive = selected?.is_active === false;

  const results = useMemo(() => {
    const q = normalize(query.trim());
    const list = q
      ? players.filter((p) => {
          const club = clubById.get(p.club_id);
          const haystack = normalize(
            `${p.first_name ?? ""} ${p.last_name} ${club?.name ?? ""} ${club?.short_name ?? ""}`
          );
          return haystack.includes(q);
        })
      : players;
    return list.slice(0, 30); // évite d'afficher des centaines de lignes d'un coup
  }, [players, clubById, query]);

  function handleSelect(playerId: number) {
    onChange(playerId);
    setQuery("");
    setIsOpen(false);
    inputRef.current?.blur();
  }

  function handleClear(e: React.MouseEvent) {
    e.stopPropagation();
    onChange(null);
    setQuery("");
  }

  const displayValue = isOpen
    ? query
    : selected
      ? playerLabel(selected, clubById.get(selected.club_id)) + (isSelectedInactive ? " ⚠" : "")
      : "";

  const isPitch = variant === "pitch";

  return (
    <div className="relative">
      <div
        className={`flex items-center gap-1 rounded-full border-2 shadow ${
          isPitch
            ? `w-32 px-2 py-1 ${value ? "border-gold bg-white" : "border-white/70 bg-white/90"}`
            : `w-full rounded-lg border px-2 py-2 ${value ? "border-pitch/40 bg-white" : "border-ink/15 bg-white"}`
        } ${isSelectedInactive ? "!border-clay" : ""} ${disabled ? "opacity-70" : ""}`}
      >
        <input
          ref={inputRef}
          value={displayValue}
          disabled={disabled}
          onChange={(e) => {
            setQuery(e.target.value);
            setIsOpen(true);
          }}
          onFocus={() => !disabled && setIsOpen(true)}
          onBlur={() => setTimeout(() => setIsOpen(false), 150)}
          placeholder={placeholder}
          className={`w-full truncate bg-transparent text-center outline-none disabled:cursor-not-allowed ${
            isSelectedInactive ? "text-clay" : ""
          } ${isPitch ? "text-xs font-semibold" : "text-xs font-medium"} ${
            isSelectedInactive ? "" : "text-ink"
          }`}
        />
        {value && !disabled && (
          <button
            type="button"
            onMouseDown={handleClear}
            className="shrink-0 text-ink/40 hover:text-clay"
            aria-label="Retirer ce joueur"
          >
            ×
          </button>
        )}
      </div>

      {isOpen && !disabled && (
        <ul className="absolute left-1/2 top-full z-20 mt-1 max-h-56 w-56 -translate-x-1/2 overflow-y-auto rounded-lg border border-ink/10 bg-white text-left shadow-lg">
          {results.length === 0 && (
            <li className="px-3 py-2 text-xs text-ink/50">Aucun joueur trouvé</li>
          )}
          {results.map((p) => {
            const club = clubById.get(p.club_id);
            return (
              <li key={p.id}>
                <button
                  type="button"
                  onMouseDown={() => handleSelect(p.id)}
                  className="block w-full truncate px-3 py-2 text-left text-xs hover:bg-pitch/10"
                >
                  {playerLabel(p, club)}
                </button>
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}
