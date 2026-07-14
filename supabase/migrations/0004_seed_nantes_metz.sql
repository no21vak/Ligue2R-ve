-- ============================================================
-- Seed 0004 : Clubs + effectifs FC Nantes et FC Metz
-- Données collectées (ESPN, faute d'accès automatisé à
-- Transfermarkt qui bloque les requêtes de ce type) et
-- corrigées/validées manuellement suite au mercato estival 2026.
-- ============================================================

-- ------------------------------------------------------------
-- Clubs
-- ------------------------------------------------------------
insert into clubs (name, short_name)
values
  ('FC Nantes', 'Nantes'),
  ('FC Metz', 'Metz')
on conflict (name) do nothing;

-- ------------------------------------------------------------
-- Joueurs — FC Nantes
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Alexis',      'Mirbach',        1),
  ('Alban',       'Lafont',        40),
  ('Maxime',      'Dupé',        null),
  ('Ali',         'Youssif',        2),
  ('Chidozie',    'Awaziem',        6),
  ('Fabien',      'Centonze',      18),
  ('Frédéric',    'Guilbert',      24),
  ('Enzo',        'Mongo',         46),
  ('Hugo',        'Lamy',          65),
  ('Sékou',       'Doucouré',      72),
  ('Tylel',       'Tati',          78),
  ('Kelvin',      'Amian',         98),
  ('Louka',       'Gautier',     null),
  ('Jean-Kévin',  'Duverne',       29),
  ('Sacha',       'Ziani',       null),
  ('Johann',      'Lepenant',    null),
  ('Dehmaine',    'Tabibou',       17),
  ('Ibrahima',    'Sissoko',       28),
  ('Bahmed',      'Deuff',         52),
  ('Louis',       'Leroux',        66),
  ('Malang',      'Gomes',       null),
  ('Lamine',      'Diack',         25),
  ('Wilitty',     'Younoussa',   null),
  ('Junior',      'Koné',        null),
  ('Matthis',     'Abline',        10),
  ('Mostafa',     'Mohamed',       31),
  ('Klaus',       'Camara',      null),
  ('Herba',       'Guirassy',      11),
  ('Yassine',     'Benhattab',     90),
  ('Ignatius',    'Ganago',        17)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'FC Nantes';

-- ------------------------------------------------------------
-- Postes — FC Nantes
-- ------------------------------------------------------------
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'FC Nantes'
join (values
  ('Mirbach',    'GARDIEN'),
  ('Lafont',     'GARDIEN'),
  ('Dupé',       'GARDIEN'),
  ('Youssif',    'DEFENSEUR'),
  ('Awaziem',    'DEFENSEUR'),
  ('Centonze',   'DEFENSEUR'),
  ('Guilbert',   'DEFENSEUR'),
  ('Mongo',      'DEFENSEUR'),
  ('Lamy',       'DEFENSEUR'),
  ('Doucouré',   'DEFENSEUR'),
  ('Tati',       'DEFENSEUR'),
  ('Amian',      'DEFENSEUR'),
  ('Gautier',    'DEFENSEUR'),
  ('Duverne',    'DEFENSEUR'),
  ('Ziani',      'MILIEU'),
  ('Lepenant',   'MILIEU'),
  ('Tabibou',    'MILIEU'),
  ('Sissoko',    'MILIEU'),
  ('Deuff',      'MILIEU'),
  ('Leroux',     'MILIEU'),
  ('Gomes',      'MILIEU'),
  ('Diack',      'MILIEU'),
  ('Younoussa',  'MILIEU'),
  ('Koné',       'ATTAQUANT'),
  ('Abline',     'ATTAQUANT'),
  ('Mohamed',    'ATTAQUANT'),
  ('Camara',     'ATTAQUANT'),
  ('Guirassy',   'ATTAQUANT'),
  ('Benhattab',  'ATTAQUANT'),
  ('Ganago',     'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — FC Metz
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Jonathan',      'Fischer',           1),
  ('Romain',        'Jean-Baptiste',    16),
  ('Ousmane',       'Ba',               40),
  ('Pape',          'Sy',               61),
  ('Maxime',        'Colin',             2),
  ('Moustapha',     'Diop',              3),
  ('Urie-Michel',   'Mboula',            4),
  ('Cléo',          'Mélières',         25),
  ('Bouna',         'Sarr',             70),
  ('Tahirys',       'Dos Santos',     null),
  ('Florian',       'Miguel',         null),
  ('Jean',          'Ruiz',           null),
  ('Alpha',         'Touré',            12),
  ('Jessy',         'Deminguet',        20),
  ('Believe',       'Munongo',          33),
  ('Jahyann',       'Pandore',          35),
  ('Gauthier',      'Hein',             10),
  ('Giorgi',        'Abuashvili',        9),
  ('Joseph',        'Mangondo',         17),
  ('Habib',         'Diallo',           30),
  ('Nathan',        'Mbala',            34),
  ('Ibou',          'Sané',           null),
  ('Pape Moussa',   'Fall',           null),
  ('Edouard',       'Soumah-Abbad',   null),
  ('Morgan',        'Bokélé',         null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'FC Metz';

-- ------------------------------------------------------------
-- Postes — FC Metz
-- ------------------------------------------------------------
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'FC Metz'
join (values
  ('Fischer',       'GARDIEN'),
  ('Jean-Baptiste', 'GARDIEN'),
  ('Ba',            'GARDIEN'),
  ('Sy',            'GARDIEN'),
  ('Colin',         'DEFENSEUR'),
  ('Diop',          'DEFENSEUR'),
  ('Mboula',        'DEFENSEUR'),
  ('Mélières',      'DEFENSEUR'),
  ('Sarr',          'DEFENSEUR'),
  ('Dos Santos',    'DEFENSEUR'),
  ('Miguel',        'DEFENSEUR'),
  ('Ruiz',          'DEFENSEUR'),
  ('Touré',         'MILIEU'),
  ('Deminguet',     'MILIEU'),
  ('Munongo',       'MILIEU'),
  ('Pandore',       'MILIEU'),
  ('Hein',          'MILIEU'),
  ('Abuashvili',    'ATTAQUANT'),
  ('Mangondo',      'ATTAQUANT'),
  ('Diallo',        'ATTAQUANT'),
  ('Mbala',         'ATTAQUANT'),
  ('Sané',          'ATTAQUANT'),
  ('Fall',          'ATTAQUANT'),
  ('Soumah-Abbad',  'ATTAQUANT'),
  ('Bokélé',        'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ============================================================
-- Fin du seed 0004 — FC Nantes + FC Metz
-- ============================================================
