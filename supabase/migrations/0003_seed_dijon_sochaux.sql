-- ============================================================
-- Seed 0003 : Clubs + effectifs Dijon FCO et FC Sochaux-Montbéliard
-- Données collectées sur les sites officiels des clubs (juillet 2026),
-- corrigées et validées manuellement.
-- ============================================================

-- ------------------------------------------------------------
-- Clubs
-- ------------------------------------------------------------
insert into clubs (name, short_name)
values
  ('Dijon FCO', 'Dijon'),
  ('FC Sochaux-Montbéliard', 'Sochaux')
on conflict (name) do nothing;

-- ------------------------------------------------------------
-- Joueurs — Dijon FCO
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Enzo',        'Ketterle',     71),
  ('Paul',        'Delecroix',    16),
  ('Ylann',       'Marie-Rose',   46),
  ('Moussa',      'Faty',         31),
  ('Axel',        'Bargain',      15),
  ('Ismaïl',      'Bouleghcha',   93),
  ('Lenny',       'Lacroix',      23),
  ('Waly',        'Diouf',         6),
  ('Fady',        'Khatir',        3),
  ('Quentin',     'Bernard',       5),
  ('César',       'Obongo',       null),
  ('Boubacar',    'Diallo',       null),
  ('Anass',       'Benyahya',     null),
  ('Michaël',     'Barreto',       4),
  ('Samy',        'Chouchane',    21),
  ('Brandon',     'Ndezi',        18),
  ('Paul',        'Bellon',        8),
  ('Ylan',        'Aka',          null),
  ('Ben-Chayeel', 'Hamada',        7),
  ('Jordan',      'Marié',        14),
  ('Adel',        'Lembezat',     17),
  ('Hugo',        'Vargas-Rios',  20),
  ('Hatem',       'Mimoune',      null),
  ('Julio',       'Tavares',      null),
  ('Julien',      'Domingues',    22),
  ('Alexis',      'Ntamack',      29),
  ('Yanis',       'Barka',         9),
  ('Florian',     'Rombogouera',  33),
  ('Abd-Elmajid', 'Djae',         37),
  ('Tyris',       'Dong',         null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'Dijon FCO';

-- ------------------------------------------------------------
-- Postes — Dijon FCO
-- ------------------------------------------------------------
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'Dijon FCO'
join (values
  ('Ketterle',     'GARDIEN'),
  ('Delecroix',    'GARDIEN'),
  ('Marie-Rose',   'GARDIEN'),
  ('Faty',         'DEFENSEUR'),
  ('Bargain',      'DEFENSEUR'),
  ('Bouleghcha',   'DEFENSEUR'),
  ('Lacroix',      'DEFENSEUR'),
  ('Diouf',        'DEFENSEUR'),
  ('Khatir',       'DEFENSEUR'),
  ('Bernard',      'DEFENSEUR'),
  ('Obongo',       'DEFENSEUR'),
  ('Diallo',       'DEFENSEUR'),
  ('Benyahya',     'DEFENSEUR'),
  ('Barreto',      'MILIEU'),
  ('Chouchane',    'MILIEU'),
  ('Ndezi',        'MILIEU'),
  ('Bellon',       'MILIEU'),
  ('Aka',          'MILIEU'),
  ('Hamada',       'MILIEU'),
  ('Marié',        'MILIEU'),
  ('Lembezat',     'MILIEU'),
  ('Vargas-Rios',  'MILIEU'),
  ('Mimoune',      'MILIEU'),
  ('Tavares',      'ATTAQUANT'),
  ('Domingues',    'ATTAQUANT'),
  ('Ntamack',      'ATTAQUANT'),
  ('Barka',        'ATTAQUANT'),
  ('Rombogouera',  'ATTAQUANT'),
  ('Djae',         'ATTAQUANT'),
  ('Dong',         'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ------------------------------------------------------------
-- Joueurs — FC Sochaux-Montbéliard
-- ------------------------------------------------------------
insert into players (club_id, first_name, last_name, jersey_number)
select id, v.first_name, v.last_name, v.jersey_number
from clubs, (values
  ('Mehdi',           'Jeannin',              1),
  ('Matthis',         'Schübler-Lecart',     16),
  ('Alexandre',       'Pierre',              30),
  ('Dalangunypole',   'Gomis',                3),
  ('Arthur',          'Vitelli',              4),
  ('Mathieu',         'Peybernes',           14),
  ('Bendjaloud',      'Youssouf',            17),
  ('Dylan',           'Tavares',             24),
  ('Élie',            'N''Gatta',            26),
  ('Honoré',          'Bayanginisa',          8),
  ('Jonathan',        'Mexique',             15),
  ('Victor',          'Lobry',               19),
  ('Julien',          'Masson',              23),
  ('Bakary',          'Diawara',            null),
  ('Samy',            'Baghdadi',             5),
  ('Benjamin',        'Gomel',                7),
  ('Kapit',           'Djoco',                9),
  ('Boubacar',        'Fofana',              10),
  ('Julien',          'Vetro',               11),
  ('Aboubacar',       'Sidibé',              12),
  ('Victor',          'Monthieu',            25),
  ('Aymen',           'Boutoutaou',          28),
  ('Ethan',           'Cortes',              29),
  ('Mathis',          'Clairicia',           91),
  ('Marie-Gaël',      'Mukanya',            null)
) as v(first_name, last_name, jersey_number)
where clubs.name = 'FC Sochaux-Montbéliard';

-- ------------------------------------------------------------
-- Postes — FC Sochaux-Montbéliard
-- ------------------------------------------------------------
insert into player_positions (player_id, position, is_primary)
select p.id, v.position, true
from players p
join clubs c on c.id = p.club_id and c.name = 'FC Sochaux-Montbéliard'
join (values
  ('Jeannin',          'GARDIEN'),
  ('Schübler-Lecart',  'GARDIEN'),
  ('Pierre',           'GARDIEN'),
  ('Gomis',            'DEFENSEUR'),
  ('Vitelli',          'DEFENSEUR'),
  ('Peybernes',        'DEFENSEUR'),
  ('Youssouf',         'DEFENSEUR'),
  ('Tavares',          'DEFENSEUR'),
  ('N''Gatta',         'DEFENSEUR'),
  ('Bayanginisa',      'MILIEU'),
  ('Mexique',          'MILIEU'),
  ('Lobry',            'MILIEU'),
  ('Masson',           'MILIEU'),
  ('Diawara',          'MILIEU'),
  ('Baghdadi',         'ATTAQUANT'),
  ('Gomel',            'ATTAQUANT'),
  ('Djoco',            'ATTAQUANT'),
  ('Fofana',           'ATTAQUANT'),
  ('Vetro',            'ATTAQUANT'),
  ('Sidibé',           'ATTAQUANT'),
  ('Monthieu',         'ATTAQUANT'),
  ('Boutoutaou',       'ATTAQUANT'),
  ('Cortes',           'ATTAQUANT'),
  ('Clairicia',        'ATTAQUANT'),
  ('Mukanya',          'ATTAQUANT')
) as v(last_name, position) on v.last_name = p.last_name;

-- ============================================================
-- Fin du seed 0003 — Dijon FCO + FC Sochaux-Montbéliard
-- ============================================================
