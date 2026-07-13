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

## Modèle de données (résumé)

Tables principales : `USERS`, `LEAGUES`, `LEAGUE_MEMBERS`, `PLAYERS`, `PLAYER_POSITIONS`,
`GAMEWEEKS`, `LINEUPS`, `LINEUP_SLOTS`, `PLAYER_GAMEWEEK_STATS`.
(Schéma détaillé discuté et validé en conversation — voir historique ou redemander
à Claude de le régénérer à partir de cette liste si besoin.)

## Roadmap

**V1 (objectif : jouable entre amis)**
- [ ] Schéma Supabase créé à partir du modèle ci-dessus
- [ ] Saisie manuelle des 18 clubs + effectifs (poste principal uniquement)
- [ ] Écran de composition d'équipe (formation + sélection contrainte 1/club)
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

---
*Dernière mise à jour : à compléter au fil du projet*
