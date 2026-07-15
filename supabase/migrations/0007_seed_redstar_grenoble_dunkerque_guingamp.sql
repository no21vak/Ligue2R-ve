-- ============================================================
-- Seed 0007 : Red Star FC + Grenoble Foot 38 + USL Dunkerque + EA Guingamp
-- Données collectées via Transfermarkt (captures fournies),
-- corrigées et validées manuellement.
-- ============================================================

-- ------------------------------------------------------------
-- Clubs
-- ------------------------------------------------------------
insert into clubs (name, short_name)
values
  ('Red Star FC', 'Red Star'),
  ('Grenoble Foot 38', 'Grenoble'),
  ('USL Dunkerque', 'Dunkerque'),
  ('EA Guingamp', 'Guingamp')
on conflict (name) do nothing;

-- ------------------------------------------------------------
-- Joueurs — Red Star FC
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Gaëtan',       'Poussin',   16),
  ('Mouez',        'Hassen',    40),
  ('Dylan',        'Durivaux',  20),
  ('Bradley',      'Danger',    27),
  ('Josué',        'Escartin',   5),
  ('Pierre',       'Lemonnier', 24),
  ('Elyaz',        'Zidane',  null),
  ('Matthieu',     'Huard',      3),
  ('Kemo',         'Cissé',     11),
  ('Théo',         'Magnin',     2),
  ('Balthazar',    'Pierret',    4),
  ('Islamdine',    'Halifa',    19),
  ('Ryad',         'Hachem',    98),
  ('Samuel',       'Renel',   null),
  ('Saïf-Eddine',  'Khaoui',    10),
  ('Guillaume',    'Trani',     25),
  ('Kévin',        'Cabral',    91),
  ('Damien',       'Durand',     7),
  ('Jovany',       'Ikanga',    23),
  ('Hacène',       'Benali',    29),
  ('Abdelsamad',   'Hachem',    21)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Red Star FC';

-- Note : deux joueurs partagent le nom "Hachem" (Ryad, milieu, et
-- Abdelsamad, attaquant). Un simple join sur last_name leur donnerait
-- le même poste par erreur, donc ils sont exclus du join générique
-- et traités individuellement (prénom + nom) ci-dessous.
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Red Star FC'
join (values
  ('Poussin',    'GARDIEN'),
  ('Hassen',     'GARDIEN'),
  ('Durivaux',   'DEFENSEUR'),
  ('Danger',     'DEFENSEUR'),
  ('Escartin',   'DEFENSEUR'),
  ('Lemonnier',  'DEFENSEUR'),
  ('Zidane',     'DEFENSEUR'),
  ('Huard',      'DEFENSEUR'),
  ('Cissé',      'DEFENSEUR'),
  ('Magnin',     'DEFENSEUR'),
  ('Pierret',    'MILIEU'),
  ('Halifa',     'MILIEU'),
  ('Renel',      'MILIEU'),
  ('Khaoui',     'MILIEU'),
  ('Trani',      'MILIEU'),
  ('Cabral',     'ATTAQUANT'),
  ('Durand',     'ATTAQUANT'),
  ('Ikanga',     'ATTAQUANT'),
  ('Benali',     'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Red Star FC'
join (values
  ('Ryad',       'Hachem', 'MILIEU'),
  ('Abdelsamad', 'Hachem', 'ATTAQUANT')
) as v(first_name, last_name, position)
  on v.first_name = p.first_name and v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — Grenoble Foot 38
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Alexandre',  'Olliero',   null),
  ('Bobby',      'Allain',      16),
  ('Loris',      'Mouyokolo',   24),
  ('Clément',    'Vidal',        5),
  ('Allan',      'Tchaptchet',  21),
  ('Efe',        'Sarikaya',  null),
  ('Mattheo',    'Xantippe',    27),
  ('Mathieu',    'Mion',        26),
  ('Sakhalou',   'Niakaté',     48),
  ('Ange Loïc',  'N''Gatta',    22),
  ('Yohann',     'Magnin',    null),
  ('Samba',      'Diba',        30),
  ('Lucas',      'Bernadou',     6),
  ('Mael',       'Corboz',      14),
  ('Baptiste',   'Mouazan',     10),
  ('Dillon',     'Hoogewerf',   23),
  ('Nesta',      'Zahui',       19),
  ('Zé',         'Leite',     null),
  ('Mamady',     'Bangré',      11),
  ('Arthur',     'Lallias',      9),
  ('Yadaly',     'Diaby',        7),
  ('Moussa',     'Djitté',       2),
  ('Evans',      'Maurin',      20),
  ('Ugo',        'Bonnet',      12),
  ('Mohamed',    'Bechikh',     37)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Grenoble Foot 38';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Grenoble Foot 38'
join (values
  ('Olliero',     'GARDIEN'),
  ('Allain',      'GARDIEN'),
  ('Mouyokolo',   'DEFENSEUR'),
  ('Vidal',       'DEFENSEUR'),
  ('Tchaptchet',  'DEFENSEUR'),
  ('Sarikaya',    'DEFENSEUR'),
  ('Xantippe',    'DEFENSEUR'),
  ('Mion',        'DEFENSEUR'),
  ('Niakaté',     'DEFENSEUR'),
  ('N''Gatta',    'DEFENSEUR'),
  ('Magnin',      'MILIEU'),
  ('Diba',        'MILIEU'),
  ('Bernadou',    'MILIEU'),
  ('Corboz',      'MILIEU'),
  ('Mouazan',     'MILIEU'),
  ('Hoogewerf',   'ATTAQUANT'),
  ('Zahui',       'ATTAQUANT'),
  ('Leite',       'ATTAQUANT'),
  ('Bangré',      'ATTAQUANT'),
  ('Lallias',     'ATTAQUANT'),
  ('Diaby',       'ATTAQUANT'),
  ('Djitté',      'ATTAQUANT'),
  ('Maurin',      'ATTAQUANT'),
  ('Bonnet',      'ATTAQUANT'),
  ('Bechikh',     'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — USL Dunkerque
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Maxence',      'Prévot',   null),
  ('Moha',         'Ramos',    null),
  ('Mouhamed',     'Sissokho',    36),
  ('Victor',       'Mayela',      22),
  ('Bram',         'Lagae',        4),
  ('Opa',          'Sangante',    26),
  ('Lenny',        'Vallier',   null),
  ('Maedine',      'Makhloufi',   42),
  ('Allan',        'Linguet',     27),
  ('Lenny Dziki',  'Loussilaho',  24),
  ('Théna',        'Massock',     87),
  ('Franck',       'Atoen',     null),
  ('Antoine',      'Sekongo',      8),
  ('Marco',        'Decherf',   null),
  ('Egor',         'Prutsev',   null),
  ('Adrien',       'Lebeau',    null),
  ('Alex',         'Daho',        11),
  ('Souleymane',   'Keita',     null),
  ('Zaid',         'Seha',        57),
  ('Thomas',       'Robinet',      9),
  ('Pape Malick',  'Dieng',     null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'USL Dunkerque';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'USL Dunkerque'
join (values
  ('Prévot',      'GARDIEN'),
  ('Ramos',       'GARDIEN'),
  ('Sissokho',    'GARDIEN'),
  ('Mayela',      'DEFENSEUR'),
  ('Lagae',       'DEFENSEUR'),
  ('Sangante',    'DEFENSEUR'),
  ('Vallier',     'DEFENSEUR'),
  ('Makhloufi',   'DEFENSEUR'),
  ('Linguet',     'DEFENSEUR'),
  ('Loussilaho',  'DEFENSEUR'),
  ('Massock',     'MILIEU'),
  ('Atoen',       'MILIEU'),
  ('Sekongo',     'MILIEU'),
  ('Decherf',     'MILIEU'),
  ('Prutsev',     'MILIEU'),
  ('Lebeau',      'MILIEU'),
  ('Daho',        'ATTAQUANT'),
  ('Keita',       'ATTAQUANT'),
  ('Seha',        'ATTAQUANT'),
  ('Robinet',     'ATTAQUANT'),
  ('Dieng',       'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — EA Guingamp
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Adrián',    'Ortolá',              16),
  ('Teddy',     'Bartouche-Selbonne',   1),
  ('Noah',      'Marec',               40),
  ('Donatien',  'Gomis',                7),
  ('Albin',     'Demouchy',            36),
  ('Idriss',    'Planeix',             38),
  ('Akim',      'Abdallah',            29),
  ('Vimoj',     'Muntu',             null),
  ('Erwin',     'Koffi',                2),
  ('Jérémie',   'Matumona',             3),
  ('Dylan',     'Louiserre',            4),
  ('Tanguy',    'Ahile',               39),
  ('Florent',   'Sanchez',           null),
  ('Darly',     'N''Landu',             6),
  ('Joël',      'Matondo',           null),
  ('Teddy',     'Averlant',            11),
  ('Samir',     'Ben Brahim',        null),
  ('Jasser',    'Chamakh',           null),
  ('Amine',     'Hemia',               10),
  ('Gautier',   'Ott',                 24),
  ('Amadou',    'Samoura',             19),
  ('Stanislas', 'Kielt',               27)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'EA Guingamp';

insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'EA Guingamp'
join (values
  ('Ortolá',              'GARDIEN'),
  ('Bartouche-Selbonne',  'GARDIEN'),
  ('Marec',               'GARDIEN'),
  ('Gomis',               'DEFENSEUR'),
  ('Demouchy',            'DEFENSEUR'),
  ('Planeix',             'DEFENSEUR'),
  ('Abdallah',            'DEFENSEUR'),
  ('Muntu',               'DEFENSEUR'),
  ('Koffi',               'DEFENSEUR'),
  ('Matumona',            'DEFENSEUR'),
  ('Louiserre',           'MILIEU'),
  ('Ahile',               'MILIEU'),
  ('Sanchez',             'MILIEU'),
  ('N''Landu',            'MILIEU'),
  ('Matondo',             'MILIEU'),
  ('Averlant',            'MILIEU'),
  ('Ben Brahim',          'MILIEU'),
  ('Chamakh',             'MILIEU'),
  ('Hemia',               'MILIEU'),
  ('Ott',                 'ATTAQUANT'),
  ('Samoura',             'ATTAQUANT'),
  ('Kielt',               'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ============================================================
-- Fin du seed 0007 — Red Star + Grenoble + Dunkerque + Guingamp
-- ============================================================
