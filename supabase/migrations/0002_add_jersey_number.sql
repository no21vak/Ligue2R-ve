-- ============================================================
-- Migration 0002 : ajout du numéro de maillot
-- Colonne nullable : ne bloque rien si le numéro est inconnu
-- (cas des joueurs du groupe pro sans contrat officiel, etc.)
-- ============================================================

alter table players
  add column jersey_number int;
