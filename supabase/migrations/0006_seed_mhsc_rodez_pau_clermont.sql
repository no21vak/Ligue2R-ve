-- ============================================================
-- Seed 0006 : Montpellier HSC + Rodez AF + Pau FC + Clermont Foot 63
-- Données collectées via Transfermarkt (captures fournies),
-- corrigées et validées manuellement.
-- ============================================================

-- ------------------------------------------------------------
-- Clubs
-- ------------------------------------------------------------
insert into clubs (name, short_name)
values
  ('Montpellier HSC', 'Montpellier'),
  ('Rodez AF', 'Rodez'),
  ('Pau FC', 'Pau'),
  ('Clermont Foot 63', 'Clermont')
on conflict (name) do nothing;

-- ------------------------------------------------------------
-- Joueurs — Montpellier HSC
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Simon',     'Ngapandouetnbu', 31),
  ('Viktor',    'Dzodic',         50),
  ('Mathieu',   'Michel',          1),
  ('Yaël',      'Mouanga',        23),
  ('Daylam',    'Meddah',         27),
  ('Julien',    'Laporte',        15),
  ('Théo',      'Sainte-Luce',    17),
  ('Lucas',     'Mincarelli',     21),
  ('Enzo',      'Tchato',         29),
  ('Wilfried',  'Ndollo',         49),
  ('Everson',   'Jr',             77),
  ('Théo',      'Chennahi',       44),
  ('Khalil',    'Fayad',          10),
  ('Florian',   'Tardieu',         5),
  ('Nabil',     'Homssa',         20),
  ('Yanis',     'Issoufou',        8),
  ('Nicolas',   'Pays',           18),
  ('Axel',      'Guéguin',        22),
  ('Alexandre', 'Mendy',          19),
  ('Junior',    'Ndiaye',       null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Montpellier HSC';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Montpellier HSC'
join (values
  ('Ngapandouetnbu', 'GARDIEN'),
  ('Dzodic',         'GARDIEN'),
  ('Michel',         'GARDIEN'),
  ('Mouanga',        'DEFENSEUR'),
  ('Meddah',         'DEFENSEUR'),
  ('Laporte',        'DEFENSEUR'),
  ('Sainte-Luce',    'DEFENSEUR'),
  ('Mincarelli',     'DEFENSEUR'),
  ('Tchato',         'DEFENSEUR'),
  ('Ndollo',         'DEFENSEUR'),
  ('Jr',             'MILIEU'),
  ('Chennahi',       'MILIEU'),
  ('Fayad',          'MILIEU'),
  ('Tardieu',        'MILIEU'),
  ('Homssa',         'MILIEU'),
  ('Issoufou',       'ATTAQUANT'),
  ('Pays',           'ATTAQUANT'),
  ('Guéguin',        'ATTAQUANT'),
  ('Mendy',          'ATTAQUANT'),
  ('Ndiaye',         'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — Rodez AF
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Quentin',  'Braat',           1),
  ('Lucas',    'Margueron',      16),
  ('Enzo',     'Crombez',        30),
  ('Raphaël',  'Lipinski',        3),
  ('Mathis',   'Magnin',          4),
  ('Loni',     'Laurent',        24),
  ('Clément',  'Jolibois',        5),
  ('Dylan',    'Vangi',          21),
  ('Evans',    'Jean-Lambert',   15),
  ('Cheick',   'Doumbia',      null),
  ('Nolan',    'Galves',         25),
  ('Antonin',  'Cartillier',     29),
  ('Jordan',   'Mendes',          6),
  ('Samy',     'Benchamma',      26),
  ('Damjan',   'Pavlovic',        8),
  ('Octave',   'Joly',           22),
  ('Yanis',    'Dahalani',       34),
  ('Ryan',     'Ponti',          20),
  ('Corentin', 'Issanchou',      13),
  ('Mathis',   'Touho',          11),
  ('Ibrahima', 'Baldé',          18),
  ('Kenny',    'Nagera',          9),
  ('Mehdi',    'Baaloudj',       10),
  ('Hermann',  'Tebily',         19)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Rodez AF';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Rodez AF'
join (values
  ('Braat',         'GARDIEN'),
  ('Margueron',     'GARDIEN'),
  ('Crombez',       'GARDIEN'),
  ('Lipinski',      'DEFENSEUR'),
  ('Magnin',        'DEFENSEUR'),
  ('Laurent',       'DEFENSEUR'),
  ('Jolibois',      'DEFENSEUR'),
  ('Vangi',         'DEFENSEUR'),
  ('Jean-Lambert',  'DEFENSEUR'),
  ('Doumbia',       'DEFENSEUR'),
  ('Galves',        'DEFENSEUR'),
  ('Cartillier',    'DEFENSEUR'),
  ('Mendes',        'MILIEU'),
  ('Benchamma',     'MILIEU'),
  ('Pavlovic',      'MILIEU'),
  ('Joly',          'MILIEU'),
  ('Dahalani',      'MILIEU'),
  ('Ponti',         'MILIEU'),
  ('Issanchou',     'MILIEU'),
  ('Touho',         'ATTAQUANT'),
  ('Baldé',         'ATTAQUANT'),
  ('Nagera',        'ATTAQUANT'),
  ('Baaloudj',      'ATTAQUANT'),
  ('Tebily',        'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — Pau FC
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Esteban',     'Salles',        30),
  ('Brice',       'Mauleu',      null),
  ('Axel',        'Bamba',         88),
  ('Anthony',     'Briançon',      23),
  ('Gaëtan',      'Paquiez',       29),
  ('Rony',        'Mimb Baheng', null),
  ('Joseph',      'Kalulu',         3),
  ('Souleymane',  'Basse',          8),
  ('Tom',         'Pouilly',        2),
  ('Rayan',       'Touzghar',      84),
  ('Cheikh',      'Fall',           6),
  ('Steeve',      'Beusnard',      21),
  ('Giovani',     'Versini',       10),
  ('Alexis',      'Lefebvre',      11),
  ('Royce',       'Openda',        14),
  ('Babacar',     'Leye',        null),
  ('Abdoulaye',   'Mbaye',       null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Pau FC';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Pau FC'
join (values
  ('Salles',        'GARDIEN'),
  ('Mauleu',        'GARDIEN'),
  ('Bamba',         'DEFENSEUR'),
  ('Briançon',      'DEFENSEUR'),
  ('Paquiez',       'DEFENSEUR'),
  ('Mimb Baheng',   'DEFENSEUR'),
  ('Kalulu',        'DEFENSEUR'),
  ('Basse',         'DEFENSEUR'),
  ('Pouilly',       'DEFENSEUR'),
  ('Touzghar',      'MILIEU'),
  ('Fall',          'MILIEU'),
  ('Beusnard',      'MILIEU'),
  ('Versini',       'ATTAQUANT'),
  ('Lefebvre',      'ATTAQUANT'),
  ('Openda',        'ATTAQUANT'),
  ('Leye',          'ATTAQUANT'),
  ('Mbaye',         'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — Clermont Foot 63
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Théo',            'Guivarch',    30),
  ('Massamba',        'N''Diaye',    16),
  ('Ivan',            'M''Bahia',    28),
  ('Andy',            'Pelmard',   null),
  ('Yoann',           'Salmier',     21),
  ('Matys',           'Donavin',     45),
  ('El Hadj',         'Koné',        38),
  ('Vital',           'Nsimba',    null),
  ('Kenji-Van',       'Boto',        97),
  ('Cheick Oumar',    'Konaté',    null),
  ('Ibrahim',         'Coulibaly',   93),
  ('Julien',          'Astic',       13),
  ('Abdellah',        'Baallal',      2),
  ('Allan',           'Ackra',       44),
  ('Yuliwes',         'Bellache',     8),
  ('Maïdine',         'Douane',      11),
  ('Enzo',            'Cantero',     77),
  ('Ousmane',         'Diop',        17),
  ('Mohamed-Amine',   'Bouchenna', null),
  ('Adrien',          'Hunou',       23),
  ('Arthur',          'Saintorens', null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Clermont Foot 63';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Clermont Foot 63'
join (values
  ('Guivarch',    'GARDIEN'),
  ('N''Diaye',    'GARDIEN'),
  ('M''Bahia',    'DEFENSEUR'),
  ('Pelmard',     'DEFENSEUR'),
  ('Salmier',     'DEFENSEUR'),
  ('Donavin',     'DEFENSEUR'),
  ('Koné',        'DEFENSEUR'),
  ('Nsimba',      'DEFENSEUR'),
  ('Boto',        'DEFENSEUR'),
  ('Konaté',      'DEFENSEUR'),
  ('Coulibaly',   'DEFENSEUR'),
  ('Astic',       'MILIEU'),
  ('Baallal',     'MILIEU'),
  ('Ackra',       'MILIEU'),
  ('Bellache',    'MILIEU'),
  ('Douane',      'ATTAQUANT'),
  ('Cantero',     'ATTAQUANT'),
  ('Diop',        'ATTAQUANT'),
  ('Bouchenna',   'ATTAQUANT'),
  ('Hunou',       'ATTAQUANT'),
  ('Saintorens',  'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ============================================================
-- Fin du seed 0006 — Montpellier HSC + Rodez AF + Pau FC + Clermont Foot 63
-- ============================================================
