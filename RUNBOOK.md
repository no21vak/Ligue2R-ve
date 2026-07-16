# Runbook — Gestion manuelle des journées

Tant qu'il n'y a pas d'écran admin ni d'automatisation, ce rituel est à faire
à la main chaque semaine dans le **SQL Editor** de Supabase.

## Rituel hebdomadaire : clore une journée et ouvrir la suivante

```sql
-- 1. Clore la journée qui vient de se terminer (une fois les matchs joués).
update gameweeks set status = 'completed' where number = 1 and season = '2026-2027';

-- 2. Créer et ouvrir la journée suivante, avec l'heure exacte du coup d'envoi.
insert into gameweeks (number, season, start_date, end_date, status, lock_at)
values (
  2,                              -- numéro de la journée (doit être > à la précédente)
  '2026-2027',                    -- saison
  '2026-07-25',                   -- date du premier match
  '2026-07-27',                   -- date du dernier match
  'open',
  '2026-07-25 15:00:00+02'        -- heure précise du coup d'envoi (fuseau Paris, +02 en été / +01 en hiver)
);
```

Dès que cette ligne existe avec `status = 'open'`, l'écran de composition
bascule automatiquement dessus pour tout le monde — l'appli va chercher la
journée `open`/`locked` avec le numéro le plus élevé, sans changement de code
nécessaire.

**Points d'attention :**
- `number` doit toujours être supérieur à celui de la journée précédente,
  sinon l'appli ne saura pas laquelle est "la plus récente".
- `(season, number)` doit être unique (déjà garanti par une contrainte de la
  base — une tentative en doublon échouera proprement).

## Pendant les tests : déverrouiller sans perdre les données

```sql
update gameweeks set status = 'open', lock_at = null where number = 1 and season = '2026-2027';
```

## Repartir de zéro sur une journée de test

```sql
delete from gameweeks where number = 1 and season = '2026-2027';
```

⚠️ **Attention** : `lineups.gameweek_id` est en `on delete cascade`. Supprimer
une journée supprime automatiquement **toutes les compositions liées**
(les tiennes et celles de tes amis). Pratique en phase de test, dangereux une
fois l'appli utilisée pour de vrai — dans ce cas, préfère toujours la requête
de déverrouillage ci-dessus plutôt que la suppression.
