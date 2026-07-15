-- ============================================================
-- Seed 0008 : AS Nancy Lorraine + US Boulogne + Stade Lavallois + FC Annecy
-- Derniers des 18 clubs de Ligue 2 BKT 2026-2027.
-- Données collectées via Transfermarkt (captures fournies),
-- corrigées et validées manuellement.
-- ============================================================

-- ------------------------------------------------------------
-- Clubs
-- ------------------------------------------------------------
insert into clubs (name, short_name)
values
  ('AS Nancy Lorraine', 'Nancy'),
  ('US Boulogne', 'Boulogne'),
  ('Stade Lavallois', 'Laval'),
  ('FC Annecy', 'Annecy')
on conflict (name) do nothing;

-- ------------------------------------------------------------
-- Joueurs — AS Nancy Lorraine
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Enzo',       'Basilio',     1),
  ('Kenzo',      'Noël',       40),
  ('Yanis',      'Kouini',   null),
  ('Nehemiah',   'Fernandez',   4),
  ('Elydjah',    'Mendy',      21),
  ('Yannis',     'Nahounou',   77),
  ('Nicolas',    'Saint-Ruf',  14),
  ('Héliodhino', 'Tavares',     2),
  ('Logan',      'Ndenbe',     22),
  ('Enzo',       'Tacafred',   44),
  ('Jérémy',     'Gélin',      25),
  ('Kouroufia',  'Kébé',       19),
  ('Hugo',       'Barbier',    18),
  ('Youssouf',   'Tandia',   null),
  ('Issam',      'Bouaoune',   28),
  ('Chafik',     'El Hansar',  45),
  ('Yanis',      'Delaveau',   24),
  ('Walid',      'Bouabdeli',   8),
  ('Zakaria',    'Fdaouch',     7),
  ('Mattheo',    'Guendez',    34),
  ('Brandon',    'Bokangu',    20),
  ('Sidi',       'Cissé',    null),
  ('Ilyes',      'Housni',      9),
  ('Patrick',    'Ouotro',     29),
  ('Zakaria',    'Ztouti',     26),
  ('Adrian',     'Dabasse',    10)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'AS Nancy Lorraine';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'AS Nancy Lorraine'
join (values
  ('Basilio',    'GARDIEN'),
  ('Noël',       'GARDIEN'),
  ('Kouini',     'GARDIEN'),
  ('Fernandez',  'DEFENSEUR'),
  ('Mendy',      'DEFENSEUR'),
  ('Nahounou',   'DEFENSEUR'),
  ('Saint-Ruf',  'DEFENSEUR'),
  ('Tavares',    'DEFENSEUR'),
  ('Ndenbe',     'DEFENSEUR'),
  ('Tacafred',   'DEFENSEUR'),
  ('Gélin',      'MILIEU'),
  ('Kébé',       'MILIEU'),
  ('Barbier',    'MILIEU'),
  ('Tandia',     'MILIEU'),
  ('Bouaoune',   'MILIEU'),
  ('El Hansar',  'MILIEU'),
  ('Delaveau',   'MILIEU'),
  ('Bouabdeli',  'MILIEU'),
  ('Fdaouch',    'ATTAQUANT'),
  ('Guendez',    'ATTAQUANT'),
  ('Bokangu',    'ATTAQUANT'),
  ('Cissé',      'ATTAQUANT'),
  ('Housni',     'ATTAQUANT'),
  ('Ouotro',     'ATTAQUANT'),
  ('Ztouti',     'ATTAQUANT'),
  ('Dabasse',    'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — US Boulogne
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Blondy',    'Nna Noukeu',    99),
  ('Azamat',    'Uriev',         30),
  ('Ibrahim',   'Koné',          16),
  ('Xavier',    'Lenogue',        1),
  ('Adrien',    'Pinot',         15),
  ('Théo',      'Brusco',      null),
  ('Jonathan',  'Kapenga',        4),
  ('Antoine',   'Kerriou',       25),
  ('Julien',    'Boyer',         12),
  ('Louis',     'Siliadin',      24),
  ('Oscar',     'Lenne',         26),
  ('Zoran',     'Moco',          97),
  ('Demba',     'Thiam',         18),
  ('Nolan',     'Binet',         19),
  ('Joffrey',   'Bultel',        14),
  ('Jonas',     'Martin',        90),
  ('Lilian',    'Raillot',        8),
  ('Sonny',     'Duflos',        22),
  ('Aurélien',  'Platret',       21),
  ('Sohan',     'Paillard',      28),
  ('Abdel',     'Hbouch',      null),
  ('Noah',      'Fatar',         17),
  ('Exaucé',    'Mpembele Boula',27),
  ('Aymane',    'Nassiri',        7),
  ('Martin',    'Lecolier',       9),
  ('Benjamin',  'Bešić',         31),
  ('Zanga',     'Koné',          91)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'US Boulogne';

-- Postes US Boulogne (hors homonymes "Koné", traités séparément juste après)
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'US Boulogne'
join (values
  ('Nna Noukeu',      'GARDIEN'),
  ('Uriev',           'GARDIEN'),
  ('Lenogue',         'GARDIEN'),
  ('Pinot',           'DEFENSEUR'),
  ('Brusco',          'DEFENSEUR'),
  ('Kapenga',         'DEFENSEUR'),
  ('Kerriou',         'DEFENSEUR'),
  ('Boyer',           'DEFENSEUR'),
  ('Siliadin',        'DEFENSEUR'),
  ('Lenne',           'DEFENSEUR'),
  ('Moco',            'DEFENSEUR'),
  ('Thiam',           'DEFENSEUR'),
  ('Binet',           'MILIEU'),
  ('Bultel',          'MILIEU'),
  ('Martin',          'MILIEU'),
  ('Raillot',         'MILIEU'),
  ('Duflos',          'MILIEU'),
  ('Platret',         'MILIEU'),
  ('Paillard',        'MILIEU'),
  ('Hbouch',          'MILIEU'),
  ('Fatar',           'ATTAQUANT'),
  ('Mpembele Boula',  'ATTAQUANT'),
  ('Nassiri',         'ATTAQUANT'),
  ('Lecolier',        'ATTAQUANT'),
  ('Bešić',           'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- Homonymes "Koné" à Boulogne : Ibrahim (gardien) et Zanga (attaquant)
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'US Boulogne'
join (values
  ('Ibrahim', 'Koné', 'GARDIEN'),
  ('Zanga',   'Koné', 'ATTAQUANT')
) as v(first_name, last_name, position)
  on v.first_name = p.first_name and v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — Stade Lavallois
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Mamadou',  'Samassa',              30),
  ('Maxime',   'Hautbois',              1),
  ('Sidi',     'Bane',                 24),
  ('Aboubacar','Lô',                 null),
  ('William',  'Bianda',                3),
  ('Mattéo',   'Commaret',             12),
  ('Moïse',    'Adilehou',           null),
  ('Jules',    'Gaudin',             null),
  ('Layousse', 'Samb',                 35),
  ('Esteban',  'Mouton',             null),
  ('Sam',      'Sanna',                 6),
  ('Francis',  'Coquelin',             13),
  ('Teddy',    'Bouriaud',           null),
  ('Hermann',  'Esmel',                26),
  ('Cyril',    'Mandouki',             14),
  ('Julien',   'Maggiotti',            28),
  ('Malik',    'Sellouki',             10),
  ('Chafik',   'Gourichy',           null),
  ('Ethan',    'Clavreul',             20),
  ('Mamadou',  'Camara',                9),
  ('Trévis',   'Dago',                 11),
  ('Mathys',   'Houdayer',             31),
  ('Abou',     'Kanté',              null),
  ('Noa',      'Mupemba',            null),
  ('Aymeric',  'Faurand-Tournière',  null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Stade Lavallois';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Stade Lavallois'
join (values
  ('Samassa',             'GARDIEN'),
  ('Hautbois',            'GARDIEN'),
  ('Bane',                'DEFENSEUR'),
  ('Lô',                  'DEFENSEUR'),
  ('Bianda',              'DEFENSEUR'),
  ('Commaret',            'DEFENSEUR'),
  ('Adilehou',            'DEFENSEUR'),
  ('Gaudin',              'DEFENSEUR'),
  ('Samb',                'DEFENSEUR'),
  ('Mouton',              'DEFENSEUR'),
  ('Sanna',               'MILIEU'),
  ('Coquelin',            'MILIEU'),
  ('Bouriaud',            'MILIEU'),
  ('Esmel',               'MILIEU'),
  ('Mandouki',            'MILIEU'),
  ('Maggiotti',           'MILIEU'),
  ('Sellouki',            'MILIEU'),
  ('Gourichy',            'MILIEU'),
  ('Clavreul',            'ATTAQUANT'),
  ('Camara',              'ATTAQUANT'),
  ('Dago',                'ATTAQUANT'),
  ('Houdayer',            'ATTAQUANT'),
  ('Kanté',               'ATTAQUANT'),
  ('Mupemba',             'ATTAQUANT'),
  ('Faurand-Tournière',   'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — FC Annecy
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Florian',  'Escales',             1),
  ('Thomas',   'Callens',            16),
  ('Mateo',    'Gonzalez',           30),
  ('Axel',     'Drouhin',            18),
  ('Julien',   'Kouadio',            27),
  ('Thibault', 'Delphis',            41),
  ('François', 'Lajugie',             6),
  ('Mattéo',   'Veillon',            23),
  ('Esteban',  'Riou',               34),
  ('Emmanuel', 'Louisir',          null),
  ('Sacha',    'Lima',             null),
  ('Esteban',  'Marre',            null),
  ('Ahmed',    'Kashi',               5),
  ('Paul',     'Venot',              25),
  ('Alexis',   'Casadei',            29),
  ('Nolan',    'Ferro',              24),
  ('Clément',  'Billemaz',           22),
  ('Kilyan',   'Jusseron-Veniere',   19),
  ('Kadan',    'Young',            null),
  ('Alan',     'Mondesir',         null),
  ('Antoine',  'Larose',             28),
  ('Moïse',    'Sahi Dion',          80),
  ('Ben Hamed','Touré',              71),
  ('Zepiqueno','Redmond',          null),
  ('Thibault', 'Rambaud',             9),
  ('Adam',     'Yahi',             null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'FC Annecy';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'FC Annecy'
join (values
  ('Escales',            'GARDIEN'),
  ('Callens',            'GARDIEN'),
  ('Gonzalez',           'GARDIEN'),
  ('Drouhin',            'DEFENSEUR'),
  ('Kouadio',            'DEFENSEUR'),
  ('Delphis',            'DEFENSEUR'),
  ('Lajugie',            'DEFENSEUR'),
  ('Veillon',            'DEFENSEUR'),
  ('Riou',               'DEFENSEUR'),
  ('Louisir',            'DEFENSEUR'),
  ('Lima',               'DEFENSEUR'),
  ('Marre',              'DEFENSEUR'),
  ('Kashi',              'MILIEU'),
  ('Venot',              'MILIEU'),
  ('Casadei',            'MILIEU'),
  ('Ferro',              'MILIEU'),
  ('Billemaz',           'MILIEU'),
  ('Jusseron-Veniere',   'MILIEU'),
  ('Young',              'ATTAQUANT'),
  ('Mondesir',           'ATTAQUANT'),
  ('Larose',             'ATTAQUANT'),
  ('Sahi Dion',          'ATTAQUANT'),
  ('Touré',              'ATTAQUANT'),
  ('Redmond',            'ATTAQUANT'),
  ('Rambaud',            'ATTAQUANT'),
  ('Yahi',               'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ============================================================
-- Fin du seed 0008 — Nancy + Boulogne + Laval + Annecy
-- Les 18 clubs de Ligue 2 BKT 2026-2027 sont maintenant tous en base.
-- ============================================================
