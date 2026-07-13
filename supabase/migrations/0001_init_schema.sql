-- ============================================================
-- Ligue 2 Rêve — Schéma initial (V1)
-- À exécuter dans Supabase : Dashboard > SQL Editor > New query
-- ============================================================

-- ------------------------------------------------------------
-- 1. CLUBS
-- Les 18 clubs de Ligue 2 BKT. Table ajoutée par rapport à la
-- liste initiale des specs : elle manquait, mais PLAYERS et la
-- contrainte "1 joueur par club" en ont besoin.
-- ------------------------------------------------------------
create table clubs (
  id          bigint generated always as identity primary key,
  name        text not null unique,        -- ex: "Stade Lavallois"
  short_name  text,                        -- ex: "Laval"
  logo_url    text,
  created_at  timestamptz not null default now()
);

-- ------------------------------------------------------------
-- 2. USERS
-- Profil applicatif, lié à l'authentification Supabase
-- (auth.users est gérée automatiquement par Supabase Auth,
-- on ne la recrée pas, on s'y accroche juste).
-- ------------------------------------------------------------
create table users (
  id          uuid primary key references auth.users(id) on delete cascade,
  username    text not null unique,
  avatar_url  text,
  created_at  timestamptz not null default now()
);

-- ------------------------------------------------------------
-- 3. PLAYERS
-- Un joueur appartient à un seul club (l'effectif du moment).
-- ------------------------------------------------------------
create table players (
  id           bigint generated always as identity primary key,
  club_id      bigint not null references clubs(id) on delete restrict,
  first_name   text,
  last_name    text not null,
  birth_date   date,
  nationality  text,
  photo_url    text,
  is_active    boolean not null default true,  -- pour gérer transferts/départs sans supprimer l'historique
  created_at   timestamptz not null default now()
);

create index idx_players_club on players(club_id);

-- ------------------------------------------------------------
-- 4. PLAYER_POSITIONS
-- V1 : 4 postes larges. Un joueur peut avoir plusieurs postes
-- éligibles (ex: latéral qui joue aussi milieu), avec un poste
-- principal marqué is_primary.
-- ------------------------------------------------------------
create table player_positions (
  id          bigint generated always as identity primary key,
  player_id   bigint not null references players(id) on delete cascade,
  position    text not null check (position in ('GARDIEN','DEFENSEUR','MILIEU','ATTAQUANT')),
  is_primary  boolean not null default true,
  unique (player_id, position)
);

-- ------------------------------------------------------------
-- 5. LEAGUES
-- Une ligue = un groupe (ex: "Les amis du dimanche").
-- ------------------------------------------------------------
create table leagues (
  id          bigint generated always as identity primary key,
  name        text not null,
  owner_id    uuid references users(id) on delete set null,
  created_at  timestamptz not null default now()
);

-- ------------------------------------------------------------
-- 6. LEAGUE_MEMBERS
-- Qui fait partie de quelle ligue.
-- ------------------------------------------------------------
create table league_members (
  id          bigint generated always as identity primary key,
  league_id   bigint not null references leagues(id) on delete cascade,
  user_id     uuid not null references users(id) on delete cascade,
  joined_at   timestamptz not null default now(),
  unique (league_id, user_id)
);

-- ------------------------------------------------------------
-- 7. GAMEWEEKS
-- Les journées de championnat.
-- ------------------------------------------------------------
create table gameweeks (
  id          bigint generated always as identity primary key,
  number      int not null,
  season      text not null,              -- ex: "2025-2026"
  start_date  date,
  end_date    date,
  status      text not null default 'upcoming'
              check (status in ('upcoming','open','locked','completed')),
  unique (season, number)
);

-- ------------------------------------------------------------
-- 8. LINEUPS
-- La composition d'un utilisateur pour une journée, dans une ligue.
-- Une seule composition par utilisateur/ligue/journée.
-- ------------------------------------------------------------
create table lineups (
  id            bigint generated always as identity primary key,
  user_id       uuid not null references users(id) on delete cascade,
  league_id     bigint not null references leagues(id) on delete cascade,
  gameweek_id   bigint not null references gameweeks(id) on delete cascade,
  formation     text,                     -- ex: "4-4-2"
  submitted_at  timestamptz,
  created_at    timestamptz not null default now(),
  unique (user_id, league_id, gameweek_id)
);

-- ------------------------------------------------------------
-- 9. LINEUP_SLOTS
-- Les 18 emplacements d'une composition (11 titulaires + 7 remplaçants).
--
-- club_id est dupliqué ici (dénormalisation volontaire) : une
-- contrainte UNIQUE ne peut porter que sur des colonnes de LA
-- MÊME table. Pour empêcher "2 joueurs du même club dans la
-- même compo" directement en base, il faut que club_id soit
-- présent sur cette table. Un trigger juste en dessous le
-- remplit automatiquement à partir du joueur choisi, pour que
-- ça ne puisse jamais être désynchronisé par erreur.
-- ------------------------------------------------------------
create table lineup_slots (
  id           bigint generated always as identity primary key,
  lineup_id    bigint not null references lineups(id) on delete cascade,
  player_id    bigint not null references players(id),
  club_id      bigint not null references clubs(id),
  position     text not null check (position in ('GARDIEN','DEFENSEUR','MILIEU','ATTAQUANT')),
  is_starter   boolean not null default true,
  slot_order   int,

  -- LA contrainte clé du jeu : un seul joueur par club, par composition
  unique (lineup_id, club_id),
  -- garde-fou : pas deux fois le même joueur dans une même compo
  unique (lineup_id, player_id)
);

-- Trigger : remplit automatiquement club_id à partir du joueur choisi,
-- pour que le développeur n'ait jamais à s'en soucier côté code
-- (et ne puisse pas se tromper).
create or replace function sync_lineup_slot_club()
returns trigger as $$
begin
  select club_id into new.club_id
  from players
  where id = new.player_id;
  return new;
end;
$$ language plpgsql;

create trigger trg_sync_lineup_slot_club
before insert or update of player_id on lineup_slots
for each row
execute function sync_lineup_slot_club();

-- ------------------------------------------------------------
-- 10. PLAYER_GAMEWEEK_STATS
-- Stats brutes saisies après chaque journée. Volontairement
-- générique (comptage d'actions) pour pouvoir appliquer
-- n'importe quel barème de scoring plus tard sans revoir le schéma.
-- ------------------------------------------------------------
create table player_gameweek_stats (
  id               bigint generated always as identity primary key,
  player_id        bigint not null references players(id) on delete cascade,
  gameweek_id      bigint not null references gameweeks(id) on delete cascade,
  minutes_played   int default 0,
  goals            int default 0,
  assists          int default 0,
  yellow_cards     int default 0,
  red_cards        int default 0,
  own_goals        int default 0,
  clean_sheet      boolean default false,
  official_rating  numeric(3,1),          -- ex: 7.5
  created_at       timestamptz not null default now(),
  unique (player_id, gameweek_id)
);

-- ============================================================
-- Fin du schéma V1
-- ============================================================
