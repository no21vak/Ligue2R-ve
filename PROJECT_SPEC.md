# Ligue 2 Rêve — Document de référence

> Ce fichier est la source de vérité du projet. À uploader dans le Projet Claude
> et à garder dans le repo GitHub (racine). Mets-le à jour après chaque décision
> importante prise en conversation, pour ne pas avoir à tout réexpliquer la fois d'après.

---

## Concept

Jeu de fantasy football basé sur la Ligue 2 BKT (18 clubs). Avant chaque journée,
chaque utilisateur sélectionne son équipe de rêve : **un seul joueur par club à la fois**
(11 titulaires + 7 remplaçants = 18, soit exactement un joueur par club du championnat).

Objectif : récompenser la connaissance fine des effectifs (y compris des clubs moins
suivis comme Boulogne ou Dijon), pas juste des stars connues. Jeu entre amis, sans
ambition commerciale, mais pensé pour pouvoir être partagé/étendu si ça prend
(potentiellement à des communautés de fans de clubs, sites partenaires, etc.).

## Format de jeu

- L'utilisateur choisit une formation (4-4-2, 4-2-3-1, 4-3-3, etc.)
- Il sélectionne un joueur par poste, un seul par club disponible
- Après chaque journée : points calculés selon le barème (à définir — voir section Scoring)
- Classement hebdomadaire (meilleure équipe de la journée) + classement général (cumul saison)
- Ligues privées entre amis, potentiellement extensible à des ligues publiques plus tard

## Scoring — statut : À DÉFINIR

Pistes envisagées (non tranchées) :
- Buts, passes décisives, clean sheets, cartons, CSC → points positifs/négatifs
- Pondération par la note officielle du joueur (au-delà des seules actions décisives)
- Éviter une "méta" dominante (ex. penalty qui rapporte trop)
- **Prochaine étape** : définir un barème V1 simple (comptage d'actions), affiner après une saison de test

## Postes — approche

- V1 : 4 catégories larges (Gardien / Défenseur / Milieu / Attaquant)
- Le modèle de données supporte déjà plusieurs postes éligibles par joueur (table
  `PLAYER_POSITIONS`), donc on pourra affiner (ex. distinction couloir/axe, postes
  secondaires façon Transfermarkt) sans tout reconstruire. À ne PAS faire en V1.

## Stack technique

- **Frontend** : Next.js (React)
- **Backend + DB** : Supabase (Postgres géré, auth, API auto-générée) — gratuit à cette échelle
- **Hébergement** : Vercel, branché sur le repo GitHub (déploiement auto à chaque push)
- **Versioning** : GitHub (même en solo — historique, sauvegarde, lien avec Vercel)

## Données joueurs / stats

- V1 : saisie manuelle après chaque journée (18 clubs, ~25 joueurs chacun, gérable à la main)
- V2 potentielle : Sofascore (API JSON non-officielle, pas de clé requise, mais non garantie
  dans le temps — rester raisonnable sur la fréquence des requêtes, ne jamais présenter
  ça comme un partenariat officiel)
- Écarté : scraping du site LFP/ligue1.com (site en JS dynamique, techniquement plus
  lourd à scraper, et appartient au même groupe qui possède déjà MPG — le concurrent
  direct sur ce marché)

## Concurrence / positionnement

MPG (Mon Petit Gazon), propriété de la LFP depuis 2022, couvre déjà la Ligue 2 en
mode enchères/budget. Ligue 2 Rêve s'en différencie par la contrainte "un joueur par
club" (mécanique de pronostic tactique, pas de gestion budgétaire). Objectif : jeu fun
entre connaisseurs, pas concurrence frontale.

## Modèle de données — statut : CRÉÉ ✅

Tables en place dans Supabase : `CLUBS` (ajoutée en cours de route, absente de la
liste initiale mais nécessaire), `USERS`, `LEAGUES`, `LEAGUE_MEMBERS`, `PLAYERS`,
`PLAYER_POSITIONS`, `GAMEWEEKS`, `LINEUPS`, `LINEUP_SLOTS`, `PLAYER_GAMEWEEK_STATS`.

Décisions structurantes prises :
- Contrainte **"un seul joueur par club" par composition** imposée en base (`UNIQUE (lineup_id, club_id)`
  sur `LINEUP_SLOTS`), avec un trigger qui synchronise automatiquement `club_id` à partir du
  joueur choisi — aucune vérification manuelle à faire côté code.
- `PLAYERS` a une colonne `jersey_number` (ajoutée après coup, nullable — un numéro de
  maillot inconnu n'est jamais bloquant).
- `PLAYER_GAMEWEEK_STATS` reste volontairement générique (buts, passes, cartons, note...)
  pour absorber n'importe quel barème de scoring futur sans revoir le schéma.

Fichiers de migration (dossier `supabase/migrations/`, à exécuter dans l'ordre) :
1. `0001_init_schema.sql` — schéma initial (9 tables + trigger)
2. `0002_add_jersey_number.sql` — ajout colonne numéro de maillot
3. `0003_seed_dijon_sochaux.sql` — Dijon FCO + FC Sochaux
4. `0004_seed_nantes_metz.sql` — FC Nantes + FC Metz
5. `0005_seed_asse_reims.sql` — AS Saint-Étienne + Stade de Reims (+ ajout Killian Corredor à Nantes)
6. `0006_seed_mhsc_rodez_pau_clermont.sql` — Montpellier HSC + Rodez AF + Pau FC + Clermont Foot 63
7. `0007_seed_redstar_grenoble_dunkerque_guingamp.sql` — Red Star FC + Grenoble Foot 38 + USL Dunkerque + EA Guingamp
8. `0008_seed_nancy_boulogne_laval_annecy.sql` — AS Nancy Lorraine + US Boulogne + Stade Lavallois + FC Annecy

## Effectifs — statut : LES 18 CLUBS SONT SAISIS ✅

Méthode retenue : collecte des effectifs sur **Transfermarkt** (captures d'écran fournies
par l'utilisateur — le site bloque l'accès automatisé de Claude), relecture et correction
manuelle systématique par l'utilisateur avant insertion (joueurs partis/prêtés exclus,
postes ajustés, fautes d'orthographe corrigées). Cette relecture humaine reste indispensable
à chaque nouvelle saison / fenêtre de mercato.

Les 18 clubs Ligue 2 BKT 2026-2027 sont en base : Dijon FCO, FC Sochaux-Montbéliard,
FC Nantes, FC Metz, AS Saint-Étienne, Stade de Reims, Montpellier HSC, Rodez AF, Pau FC,
Clermont Foot 63, Red Star FC, Grenoble Foot 38, USL Dunkerque, EA Guingamp,
AS Nancy Lorraine, US Boulogne, Stade Lavallois, FC Annecy.

**Point de vigilance identifié** : certains clubs comptent des homonymes (deux joueurs
avec le même nom de famille, ex. Hachem à Red Star, Koné à Boulogne) — à traiter au cas
par cas dans les scripts SQL futurs (jointure sur prénom + nom, pas seulement le nom).

## Roadmap

**V1 (objectif : jouable entre amis)**
- [x] Schéma Supabase créé à partir du modèle ci-dessus
- [x] Saisie manuelle des 18 clubs + effectifs (poste principal uniquement)
- [ ] Écran de composition d'équipe (formation + sélection contrainte 1/club) ← **prochaine étape**
- [ ] Barème de scoring V1 simple
- [ ] Classement hebdo + saison (une seule ligue)
- [ ] Déploiement Vercel + premier test réel avec les amis

**V2 (si la V1 fonctionne et plaît)**
- [ ] Postes secondaires (Transfermarkt ou saisie enrichie)
- [ ] Automatisation des stats (Sofascore)
- [ ] Plusieurs ligues / ouverture à d'autres utilisateurs
- [ ] Badges / achievements
- [ ] Partage avec sites partenaires (LeDijonShow, Fans Of Nancy, etc.)

## Conventions de travail avec Claude

- Une session = une fonctionnalité ciblée, pas "coder toute l'appli d'un coup"
- Pour un bug : coller le fichier complet concerné + message d'erreur exact + comportement attendu
- Après chaque fonctionnalité qui marche : commit GitHub → déploiement auto Vercel
- Mettre à jour ce fichier après toute décision structurante (scoring, schéma, scope)
- **Continuité entre conversations** : Claude n'a pas de mémoire automatique d'une conversation
  à l'autre (sauf activation du Projet Claude.ai avec fichiers uploadés). Le réflexe fiable :
  redonner le lien du repo GitHub en début de conversation — Claude le clone et relit ce
  fichier + les migrations déjà exécutées pour se remettre à jour.
- **Collecte d'effectifs** : Transfermarkt est la référence, mais Claude ne peut pas y accéder
  seul (site protégé contre l'accès automatisé) → l'utilisateur fournit des captures d'écran,
  Claude construit le tableau, l'utilisateur corrige (départs, prêts, postes, orthographe),
  puis Claude génère le SQL. Attention aux homonymes (même nom de famille, poste différent)
  dans les scripts d'insertion.

---
*Dernière mise à jour : 15 juillet 2026 — schéma + 18 effectifs Ligue 2 2026-2027 en base, prêt pour l'écran de composition d'équipe*
