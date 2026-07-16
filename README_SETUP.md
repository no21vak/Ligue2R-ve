# Mise en route — Écran de composition

Ce dossier se fond dans ton repo existant : `package.json`, `app/`, `lib/` sont
nouveaux, et `supabase/migrations/0009_composition_screen_support.sql` vient
s'ajouter à tes migrations 0001-0008 sans y toucher.

## 1. Installer les dépendances

```bash
npm install
```

## 2. Configurer Supabase

1. Copie `.env.local.example` en `.env.local` et remplis avec l'URL et la clé
   anon de ton projet (Dashboard Supabase > Project Settings > API).
2. Dans **Authentication > URL Configuration**, ajoute
   `http://localhost:3000/auth/callback` aux Redirect URLs (sinon le lien
   magique par email ne pourra pas te reconnecter en local).
3. Exécute la nouvelle migration dans le SQL Editor de Supabase :
   `supabase/migrations/0009_composition_screen_support.sql`.
   Elle ajoute la fonction `save_lineup` et — uniquement si aucune ligue ou
   journée n'existe déjà — crée une ligue "Les amis du dimanche" et une
   journée J1 avec le statut `open`, pour pouvoir tester tout de suite.

## 3. Lancer l'app

```bash
npm run dev
```

Va sur `http://localhost:3000` : tu seras redirigé vers `/login`, tu reçois un
lien magique par email, tu choisis un pseudo (tu es alors automatiquement
rattaché à la ligue par défaut), puis tu arrives sur `/compositions`.

## Ce qui reste volontairement hors scope de cette étape

- **RLS (Row Level Security)** : aucune policy n'est encore activée sur les
  tables. Tant que l'app tourne entre potes en dev, ce n'est pas bloquant,
  mais ce sera à faire avant un vrai déploiement partagé.
- **Écran de création/gestion de ligue** : la ligue par défaut est créée par
  la migration de seed. Le vrai flux (créer une ligue, inviter des amis) est
  une prochaine étape.
- **Verrouillage de la composition** : rien n'empêche pour l'instant de
  modifier sa compo après le coup d'envoi (`gameweeks.status` passe à
  `locked` mais l'écran ne vérifie pas encore ce statut).
