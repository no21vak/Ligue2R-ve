-- ============================================================
-- Seed 0005 : AS Saint-Étienne + Stade de Reims
-- + ajout de Killian Corredor à l'effectif du FC Nantes
-- Données collectées via Transfermarkt (captures fournies),
-- corrigées et validées manuellement.
-- ============================================================

-- ------------------------------------------------------------
-- Clubs
-- ------------------------------------------------------------
insert into clubs (name, short_name)
values
  ('AS Saint-Étienne', 'ASSE'),
  ('Stade de Reims', 'Reims')
on conflict (name) do nothing;

-- ------------------------------------------------------------
-- Joueurs — AS Saint-Étienne
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Gautier',      'Larsonneur',    30),
  ('Mamour',       'Ndiaye',         1),
  ('Chico',        'Lamba',         15),
  ('Mickaël',      'Nadé',           3),
  ('Sohaib',       'Naïr',          18),
  ('Julien',       'Le Cardinal',   26),
  ('Maxime',       'Bernauer',       6),
  ('Ben',          'Old',           11),
  ('Ebenezer',     'Annan',         19),
  ('Lassana',      'Traoré',        34),
  ('Kévin',        'Pedro',         39),
  ('João',         'Ferreira',      13),
  ('Strahinja',    'Stojkovic',      2),
  ('Pierre',       'Ekwah',       null),
  ('Mahmoud',      'Jaber',          5),
  ('Aïmen',        'Moueffek',      29),
  ('Luan',         'Gadegbeku',     35),
  ('Paul',         'Eymard',        36),
  ('Augustine',    'Boakye',        20),
  ('Jakob',        'Breum',         10),
  ('Igor',         'Miladinovic',   28),
  ('Nadir',        'El Jamali',     31),
  ('Zuriko',       'Davitashvili',  22),
  ('Thierno',      'Ballo',          8),
  ('Irvin',        'Cardona',        7),
  ('Lucas',        'Stassin',        9),
  ('Djylian',      'N''Guessan',    25),
  ('Joshua',       'Duffus',        17),
  ('Marten-Chris', 'Paalberg',      49)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'AS Saint-Étienne';

-- ------------------------------------------------------------
-- Postes — AS Saint-Étienne
-- ------------------------------------------------------------
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'AS Saint-Étienne'
join (values
  ('Larsonneur',   'GARDIEN'),
  ('Ndiaye',       'GARDIEN'),
  ('Lamba',        'DEFENSEUR'),
  ('Nadé',         'DEFENSEUR'),
  ('Naïr',         'DEFENSEUR'),
  ('Le Cardinal',  'DEFENSEUR'),
  ('Bernauer',     'DEFENSEUR'),
  ('Old',          'DEFENSEUR'),
  ('Annan',        'DEFENSEUR'),
  ('Traoré',       'DEFENSEUR'),
  ('Pedro',        'DEFENSEUR'),
  ('Ferreira',     'DEFENSEUR'),
  ('Stojkovic',    'DEFENSEUR'),
  ('Ekwah',        'MILIEU'),
  ('Jaber',        'MILIEU'),
  ('Moueffek',     'MILIEU'),
  ('Gadegbeku',    'MILIEU'),
  ('Eymard',       'MILIEU'),
  ('Boakye',       'MILIEU'),
  ('Breum',        'MILIEU'),
  ('Miladinovic',  'MILIEU'),
  ('El Jamali',    'MILIEU'),
  ('Davitashvili', 'ATTAQUANT'),
  ('Ballo',        'ATTAQUANT'),
  ('Cardona',      'ATTAQUANT'),
  ('Stassin',      'ATTAQUANT'),
  ('N''Guessan',   'ATTAQUANT'),
  ('Duffus',       'ATTAQUANT'),
  ('Paalberg',     'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — Stade de Reims
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Tom Ritzy',  'Hülsmann',       1),
  ('Edin',       'Omeragic',      12),
  ('Alexis',     'Sauvage',     null),
  ('Soumaïla',   'Sylla',         94),
  ('Samuel',     'Kotto',       null),
  ('Joseph',     'Okumu',          2),
  ('Malcolm',    'Jeng',        null),
  ('Elie',       'N''Tamon',      28),
  ('Daouda',     'Guindo',      null),
  ('Sergio',     'Akieme',        18),
  ('Mory',       'Gbane',         24),
  ('Théo',       'Leoni',          6),
  ('Yaya',       'Fofana',         8),
  ('John',       'Patrick',       30),
  ('Yohan',      'Demoncy',     null),
  ('Martial',    'Tia',           87),
  ('Reda',       'Khadra',      null),
  ('Keito',      'Nakamura',      17),
  ('Mohamed',    'Daramy',         9),
  ('Ike',        'Orazi',         73),
  ('Thiemoko',   'Diarra',         7),
  ('Antoine',    'Leautey',     null),
  ('Oumar',      'Diakité',     null),
  ('Sambou',     'Soumano',       99),
  ('Hafiz',      'Umar Ibrahim',  85),
  ('Jordan',     'Siebatcheu',  null),
  ('Adama',      'Bojang',        27),
  ('Amine',      'Salama',      null),
  ('Youssef',    'El Kachati',  null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Stade de Reims';

-- ------------------------------------------------------------
-- Postes — Stade de Reims
-- ------------------------------------------------------------
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Stade de Reims'
join (values
  ('Hülsmann',      'GARDIEN'),
  ('Omeragic',      'GARDIEN'),
  ('Sauvage',       'GARDIEN'),
  ('Sylla',         'GARDIEN'),
  ('Kotto',         'DEFENSEUR'),
  ('Okumu',         'DEFENSEUR'),
  ('Jeng',          'DEFENSEUR'),
  ('N''Tamon',      'DEFENSEUR'),
  ('Guindo',        'DEFENSEUR'),
  ('Akieme',        'DEFENSEUR'),
  ('Gbane',         'MILIEU'),
  ('Leoni',         'MILIEU'),
  ('Fofana',        'MILIEU'),
  ('Patrick',       'MILIEU'),
  ('Demoncy',       'MILIEU'),
  ('Tia',           'MILIEU'),
  ('Khadra',        'MILIEU'),
  ('Nakamura',      'ATTAQUANT'),
  ('Daramy',        'ATTAQUANT'),
  ('Orazi',         'ATTAQUANT'),
  ('Diarra',        'ATTAQUANT'),
  ('Leautey',       'ATTAQUANT'),
  ('Diakité',       'ATTAQUANT'),
  ('Soumano',       'ATTAQUANT'),
  ('Umar Ibrahim',  'ATTAQUANT'),
  ('Siebatcheu',    'ATTAQUANT'),
  ('Bojang',        'ATTAQUANT'),
  ('Salama',        'ATTAQUANT'),
  ('El Kachati',    'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Ajout : Killian Corredor rejoint le FC Nantes (mercato, en
-- provenance de Darmstadt 98, ancien joueur de Rodez)
-- Nécessite que le FC Nantes existe déjà en base (seed 0004).
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, 'Killian', 'Corredor', 12
from clubs
where clubs.name = 'FC Nantes';

insert into player_positions (player_id, position, is_primary)
select p.id, 'ATTAQUANT', true
from players p
join clubs c on c.id = p.club_id and c.name = 'FC Nantes'
where p.last_name = 'Corredor';

-- ============================================================
-- Fin du seed 0005 — AS Saint-Étienne + Stade de Reims + Corredor
-- ============================================================
