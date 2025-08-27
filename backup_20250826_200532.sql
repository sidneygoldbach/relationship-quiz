PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE quizzes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              title TEXT NOT NULL,
              description TEXT,
              result_title TEXT DEFAULT 'Personality Type',
              price INTEGER DEFAULT 100,
              currency TEXT DEFAULT 'usd',
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            , coach_type TEXT DEFAULT "relationship", coach_category TEXT DEFAULT "personal", icon_url TEXT, coach_title TEXT, coach_description TEXT);
INSERT INTO quizzes VALUES(1,'relationship-quiz','Relationship Personality Quiz','Discover your relationship style and get personalized advice','Your Relationship Type',100,'usd',1,'2025-08-21 23:25:03','2025-08-21 23:25:03','relationship','personal',NULL,NULL,NULL);
INSERT INTO quizzes VALUES(2,'career_coach','Quiz de Carreira','Descubra seu perfil profissional ideal','Personality Type',150,'usd',1,'2025-08-21 18:12:40','2025-08-21 19:05:29','career_development','professional','https://via.placeholder.com/100x100/4ECDC4/FFFFFF?text=💼','Coach de Desenvolvimento de Carreira','Identifique suas forças profissionais e descubra o caminho ideal para sua carreira.');
INSERT INTO quizzes VALUES(3,'interview_coach','Quiz de Entrevistas','Prepare-se para entrevistas de emprego','Personality Type',120,'usd',1,'2025-08-21 18:12:40','2025-08-21 19:05:29','interview_preparation','professional','https://via.placeholder.com/100x100/45B7D1/FFFFFF?text=🎯','Coach de Preparação para Entrevistas','Desenvolva confiança e técnicas para se destacar em entrevistas de emprego.');
INSERT INTO quizzes VALUES(4,'romantic_conquest','Quiz de Conquistas Amorosas','Descubra seu estilo de conquista','Personality Type',180,'usd',1,'2025-08-21 18:12:40','2025-08-21 19:05:29','romantic_conquest','romantic','https://via.placeholder.com/100x100/E74C3C/FFFFFF?text=💘','Coach de Conquistas Amorosas','Aprenda técnicas de sedução e conquista para encontrar o amor verdadeiro.');
INSERT INTO quizzes VALUES(5,'lasting_relationships','Quiz de Relacionamentos Duradouros','Construa relacionamentos que duram','Personality Type',200,'usd',1,'2025-08-21 18:12:40','2025-08-21 19:05:29','lasting_relationships','romantic','https://via.placeholder.com/100x100/9B59B6/FFFFFF?text=💍','Coach de Relacionamentos Duradouros','Aprenda os segredos para manter relacionamentos saudáveis e duradouros.');
INSERT INTO quizzes VALUES(6,'relationship-quiz','Relationship Personality Quiz','Discover insights about your relationship style and get personalized advice!','Your Relationship Type',100,'usd',1,'2025-08-21 19:12:02','2025-08-21 19:12:02','relationship','personal',NULL,NULL,NULL);
CREATE TABLE categories (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            );
INSERT INTO categories VALUES(1,'conflict handling','Questions related to conflict handling','2025-08-21 19:12:02');
INSERT INTO categories VALUES(2,'relationship priorities','Questions related to relationship priorities','2025-08-21 19:12:02');
INSERT INTO categories VALUES(3,'affection expression','Questions related to affection expression','2025-08-21 19:12:02');
INSERT INTO categories VALUES(4,'decision-making','Questions related to decision-making','2025-08-21 19:12:02');
INSERT INTO categories VALUES(5,'emotional reactions','Questions related to emotional reactions','2025-08-21 19:12:02');
CREATE TABLE questions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              category_id INTEGER,
              question_text TEXT NOT NULL,
              question_order INTEGER DEFAULT 0,
              is_active INTEGER DEFAULT 1,
              country VARCHAR(5) DEFAULT 'en_US',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP, options_group_id INTEGER,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
              FOREIGN KEY (category_id) REFERENCES categories(id)
            );
INSERT INTO questions VALUES(6,2,NULL,'Pergunta 1 - Quiz=2 - en_US',1,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(7,2,NULL,'Pergunta 2 - Quiz=2 - en_US',2,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(8,2,NULL,'Pergunta 3 - Quiz=2 - en_US',3,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(9,2,NULL,'Pergunta 4 - Quiz=2 - en_US',4,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(10,2,NULL,'Pergunta 5 - Quiz=2 - en_US',5,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(11,2,NULL,'Pergunta 1 - Quiz=2 - pt_BR',1,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(12,2,NULL,'Pergunta 2 - Quiz=2 - pt_BR',2,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(13,2,NULL,'Pergunta 3 - Quiz=2 - pt_BR',3,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(14,2,NULL,'Pergunta 4 - Quiz=2 - pt_BR',4,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(15,2,NULL,'Pergunta 5 - Quiz=2 - pt_BR',5,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(16,2,NULL,'Pergunta 1 - Quiz=2 - es_ES',1,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(17,2,NULL,'Pergunta 2 - Quiz=2 - es_ES',2,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(18,2,NULL,'Pergunta 3 - Quiz=2 - es_ES',3,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(19,2,NULL,'Pergunta 4 - Quiz=2 - es_ES',4,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(20,2,NULL,'Pergunta 5 - Quiz=2 - es_ES',5,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(21,2,NULL,'Pergunta 1 - Quiz=2 - fr_FR',1,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(22,2,NULL,'Pergunta 2 - Quiz=2 - fr_FR',2,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(23,2,NULL,'Pergunta 3 - Quiz=2 - fr_FR',3,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(24,2,NULL,'Pergunta 4 - Quiz=2 - fr_FR',4,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(25,2,NULL,'Pergunta 5 - Quiz=2 - fr_FR',5,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(26,3,NULL,'Pergunta 1 - Quiz=3 - en_US',1,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(27,3,NULL,'Pergunta 2 - Quiz=3 - en_US',2,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(28,3,NULL,'Pergunta 3 - Quiz=3 - en_US',3,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(29,3,NULL,'Pergunta 4 - Quiz=3 - en_US',4,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(30,3,NULL,'Pergunta 5 - Quiz=3 - en_US',5,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(31,3,NULL,'Pergunta 1 - Quiz=3 - pt_BR',1,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(32,3,NULL,'Pergunta 2 - Quiz=3 - pt_BR',2,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(33,3,NULL,'Pergunta 3 - Quiz=3 - pt_BR',3,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(34,3,NULL,'Pergunta 4 - Quiz=3 - pt_BR',4,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(35,3,NULL,'Pergunta 5 - Quiz=3 - pt_BR',5,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(36,3,NULL,'Pergunta 1 - Quiz=3 - es_ES',1,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(37,3,NULL,'Pergunta 2 - Quiz=3 - es_ES',2,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(38,3,NULL,'Pergunta 3 - Quiz=3 - es_ES',3,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(39,3,NULL,'Pergunta 4 - Quiz=3 - es_ES',4,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(40,3,NULL,'Pergunta 5 - Quiz=3 - es_ES',5,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(41,3,NULL,'Pergunta 1 - Quiz=3 - fr_FR',1,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(42,3,NULL,'Pergunta 2 - Quiz=3 - fr_FR',2,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(43,3,NULL,'Pergunta 3 - Quiz=3 - fr_FR',3,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(44,3,NULL,'Pergunta 4 - Quiz=3 - fr_FR',4,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(45,3,NULL,'Pergunta 5 - Quiz=3 - fr_FR',5,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(46,4,NULL,'Pergunta 1 - Quiz=4 - en_US',1,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(47,4,NULL,'Pergunta 2 - Quiz=4 - en_US',2,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(48,4,NULL,'Pergunta 3 - Quiz=4 - en_US',3,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(49,4,NULL,'Pergunta 4 - Quiz=4 - en_US',4,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(50,4,NULL,'Pergunta 5 - Quiz=4 - en_US',5,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(51,4,NULL,'Pergunta 1 - Quiz=4 - pt_BR',1,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(52,4,NULL,'Pergunta 2 - Quiz=4 - pt_BR',2,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(53,4,NULL,'Pergunta 3 - Quiz=4 - pt_BR',3,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(54,4,NULL,'Pergunta 4 - Quiz=4 - pt_BR',4,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(55,4,NULL,'Pergunta 5 - Quiz=4 - pt_BR',5,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(56,4,NULL,'Pergunta 1 - Quiz=4 - es_ES',1,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(57,4,NULL,'Pergunta 2 - Quiz=4 - es_ES',2,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(58,4,NULL,'Pergunta 3 - Quiz=4 - es_ES',3,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(59,4,NULL,'Pergunta 4 - Quiz=4 - es_ES',4,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(60,4,NULL,'Pergunta 5 - Quiz=4 - es_ES',5,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(61,4,NULL,'Pergunta 1 - Quiz=4 - fr_FR',1,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(62,4,NULL,'Pergunta 2 - Quiz=4 - fr_FR',2,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(63,4,NULL,'Pergunta 3 - Quiz=4 - fr_FR',3,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(64,4,NULL,'Pergunta 4 - Quiz=4 - fr_FR',4,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(65,4,NULL,'Pergunta 5 - Quiz=4 - fr_FR',5,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(66,5,NULL,'Pergunta 1 - Quiz=5 - en_US',1,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(67,5,NULL,'Pergunta 2 - Quiz=5 - en_US',2,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(68,5,NULL,'Pergunta 3 - Quiz=5 - en_US',3,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(69,5,NULL,'Pergunta 4 - Quiz=5 - en_US',4,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(70,5,NULL,'Pergunta 5 - Quiz=5 - en_US',5,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(71,5,NULL,'Pergunta 1 - Quiz=5 - pt_BR',1,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(72,5,NULL,'Pergunta 2 - Quiz=5 - pt_BR',2,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(73,5,NULL,'Pergunta 3 - Quiz=5 - pt_BR',3,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(74,5,NULL,'Pergunta 4 - Quiz=5 - pt_BR',4,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(75,5,NULL,'Pergunta 5 - Quiz=5 - pt_BR',5,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(76,5,NULL,'Pergunta 1 - Quiz=5 - es_ES',1,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(77,5,NULL,'Pergunta 2 - Quiz=5 - es_ES',2,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(78,5,NULL,'Pergunta 3 - Quiz=5 - es_ES',3,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(79,5,NULL,'Pergunta 4 - Quiz=5 - es_ES',4,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(80,5,NULL,'Pergunta 5 - Quiz=5 - es_ES',5,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(81,5,NULL,'Pergunta 1 - Quiz=5 - fr_FR',1,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(82,5,NULL,'Pergunta 2 - Quiz=5 - fr_FR',2,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(83,5,NULL,'Pergunta 3 - Quiz=5 - fr_FR',3,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(84,5,NULL,'Pergunta 4 - Quiz=5 - fr_FR',4,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(85,5,NULL,'Pergunta 5 - Quiz=5 - fr_FR',5,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(86,6,NULL,'Pergunta 1 - Quiz=6 - en_US',0,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(87,6,NULL,'Pergunta 2 - Quiz=6 - en_US',1,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(88,6,NULL,'Pergunta 3 - Quiz=6 - en_US',2,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(89,6,NULL,'Pergunta 4 - Quiz=6 - en_US',3,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(90,6,NULL,'Pergunta 5 - Quiz=6 - en_US',4,1,'en_US','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(91,6,NULL,'Pergunta 1 - Quiz=6 - pt_BR',0,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(92,6,NULL,'Pergunta 2 - Quiz=6 - pt_BR',1,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(93,6,NULL,'Pergunta 3 - Quiz=6 - pt_BR',2,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(94,6,NULL,'Pergunta 4 - Quiz=6 - pt_BR',3,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(95,6,NULL,'Pergunta 5 - Quiz=6 - pt_BR',4,1,'pt_BR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(96,6,NULL,'Pergunta 1 - Quiz=6 - es_ES',0,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(97,6,NULL,'Pergunta 2 - Quiz=6 - es_ES',1,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(98,6,NULL,'Pergunta 3 - Quiz=6 - es_ES',2,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(99,6,NULL,'Pergunta 4 - Quiz=6 - es_ES',3,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(100,6,NULL,'Pergunta 5 - Quiz=6 - es_ES',4,1,'es_ES','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(101,6,NULL,'Pergunta 1 - Quiz=6 - fr_FR',0,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(102,6,NULL,'Pergunta 2 - Quiz=6 - fr_FR',1,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(103,6,NULL,'Pergunta 3 - Quiz=6 - fr_FR',2,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(104,6,NULL,'Pergunta 4 - Quiz=6 - fr_FR',3,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(105,6,NULL,'Pergunta 5 - Quiz=6 - fr_FR',4,1,'fr_FR','2025-08-21 21:06:29',NULL);
INSERT INTO questions VALUES(106,2,NULL,'🔧 Pergunta 1 - Quiz=2 - en_US',1,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(107,2,NULL,'🔧 Pergunta 2 - Quiz=2 - en_US',2,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(108,2,NULL,'🔧 Pergunta 3 - Quiz=2 - en_US',3,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(109,2,NULL,'🔧 Pergunta 4 - Quiz=2 - en_US',4,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(110,2,NULL,'🔧 Pergunta 5 - Quiz=2 - en_US',5,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(111,2,NULL,'🔧 Pergunta 1 - Quiz=2 - pt_BR',1,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(112,2,NULL,'🔧 Pergunta 2 - Quiz=2 - pt_BR',2,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(113,2,NULL,'🔧 Pergunta 3 - Quiz=2 - pt_BR',3,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(114,2,NULL,'🔧 Pergunta 4 - Quiz=2 - pt_BR',4,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(115,2,NULL,'🔧 Pergunta 5 - Quiz=2 - pt_BR',5,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(116,2,NULL,'🔧 Pergunta 1 - Quiz=2 - es_ES',1,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(117,2,NULL,'🔧 Pergunta 2 - Quiz=2 - es_ES',2,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(118,2,NULL,'🔧 Pergunta 3 - Quiz=2 - es_ES',3,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(119,2,NULL,'🔧 Pergunta 4 - Quiz=2 - es_ES',4,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(120,2,NULL,'🔧 Pergunta 5 - Quiz=2 - es_ES',5,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(121,2,NULL,'🔧 Pergunta 1 - Quiz=2 - fr_FR',1,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(122,2,NULL,'🔧 Pergunta 2 - Quiz=2 - fr_FR',2,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(123,2,NULL,'🔧 Pergunta 3 - Quiz=2 - fr_FR',3,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(124,2,NULL,'🔧 Pergunta 4 - Quiz=2 - fr_FR',4,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(125,2,NULL,'🔧 Pergunta 5 - Quiz=2 - fr_FR',5,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(126,3,NULL,'🔧 Pergunta 1 - Quiz=3 - en_US',1,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(127,3,NULL,'🔧 Pergunta 2 - Quiz=3 - en_US',2,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(128,3,NULL,'🔧 Pergunta 3 - Quiz=3 - en_US',3,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(129,3,NULL,'🔧 Pergunta 4 - Quiz=3 - en_US',4,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(130,3,NULL,'🔧 Pergunta 5 - Quiz=3 - en_US',5,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(131,3,NULL,'🔧 Pergunta 1 - Quiz=3 - pt_BR',1,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(132,3,NULL,'🔧 Pergunta 2 - Quiz=3 - pt_BR',2,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(133,3,NULL,'🔧 Pergunta 3 - Quiz=3 - pt_BR',3,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(134,3,NULL,'🔧 Pergunta 4 - Quiz=3 - pt_BR',4,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(135,3,NULL,'🔧 Pergunta 5 - Quiz=3 - pt_BR',5,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(136,3,NULL,'🔧 Pergunta 1 - Quiz=3 - es_ES',1,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(137,3,NULL,'🔧 Pergunta 2 - Quiz=3 - es_ES',2,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(138,3,NULL,'🔧 Pergunta 3 - Quiz=3 - es_ES',3,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(139,3,NULL,'🔧 Pergunta 4 - Quiz=3 - es_ES',4,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(140,3,NULL,'🔧 Pergunta 5 - Quiz=3 - es_ES',5,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(141,3,NULL,'🔧 Pergunta 1 - Quiz=3 - fr_FR',1,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(142,3,NULL,'🔧 Pergunta 2 - Quiz=3 - fr_FR',2,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(143,3,NULL,'🔧 Pergunta 3 - Quiz=3 - fr_FR',3,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(144,3,NULL,'🔧 Pergunta 4 - Quiz=3 - fr_FR',4,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(145,3,NULL,'🔧 Pergunta 5 - Quiz=3 - fr_FR',5,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(146,4,NULL,'🔧 Pergunta 1 - Quiz=4 - en_US',1,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(147,4,NULL,'🔧 Pergunta 2 - Quiz=4 - en_US',2,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(148,4,NULL,'🔧 Pergunta 3 - Quiz=4 - en_US',3,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(149,4,NULL,'🔧 Pergunta 4 - Quiz=4 - en_US',4,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(150,4,NULL,'🔧 Pergunta 5 - Quiz=4 - en_US',5,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(151,4,NULL,'🔧 Pergunta 1 - Quiz=4 - pt_BR',1,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(152,4,NULL,'🔧 Pergunta 2 - Quiz=4 - pt_BR',2,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(153,4,NULL,'🔧 Pergunta 3 - Quiz=4 - pt_BR',3,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(154,4,NULL,'🔧 Pergunta 4 - Quiz=4 - pt_BR',4,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(155,4,NULL,'🔧 Pergunta 5 - Quiz=4 - pt_BR',5,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(156,4,NULL,'🔧 Pergunta 1 - Quiz=4 - es_ES',1,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(157,4,NULL,'🔧 Pergunta 2 - Quiz=4 - es_ES',2,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(158,4,NULL,'🔧 Pergunta 3 - Quiz=4 - es_ES',3,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(159,4,NULL,'🔧 Pergunta 4 - Quiz=4 - es_ES',4,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(160,4,NULL,'🔧 Pergunta 5 - Quiz=4 - es_ES',5,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(161,4,NULL,'🔧 Pergunta 1 - Quiz=4 - fr_FR',1,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(162,4,NULL,'🔧 Pergunta 2 - Quiz=4 - fr_FR',2,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(163,4,NULL,'🔧 Pergunta 3 - Quiz=4 - fr_FR',3,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(164,4,NULL,'🔧 Pergunta 4 - Quiz=4 - fr_FR',4,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(165,4,NULL,'🔧 Pergunta 5 - Quiz=4 - fr_FR',5,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(166,5,NULL,'🔧 Pergunta 1 - Quiz=5 - en_US',1,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(167,5,NULL,'🔧 Pergunta 2 - Quiz=5 - en_US',2,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(168,5,NULL,'🔧 Pergunta 3 - Quiz=5 - en_US',3,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(169,5,NULL,'🔧 Pergunta 4 - Quiz=5 - en_US',4,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(170,5,NULL,'🔧 Pergunta 5 - Quiz=5 - en_US',5,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(171,5,NULL,'🔧 Pergunta 1 - Quiz=5 - pt_BR',1,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(172,5,NULL,'🔧 Pergunta 2 - Quiz=5 - pt_BR',2,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(173,5,NULL,'🔧 Pergunta 3 - Quiz=5 - pt_BR',3,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(174,5,NULL,'🔧 Pergunta 4 - Quiz=5 - pt_BR',4,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(175,5,NULL,'🔧 Pergunta 5 - Quiz=5 - pt_BR',5,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(176,5,NULL,'🔧 Pergunta 1 - Quiz=5 - es_ES',1,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(177,5,NULL,'🔧 Pergunta 2 - Quiz=5 - es_ES',2,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(178,5,NULL,'🔧 Pergunta 3 - Quiz=5 - es_ES',3,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(179,5,NULL,'🔧 Pergunta 4 - Quiz=5 - es_ES',4,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(180,5,NULL,'🔧 Pergunta 5 - Quiz=5 - es_ES',5,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(181,5,NULL,'🔧 Pergunta 1 - Quiz=5 - fr_FR',1,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(182,5,NULL,'🔧 Pergunta 2 - Quiz=5 - fr_FR',2,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(183,5,NULL,'🔧 Pergunta 3 - Quiz=5 - fr_FR',3,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(184,5,NULL,'🔧 Pergunta 4 - Quiz=5 - fr_FR',4,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(185,5,NULL,'🔧 Pergunta 5 - Quiz=5 - fr_FR',5,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(186,6,NULL,'🔧 Pergunta 1 - Quiz=6 - en_US',0,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(187,6,NULL,'🔧 Pergunta 2 - Quiz=6 - en_US',1,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(188,6,NULL,'🔧 Pergunta 3 - Quiz=6 - en_US',2,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(189,6,NULL,'🔧 Pergunta 4 - Quiz=6 - en_US',3,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(190,6,NULL,'🔧 Pergunta 5 - Quiz=6 - en_US',4,1,'en_US','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(191,6,NULL,'🔧 Pergunta 1 - Quiz=6 - pt_BR',0,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(192,6,NULL,'🔧 Pergunta 2 - Quiz=6 - pt_BR',1,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(193,6,NULL,'🔧 Pergunta 3 - Quiz=6 - pt_BR',2,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(194,6,NULL,'🔧 Pergunta 4 - Quiz=6 - pt_BR',3,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(195,6,NULL,'🔧 Pergunta 5 - Quiz=6 - pt_BR',4,1,'pt_BR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(196,6,NULL,'🔧 Pergunta 1 - Quiz=6 - es_ES',0,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(197,6,NULL,'🔧 Pergunta 2 - Quiz=6 - es_ES',1,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(198,6,NULL,'🔧 Pergunta 3 - Quiz=6 - es_ES',2,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(199,6,NULL,'🔧 Pergunta 4 - Quiz=6 - es_ES',3,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(200,6,NULL,'🔧 Pergunta 5 - Quiz=6 - es_ES',4,1,'es_ES','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(201,6,NULL,'🔧 Pergunta 1 - Quiz=6 - fr_FR',0,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(202,6,NULL,'🔧 Pergunta 2 - Quiz=6 - fr_FR',1,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(203,6,NULL,'🔧 Pergunta 3 - Quiz=6 - fr_FR',2,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(204,6,NULL,'🔧 Pergunta 4 - Quiz=6 - fr_FR',3,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(205,6,NULL,'🔧 Pergunta 5 - Quiz=6 - fr_FR',4,1,'fr_FR','2025-08-21 21:15:03',NULL);
INSERT INTO questions VALUES(206,1,1,'How do you typically handle conflicts in relationships?',1,1,'en_US','2025-08-21 23:25:23',1);
INSERT INTO questions VALUES(207,1,2,'What is most important to you in a relationship?',2,1,'en_US','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(208,1,3,'How do you express affection to your partner?',3,1,'en_US','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(209,1,4,'When making important decisions with a partner, you prefer to:',4,1,'en_US','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(210,1,5,'How do you react when you feel emotionally hurt by someone close?',5,1,'en_US','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(211,1,1,'Como você normalmente lida com conflitos em relacionamentos?',1,1,'pt_BR','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(212,1,2,'O que é mais importante para você em um relacionamento?',2,1,'pt_BR','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(213,1,3,'Como você expressa afeto ao seu parceiro?',3,1,'pt_BR','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(214,1,4,'Ao tomar decisões importantes com um parceiro, você prefere:',4,1,'pt_BR','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(215,1,5,'Como você reage quando se sente emocionalmente ferido por alguém próximo?',5,1,'pt_BR','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(216,1,1,'¿Cómo manejas los conflictos en tu relación?',1,1,'es_ES','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(217,1,2,'¿Qué es lo más importante para ti en una relación?',2,1,'es_ES','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(218,1,3,'¿Cómo expresas tu amor?',3,1,'es_ES','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(219,1,4,'Al tomar decisiones importantes con tu pareja, prefieres:',4,1,'es_ES','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(220,1,5,'¿Cómo reaccionas cuando te sientes emocionalmente herido?',5,1,'es_ES','2025-08-21 23:25:23',NULL);
INSERT INTO questions VALUES(221,1,1,'How do you typically handle conflicts in relationships?',1,1,'en_US','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(222,1,2,'What is most important to you in a relationship?',2,1,'en_US','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(223,1,3,'How do you express affection to your partner?',3,1,'en_US','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(224,1,4,'When making important decisions with a partner, you prefer to:',4,1,'en_US','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(225,1,5,'How do you react when you feel emotionally hurt by someone close?',5,1,'en_US','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(226,1,1,'Como você normalmente lida com conflitos em relacionamentos?',1,1,'pt_BR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(227,1,2,'O que é mais importante para você em um relacionamento?',2,1,'pt_BR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(228,1,3,'Como você expressa afeto ao seu parceiro?',3,1,'pt_BR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(229,1,4,'Ao tomar decisões importantes com um parceiro, você prefere:',4,1,'pt_BR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(230,1,5,'Como você reage quando se sente emocionalmente ferido por alguém próximo?',5,1,'pt_BR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(231,1,1,'¿Cómo manejas los conflictos en tu relación?',1,1,'es_ES','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(232,1,2,'¿Qué es lo más importante para ti en una relación?',2,1,'es_ES','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(233,1,3,'¿Cómo expresas tu amor?',3,1,'es_ES','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(234,1,4,'Al tomar decisiones importantes con tu pareja, prefieres:',4,1,'es_ES','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(235,1,5,'¿Cómo reaccionas cuando te sientes emocionalmente herido?',5,1,'es_ES','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(236,1,1,'Comment gérez-vous généralement les conflits dans les relations?',1,1,'fr_FR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(237,1,2,'Qu''est-ce qui est le plus important pour vous dans une relation?',2,1,'fr_FR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(238,1,3,'Comment exprimez-vous l''affection à votre partenaire?',3,1,'fr_FR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(239,1,4,'Lors de prises de décisions importantes avec un partenaire, vous préférez:',4,1,'fr_FR','2025-08-21 23:25:38',NULL);
INSERT INTO questions VALUES(240,1,5,'Comment réagissez-vous quand vous vous sentez blessé émotionnellement?',5,1,'fr_FR','2025-08-21 23:25:38',NULL);
CREATE TABLE answer_options (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              question_id INTEGER,
              option_text TEXT NOT NULL,
              option_order INTEGER DEFAULT 0,
              personality_weight TEXT,
              country VARCHAR(5) DEFAULT 'en_US',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP, options_group_id INTEGER,
              FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
            );
INSERT INTO answer_options VALUES(1,1,'I prefer to address issues immediately and directly.',0,'{"communicator":3,"independent":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(2,1,'I need time to process before discussing the problem.',1,'{"independent":3,"loyalist":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(3,1,'I try to find a compromise that works for everyone.',2,'{"harmonizer":3,"nurturer":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(4,1,'I sometimes avoid confrontation to keep the peace.',3,'{"harmonizer":2,"nurturer":2}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(5,2,'Open and honest communication.',0,'{"communicator":3,"loyalist":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(6,2,'Trust and loyalty.',1,'{"loyalist":3,"communicator":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(7,2,'Emotional support and understanding.',2,'{"nurturer":3,"harmonizer":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(8,2,'Growth and shared experiences.',3,'{"independent":3,"communicator":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(9,3,'Through physical touch and closeness.',0,'{"nurturer":2,"harmonizer":2}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(10,3,'By giving gifts or doing thoughtful acts of service.',1,'{"loyalist":3,"nurturer":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(11,3,'With words of affirmation and compliments.',2,'{"communicator":3,"nurturer":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(12,3,'By spending quality time together.',3,'{"harmonizer":3,"loyalist":1}','en_US','2025-08-21 19:12:02',NULL);
INSERT INTO answer_options VALUES(13,4,'Take the lead and make decisions confidently.',0,'{"communicator":2,"independent":2}','en_US','2025-08-21 19:12:03',NULL);
INSERT INTO answer_options VALUES(14,4,'Discuss all options thoroughly before deciding together.',1,'{"communicator":2,"loyalist":2}','en_US','2025-08-21 19:12:03',NULL);
INSERT INTO answer_options VALUES(15,4,'Consider your partner''s needs first.',2,'{"nurturer":3,"harmonizer":1}','en_US','2025-08-21 19:12:03',NULL);
INSERT INTO answer_options VALUES(16,4,'Be flexible and go with the flow.',3,'{"harmonizer":3,"independent":1}','en_US','2025-08-21 19:12:03',NULL);
INSERT INTO answer_options VALUES(17,5,'Express my feelings immediately and directly.',0,'{"communicator":3,"independent":1}','en_US','2025-08-21 19:12:03',NULL);
INSERT INTO answer_options VALUES(18,5,'Withdraw and process my emotions privately.',1,'{"independent":3,"loyalist":1}','en_US','2025-08-21 19:12:03',NULL);
INSERT INTO answer_options VALUES(19,5,'Try to understand their perspective before reacting.',2,'{"nurturer":2,"harmonizer":2}','en_US','2025-08-21 19:12:03',NULL);
INSERT INTO answer_options VALUES(20,5,'Tend to forgive quickly and move forward.',3,'{"harmonizer":2,"loyalist":2}','en_US','2025-08-21 19:12:03',NULL);
INSERT INTO answer_options VALUES(21,6,'Abordo os problemas imediatamente e diretamente',0,'{"communicator":3,"independent":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(22,6,'Preciso de tempo para processar antes de discutir',1,'{"independent":3,"loyalist":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(23,6,'Tento encontrar um compromisso que funcione para todos',2,'{"harmonizer":3,"nurturer":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(24,6,'Às vezes evito confrontos para manter a paz',3,'{"harmonizer":2,"nurturer":2}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(25,6,'I address issues immediately and directly',0,'{"communicator":3,"independent":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(26,6,'I need time to process before discussing',1,'{"independent":3,"loyalist":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(27,6,'I try to find a compromise that works for everyone',2,'{"harmonizer":3,"nurturer":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(28,6,'I sometimes avoid confrontation to keep the peace',3,'{"harmonizer":2,"nurturer":2}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(29,11,'Comunicação aberta e honesta',0,'{"communicator":3,"loyalist":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(30,11,'Confiança e lealdade mútua',1,'{"loyalist":3,"nurturer":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(31,11,'Apoio emocional e compreensão',2,'{"nurturer":3,"harmonizer":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(32,11,'Respeito pela independência individual',3,'{"independent":3,"communicator":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(33,11,'Open and honest communication',0,'{"communicator":3,"loyalist":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(34,11,'Trust and mutual loyalty',1,'{"loyalist":3,"nurturer":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(35,11,'Emotional support and understanding',2,'{"nurturer":3,"harmonizer":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(36,11,'Respect for individual independence',3,'{"independent":3,"communicator":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(37,16,'Através de palavras de afirmação',0,'{"communicator":3,"nurturer":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(38,16,'Através de atos de serviço',1,'{"nurturer":3,"loyalist":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(39,16,'Passando tempo de qualidade juntos',2,'{"harmonizer":3,"loyalist":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(40,16,'Dando espaço e liberdade',3,'{"independent":3,"harmonizer":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(41,16,'Through words of affirmation',0,'{"communicator":3,"nurturer":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(42,16,'Through acts of service',1,'{"nurturer":3,"loyalist":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(43,16,'Spending quality time together',2,'{"harmonizer":3,"loyalist":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(44,16,'Giving space and freedom',3,'{"independent":3,"harmonizer":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(45,21,'Adapto-me facilmente às mudanças',0,'{"harmonizer":3,"independent":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(46,21,'Preciso de tempo para me ajustar',1,'{"loyalist":3,"independent":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(47,21,'Gosto de discutir as mudanças abertamente',2,'{"communicator":3,"loyalist":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(48,21,'Prefiro mudanças graduais',3,'{"nurturer":3,"harmonizer":1}','pt_BR','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(49,21,'I adapt easily to changes',0,'{"harmonizer":3,"independent":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(50,21,'I need time to adjust',1,'{"loyalist":3,"independent":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(51,21,'I like to discuss changes openly',2,'{"communicator":3,"loyalist":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(52,21,'I prefer gradual changes',3,'{"nurturer":3,"harmonizer":1}','en_US','2025-08-21 22:30:28',NULL);
INSERT INTO answer_options VALUES(53,86,'Opção A - Pergunta 1',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 22:58:15',NULL);
INSERT INTO answer_options VALUES(54,86,'Opção B - Pergunta 1',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 22:58:15',NULL);
INSERT INTO answer_options VALUES(55,86,'Opção C - Pergunta 1',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 22:58:15',NULL);
INSERT INTO answer_options VALUES(56,86,'Opção D - Pergunta 1',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 22:58:15',NULL);
INSERT INTO answer_options VALUES(57,87,'Opção A - Pergunta 2',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 22:58:21',NULL);
INSERT INTO answer_options VALUES(58,87,'Opção B - Pergunta 2',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 22:58:21',NULL);
INSERT INTO answer_options VALUES(59,87,'Opção C - Pergunta 2',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 22:58:21',NULL);
INSERT INTO answer_options VALUES(60,87,'Opção D - Pergunta 2',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 22:58:21',NULL);
INSERT INTO answer_options VALUES(61,88,'Opção A - Pergunta 3',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 22:58:28',NULL);
INSERT INTO answer_options VALUES(62,88,'Opção B - Pergunta 3',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 22:58:28',NULL);
INSERT INTO answer_options VALUES(63,88,'Opção C - Pergunta 3',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 22:58:28',NULL);
INSERT INTO answer_options VALUES(64,88,'Opção D - Pergunta 3',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 22:58:28',NULL);
INSERT INTO answer_options VALUES(65,89,'Opção A - Pergunta 4',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 22:58:37',NULL);
INSERT INTO answer_options VALUES(66,89,'Opção B - Pergunta 4',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 22:58:37',NULL);
INSERT INTO answer_options VALUES(67,89,'Opção C - Pergunta 4',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 22:58:37',NULL);
INSERT INTO answer_options VALUES(68,89,'Opção D - Pergunta 4',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 22:58:37',NULL);
INSERT INTO answer_options VALUES(69,90,'Opção A - Pergunta 5',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 22:58:37',NULL);
INSERT INTO answer_options VALUES(70,90,'Opção B - Pergunta 5',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 22:58:37',NULL);
INSERT INTO answer_options VALUES(71,90,'Opção C - Pergunta 5',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 22:58:37',NULL);
INSERT INTO answer_options VALUES(72,90,'Opção D - Pergunta 5',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 22:58:37',NULL);
INSERT INTO answer_options VALUES(73,7,'Opção A - Pergunta 2',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:22:43',NULL);
INSERT INTO answer_options VALUES(74,7,'Opção B - Pergunta 2',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:22:43',NULL);
INSERT INTO answer_options VALUES(75,7,'Opção C - Pergunta 2',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:22:43',NULL);
INSERT INTO answer_options VALUES(76,7,'Opção D - Pergunta 2',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:22:43',NULL);
INSERT INTO answer_options VALUES(77,8,'Opção A - Pergunta 3',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(78,8,'Opção B - Pergunta 3',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(79,8,'Opção C - Pergunta 3',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(80,8,'Opção D - Pergunta 3',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(81,9,'Opção A - Pergunta 4',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(82,9,'Opção B - Pergunta 4',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(83,9,'Opção C - Pergunta 4',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(84,9,'Opção D - Pergunta 4',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(85,10,'Opção A - Pergunta 5',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(86,10,'Opção B - Pergunta 5',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(87,10,'Opção C - Pergunta 5',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(88,10,'Opção D - Pergunta 5',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:22:56',NULL);
INSERT INTO answer_options VALUES(89,26,'Opção A - Pergunta 1 Quiz 3',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(90,26,'Opção B - Pergunta 1 Quiz 3',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(91,26,'Opção C - Pergunta 1 Quiz 3',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(92,26,'Opção D - Pergunta 1 Quiz 3',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(93,27,'Opção A - Pergunta 2 Quiz 3',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(94,27,'Opção B - Pergunta 2 Quiz 3',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(95,27,'Opção C - Pergunta 2 Quiz 3',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(96,27,'Opção D - Pergunta 2 Quiz 3',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(97,28,'Opção A - Pergunta 3 Quiz 3',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(98,28,'Opção B - Pergunta 3 Quiz 3',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(99,28,'Opção C - Pergunta 3 Quiz 3',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(100,28,'Opção D - Pergunta 3 Quiz 3',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(101,29,'Opção A - Pergunta 4 Quiz 3',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(102,29,'Opção B - Pergunta 4 Quiz 3',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(103,29,'Opção C - Pergunta 4 Quiz 3',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(104,29,'Opção D - Pergunta 4 Quiz 3',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(105,30,'Opção A - Pergunta 5 Quiz 3',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(106,30,'Opção B - Pergunta 5 Quiz 3',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(107,30,'Opção C - Pergunta 5 Quiz 3',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(108,30,'Opção D - Pergunta 5 Quiz 3',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(109,46,'Opção A - Pergunta 1 Quiz 4',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(110,46,'Opção B - Pergunta 1 Quiz 4',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(111,46,'Opção C - Pergunta 1 Quiz 4',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(112,46,'Opção D - Pergunta 1 Quiz 4',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(113,47,'Opção A - Pergunta 2 Quiz 4',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(114,47,'Opção B - Pergunta 2 Quiz 4',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(115,47,'Opção C - Pergunta 2 Quiz 4',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(116,47,'Opção D - Pergunta 2 Quiz 4',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(117,48,'Opção A - Pergunta 3 Quiz 4',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(118,48,'Opção B - Pergunta 3 Quiz 4',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(119,48,'Opção C - Pergunta 3 Quiz 4',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(120,48,'Opção D - Pergunta 3 Quiz 4',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(121,49,'Opção A - Pergunta 4 Quiz 4',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(122,49,'Opção B - Pergunta 4 Quiz 4',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(123,49,'Opção C - Pergunta 4 Quiz 4',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(124,49,'Opção D - Pergunta 4 Quiz 4',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(125,50,'Opção A - Pergunta 5 Quiz 4',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(126,50,'Opção B - Pergunta 5 Quiz 4',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(127,50,'Opção C - Pergunta 5 Quiz 4',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(128,50,'Opção D - Pergunta 5 Quiz 4',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(129,66,'Opção A - Pergunta 1 Quiz 5',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(130,66,'Opção B - Pergunta 1 Quiz 5',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(131,66,'Opção C - Pergunta 1 Quiz 5',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(132,66,'Opção D - Pergunta 1 Quiz 5',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(133,67,'Opção A - Pergunta 2 Quiz 5',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(134,67,'Opção B - Pergunta 2 Quiz 5',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(135,67,'Opção C - Pergunta 2 Quiz 5',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(136,67,'Opção D - Pergunta 2 Quiz 5',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(137,68,'Opção A - Pergunta 3 Quiz 5',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(138,68,'Opção B - Pergunta 3 Quiz 5',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(139,68,'Opção C - Pergunta 3 Quiz 5',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(140,68,'Opção D - Pergunta 3 Quiz 5',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(141,69,'Opção A - Pergunta 4 Quiz 5',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(142,69,'Opção B - Pergunta 4 Quiz 5',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(143,69,'Opção C - Pergunta 4 Quiz 5',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(144,69,'Opção D - Pergunta 4 Quiz 5',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(145,70,'Opção A - Pergunta 5 Quiz 5',0,'{"type_a": 3, "type_b": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(146,70,'Opção B - Pergunta 5 Quiz 5',1,'{"type_b": 3, "type_c": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(147,70,'Opção C - Pergunta 5 Quiz 5',2,'{"type_c": 3, "type_d": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(148,70,'Opção D - Pergunta 5 Quiz 5',3,'{"type_d": 3, "type_a": 1}','en_US','2025-08-21 23:23:45',NULL);
INSERT INTO answer_options VALUES(149,206,'I prefer to address issues immediately and directly',0,'{"communicator": 3, "independent": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(150,221,'I prefer to address issues immediately and directly',0,'{"communicator": 3, "independent": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(151,206,'I need time to process before discussing',1,'{"independent": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(152,221,'I need time to process before discussing',1,'{"independent": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(153,206,'I try to find a compromise that works for everyone',2,'{"harmonizer": 3, "nurturer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(154,221,'I try to find a compromise that works for everyone',2,'{"harmonizer": 3, "nurturer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(155,206,'I sometimes avoid confrontation to keep the peace',3,'{"harmonizer": 2, "nurturer": 2}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(156,221,'I sometimes avoid confrontation to keep the peace',3,'{"harmonizer": 2, "nurturer": 2}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(157,207,'Open and honest communication',0,'{"communicator": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(158,222,'Open and honest communication',0,'{"communicator": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(159,207,'Trust and mutual loyalty',1,'{"loyalist": 3, "nurturer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(160,222,'Trust and mutual loyalty',1,'{"loyalist": 3, "nurturer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(161,207,'Emotional support and understanding',2,'{"nurturer": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(162,222,'Emotional support and understanding',2,'{"nurturer": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(163,207,'Respect for individual independence',3,'{"independent": 3, "communicator": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(164,222,'Respect for individual independence',3,'{"independent": 3, "communicator": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(165,208,'Through physical touch and closeness',0,'{"nurturer": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(166,223,'Through physical touch and closeness',0,'{"nurturer": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(167,208,'By giving gifts or doing thoughtful acts of service',1,'{"nurturer": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(168,223,'By giving gifts or doing thoughtful acts of service',1,'{"nurturer": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(169,208,'With words of affirmation and praise',2,'{"communicator": 3, "nurturer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(170,223,'With words of affirmation and praise',2,'{"communicator": 3, "nurturer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(171,208,'By spending quality time together',3,'{"harmonizer": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(172,223,'By spending quality time together',3,'{"harmonizer": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(173,209,'Take the lead and make decisions confidently',0,'{"independent": 3, "communicator": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(174,224,'Take the lead and make decisions confidently',0,'{"independent": 3, "communicator": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(175,209,'Discuss all options thoroughly before deciding together',1,'{"communicator": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(176,224,'Discuss all options thoroughly before deciding together',1,'{"communicator": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(177,209,'Consider your partner needs first',2,'{"nurturer": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(178,224,'Consider your partner needs first',2,'{"nurturer": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(179,209,'Be flexible and go with the flow',3,'{"harmonizer": 3, "independent": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(180,224,'Be flexible and go with the flow',3,'{"harmonizer": 3, "independent": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(181,210,'Express my feelings immediately and directly',0,'{"communicator": 3, "independent": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(182,225,'Express my feelings immediately and directly',0,'{"communicator": 3, "independent": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(183,210,'Withdraw and process my emotions privately',1,'{"independent": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(184,225,'Withdraw and process my emotions privately',1,'{"independent": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(185,210,'Seek comfort and support from my partner',2,'{"nurturer": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(186,225,'Seek comfort and support from my partner',2,'{"nurturer": 3, "harmonizer": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(187,210,'Try to understand their perspective first',3,'{"harmonizer": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(188,225,'Try to understand their perspective first',3,'{"harmonizer": 3, "loyalist": 1}','en_US','2025-08-21 23:26:16',NULL);
INSERT INTO answer_options VALUES(189,NULL,'Strongly Disagree',1,'1','en_US','2025-08-25 19:54:01',1);
INSERT INTO answer_options VALUES(190,NULL,'Disagree',2,'2','en_US','2025-08-25 19:54:01',1);
INSERT INTO answer_options VALUES(191,NULL,'Neutral',3,'3','en_US','2025-08-25 19:54:01',1);
INSERT INTO answer_options VALUES(192,NULL,'Agree',4,'4','en_US','2025-08-25 19:54:01',1);
INSERT INTO answer_options VALUES(193,NULL,'Strongly Agree',5,'5','en_US','2025-08-25 19:54:01',1);
CREATE TABLE personality_types (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              type_name TEXT NOT NULL,
              type_key TEXT NOT NULL,
              description TEXT,
              country VARCHAR(5) DEFAULT 'en_US',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
            );
INSERT INTO personality_types VALUES(1,6,'The Communicator','communicator','You value open and honest communication in relationships. You''re direct about your needs and feelings, which helps prevent misunderstandings.','en_US','2025-08-21 19:12:02');
INSERT INTO personality_types VALUES(2,6,'The Nurturer','nurturer','You prioritize emotional support and understanding in relationships. Your empathetic nature makes others feel safe and valued.','en_US','2025-08-21 19:12:02');
INSERT INTO personality_types VALUES(3,6,'The Harmonizer','harmonizer','You seek peace and balance in relationships. You''re adaptable and willing to compromise to maintain harmony.','en_US','2025-08-21 19:12:02');
INSERT INTO personality_types VALUES(4,6,'The Independent','independent','You value autonomy and personal growth in relationships. You bring a strong sense of self and clear boundaries to your connections.','en_US','2025-08-21 19:12:02');
INSERT INTO personality_types VALUES(5,6,'The Loyalist','loyalist','You prioritize trust and commitment in relationships. Your reliability and dedication create a secure foundation for deep connections.','en_US','2025-08-21 19:12:02');
INSERT INTO personality_types VALUES(6,2,'Type A - Quiz=2 - en_US','type_a','Descricao do Type A - Quiz=2 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(7,2,'Type B - Quiz=2 - en_US','type_b','Descricao do Type B - Quiz=2 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(8,2,'Type C - Quiz=2 - en_US','type_c','Descricao do Type C - Quiz=2 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(9,2,'Type A - Quiz=2 - pt_BR','type_a','Descricao do Type A - Quiz=2 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(10,2,'Type B - Quiz=2 - pt_BR','type_b','Descricao do Type B - Quiz=2 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(11,2,'Type C - Quiz=2 - pt_BR','type_c','Descricao do Type C - Quiz=2 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(12,2,'Type A - Quiz=2 - es_ES','type_a','Descricao do Type A - Quiz=2 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(13,2,'Type B - Quiz=2 - es_ES','type_b','Descricao do Type B - Quiz=2 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(14,2,'Type C - Quiz=2 - es_ES','type_c','Descricao do Type C - Quiz=2 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(15,2,'Type A - Quiz=2 - fr_FR','type_a','Descricao do Type A - Quiz=2 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(16,2,'Type B - Quiz=2 - fr_FR','type_b','Descricao do Type B - Quiz=2 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(17,2,'Type C - Quiz=2 - fr_FR','type_c','Descricao do Type C - Quiz=2 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(18,3,'Type A - Quiz=3 - en_US','type_a','Descricao do Type A - Quiz=3 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(19,3,'Type B - Quiz=3 - en_US','type_b','Descricao do Type B - Quiz=3 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(20,3,'Type C - Quiz=3 - en_US','type_c','Descricao do Type C - Quiz=3 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(21,3,'Type A - Quiz=3 - pt_BR','type_a','Descricao do Type A - Quiz=3 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(22,3,'Type B - Quiz=3 - pt_BR','type_b','Descricao do Type B - Quiz=3 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(23,3,'Type C - Quiz=3 - pt_BR','type_c','Descricao do Type C - Quiz=3 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(24,3,'Type A - Quiz=3 - es_ES','type_a','Descricao do Type A - Quiz=3 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(25,3,'Type B - Quiz=3 - es_ES','type_b','Descricao do Type B - Quiz=3 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(26,3,'Type C - Quiz=3 - es_ES','type_c','Descricao do Type C - Quiz=3 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(27,3,'Type A - Quiz=3 - fr_FR','type_a','Descricao do Type A - Quiz=3 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(28,3,'Type B - Quiz=3 - fr_FR','type_b','Descricao do Type B - Quiz=3 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(29,3,'Type C - Quiz=3 - fr_FR','type_c','Descricao do Type C - Quiz=3 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(30,4,'Type A - Quiz=4 - en_US','type_a','Descricao do Type A - Quiz=4 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(31,4,'Type B - Quiz=4 - en_US','type_b','Descricao do Type B - Quiz=4 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(32,4,'Type C - Quiz=4 - en_US','type_c','Descricao do Type C - Quiz=4 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(33,4,'Type A - Quiz=4 - pt_BR','type_a','Descricao do Type A - Quiz=4 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(34,4,'Type B - Quiz=4 - pt_BR','type_b','Descricao do Type B - Quiz=4 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(35,4,'Type C - Quiz=4 - pt_BR','type_c','Descricao do Type C - Quiz=4 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(36,4,'Type A - Quiz=4 - es_ES','type_a','Descricao do Type A - Quiz=4 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(37,4,'Type B - Quiz=4 - es_ES','type_b','Descricao do Type B - Quiz=4 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(38,4,'Type C - Quiz=4 - es_ES','type_c','Descricao do Type C - Quiz=4 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(39,4,'Type A - Quiz=4 - fr_FR','type_a','Descricao do Type A - Quiz=4 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(40,4,'Type B - Quiz=4 - fr_FR','type_b','Descricao do Type B - Quiz=4 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(41,4,'Type C - Quiz=4 - fr_FR','type_c','Descricao do Type C - Quiz=4 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(42,5,'Type A - Quiz=5 - en_US','type_a','Descricao do Type A - Quiz=5 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(43,5,'Type B - Quiz=5 - en_US','type_b','Descricao do Type B - Quiz=5 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(44,5,'Type C - Quiz=5 - en_US','type_c','Descricao do Type C - Quiz=5 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(45,5,'Type A - Quiz=5 - pt_BR','type_a','Descricao do Type A - Quiz=5 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(46,5,'Type B - Quiz=5 - pt_BR','type_b','Descricao do Type B - Quiz=5 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(47,5,'Type C - Quiz=5 - pt_BR','type_c','Descricao do Type C - Quiz=5 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(48,5,'Type A - Quiz=5 - es_ES','type_a','Descricao do Type A - Quiz=5 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(49,5,'Type B - Quiz=5 - es_ES','type_b','Descricao do Type B - Quiz=5 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(50,5,'Type C - Quiz=5 - es_ES','type_c','Descricao do Type C - Quiz=5 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(51,5,'Type A - Quiz=5 - fr_FR','type_a','Descricao do Type A - Quiz=5 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(52,5,'Type B - Quiz=5 - fr_FR','type_b','Descricao do Type B - Quiz=5 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(53,5,'Type C - Quiz=5 - fr_FR','type_c','Descricao do Type C - Quiz=5 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(54,6,'Type A - Quiz=6 - en_US','type_a','Descricao do Type A - Quiz=6 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(55,6,'Type B - Quiz=6 - en_US','type_b','Descricao do Type B - Quiz=6 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(56,6,'Type C - Quiz=6 - en_US','type_c','Descricao do Type C - Quiz=6 - en_US','en_US','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(57,6,'Type A - Quiz=6 - pt_BR','type_a','Descricao do Type A - Quiz=6 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(58,6,'Type B - Quiz=6 - pt_BR','type_b','Descricao do Type B - Quiz=6 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(59,6,'Type C - Quiz=6 - pt_BR','type_c','Descricao do Type C - Quiz=6 - pt_BR','pt_BR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(60,6,'Type A - Quiz=6 - es_ES','type_a','Descricao do Type A - Quiz=6 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(61,6,'Type B - Quiz=6 - es_ES','type_b','Descricao do Type B - Quiz=6 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(62,6,'Type C - Quiz=6 - es_ES','type_c','Descricao do Type C - Quiz=6 - es_ES','es_ES','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(63,6,'Type A - Quiz=6 - fr_FR','type_a','Descricao do Type A - Quiz=6 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(64,6,'Type B - Quiz=6 - fr_FR','type_b','Descricao do Type B - Quiz=6 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(65,6,'Type C - Quiz=6 - fr_FR','type_c','Descricao do Type C - Quiz=6 - fr_FR','fr_FR','2025-08-21 21:06:29');
INSERT INTO personality_types VALUES(66,2,'🔧 Type A - Quiz=2 - en_US','type_a','🔧 Descricao do Type A - Quiz=2 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(67,2,'🔧 Type B - Quiz=2 - en_US','type_b','🔧 Descricao do Type B - Quiz=2 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(68,2,'🔧 Type C - Quiz=2 - en_US','type_c','🔧 Descricao do Type C - Quiz=2 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(69,2,'🔧 Type A - Quiz=2 - pt_BR','type_a','🔧 Descricao do Type A - Quiz=2 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(70,2,'🔧 Type B - Quiz=2 - pt_BR','type_b','🔧 Descricao do Type B - Quiz=2 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(71,2,'🔧 Type C - Quiz=2 - pt_BR','type_c','🔧 Descricao do Type C - Quiz=2 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(72,2,'🔧 Type A - Quiz=2 - es_ES','type_a','🔧 Descricao do Type A - Quiz=2 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(73,2,'🔧 Type B - Quiz=2 - es_ES','type_b','🔧 Descricao do Type B - Quiz=2 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(74,2,'🔧 Type C - Quiz=2 - es_ES','type_c','🔧 Descricao do Type C - Quiz=2 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(75,2,'🔧 Type A - Quiz=2 - fr_FR','type_a','🔧 Descricao do Type A - Quiz=2 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(76,2,'🔧 Type B - Quiz=2 - fr_FR','type_b','🔧 Descricao do Type B - Quiz=2 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(77,2,'🔧 Type C - Quiz=2 - fr_FR','type_c','🔧 Descricao do Type C - Quiz=2 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(78,3,'🔧 Type A - Quiz=3 - en_US','type_a','🔧 Descricao do Type A - Quiz=3 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(79,3,'🔧 Type B - Quiz=3 - en_US','type_b','🔧 Descricao do Type B - Quiz=3 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(80,3,'🔧 Type C - Quiz=3 - en_US','type_c','🔧 Descricao do Type C - Quiz=3 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(81,3,'🔧 Type A - Quiz=3 - pt_BR','type_a','🔧 Descricao do Type A - Quiz=3 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(82,3,'🔧 Type B - Quiz=3 - pt_BR','type_b','🔧 Descricao do Type B - Quiz=3 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(83,3,'🔧 Type C - Quiz=3 - pt_BR','type_c','🔧 Descricao do Type C - Quiz=3 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(84,3,'🔧 Type A - Quiz=3 - es_ES','type_a','🔧 Descricao do Type A - Quiz=3 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(85,3,'🔧 Type B - Quiz=3 - es_ES','type_b','🔧 Descricao do Type B - Quiz=3 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(86,3,'🔧 Type C - Quiz=3 - es_ES','type_c','🔧 Descricao do Type C - Quiz=3 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(87,3,'🔧 Type A - Quiz=3 - fr_FR','type_a','🔧 Descricao do Type A - Quiz=3 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(88,3,'🔧 Type B - Quiz=3 - fr_FR','type_b','🔧 Descricao do Type B - Quiz=3 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(89,3,'🔧 Type C - Quiz=3 - fr_FR','type_c','🔧 Descricao do Type C - Quiz=3 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(90,4,'🔧 Type A - Quiz=4 - en_US','type_a','🔧 Descricao do Type A - Quiz=4 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(91,4,'🔧 Type B - Quiz=4 - en_US','type_b','🔧 Descricao do Type B - Quiz=4 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(92,4,'🔧 Type C - Quiz=4 - en_US','type_c','🔧 Descricao do Type C - Quiz=4 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(93,4,'🔧 Type A - Quiz=4 - pt_BR','type_a','🔧 Descricao do Type A - Quiz=4 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(94,4,'🔧 Type B - Quiz=4 - pt_BR','type_b','🔧 Descricao do Type B - Quiz=4 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(95,4,'🔧 Type C - Quiz=4 - pt_BR','type_c','🔧 Descricao do Type C - Quiz=4 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(96,4,'🔧 Type A - Quiz=4 - es_ES','type_a','🔧 Descricao do Type A - Quiz=4 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(97,4,'🔧 Type B - Quiz=4 - es_ES','type_b','🔧 Descricao do Type B - Quiz=4 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(98,4,'🔧 Type C - Quiz=4 - es_ES','type_c','🔧 Descricao do Type C - Quiz=4 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(99,4,'🔧 Type A - Quiz=4 - fr_FR','type_a','🔧 Descricao do Type A - Quiz=4 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(100,4,'🔧 Type B - Quiz=4 - fr_FR','type_b','🔧 Descricao do Type B - Quiz=4 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(101,4,'🔧 Type C - Quiz=4 - fr_FR','type_c','🔧 Descricao do Type C - Quiz=4 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(102,5,'🔧 Type A - Quiz=5 - en_US','type_a','🔧 Descricao do Type A - Quiz=5 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(103,5,'🔧 Type B - Quiz=5 - en_US','type_b','🔧 Descricao do Type B - Quiz=5 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(104,5,'🔧 Type C - Quiz=5 - en_US','type_c','🔧 Descricao do Type C - Quiz=5 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(105,5,'🔧 Type A - Quiz=5 - pt_BR','type_a','🔧 Descricao do Type A - Quiz=5 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(106,5,'🔧 Type B - Quiz=5 - pt_BR','type_b','🔧 Descricao do Type B - Quiz=5 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(107,5,'🔧 Type C - Quiz=5 - pt_BR','type_c','🔧 Descricao do Type C - Quiz=5 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(108,5,'🔧 Type A - Quiz=5 - es_ES','type_a','🔧 Descricao do Type A - Quiz=5 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(109,5,'🔧 Type B - Quiz=5 - es_ES','type_b','🔧 Descricao do Type B - Quiz=5 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(110,5,'🔧 Type C - Quiz=5 - es_ES','type_c','🔧 Descricao do Type C - Quiz=5 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(111,5,'🔧 Type A - Quiz=5 - fr_FR','type_a','🔧 Descricao do Type A - Quiz=5 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(112,5,'🔧 Type B - Quiz=5 - fr_FR','type_b','🔧 Descricao do Type B - Quiz=5 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(113,5,'🔧 Type C - Quiz=5 - fr_FR','type_c','🔧 Descricao do Type C - Quiz=5 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(114,6,'🔧 Type A - Quiz=6 - en_US','type_a','🔧 Descricao do Type A - Quiz=6 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(115,6,'🔧 Type B - Quiz=6 - en_US','type_b','🔧 Descricao do Type B - Quiz=6 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(116,6,'🔧 Type C - Quiz=6 - en_US','type_c','🔧 Descricao do Type C - Quiz=6 - en_US','en_US','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(117,6,'🔧 Type A - Quiz=6 - pt_BR','type_a','🔧 Descricao do Type A - Quiz=6 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(118,6,'🔧 Type B - Quiz=6 - pt_BR','type_b','🔧 Descricao do Type B - Quiz=6 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(119,6,'🔧 Type C - Quiz=6 - pt_BR','type_c','🔧 Descricao do Type C - Quiz=6 - pt_BR','pt_BR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(120,6,'🔧 Type A - Quiz=6 - es_ES','type_a','🔧 Descricao do Type A - Quiz=6 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(121,6,'🔧 Type B - Quiz=6 - es_ES','type_b','🔧 Descricao do Type B - Quiz=6 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(122,6,'🔧 Type C - Quiz=6 - es_ES','type_c','🔧 Descricao do Type C - Quiz=6 - es_ES','es_ES','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(123,6,'🔧 Type A - Quiz=6 - fr_FR','type_a','🔧 Descricao do Type A - Quiz=6 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(124,6,'🔧 Type B - Quiz=6 - fr_FR','type_b','🔧 Descricao do Type B - Quiz=6 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(125,6,'🔧 Type C - Quiz=6 - fr_FR','type_c','🔧 Descricao do Type C - Quiz=6 - fr_FR','fr_FR','2025-08-21 21:15:03');
INSERT INTO personality_types VALUES(126,1,'The Communicator','communicator','You value open and honest communication above all else. You believe that talking through problems and expressing feelings clearly is the foundation of any strong relationship.','en_US','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(127,1,'The Nurturer','nurturer','You are naturally caring and supportive. You show love through acts of service, physical affection, and by always being there for your partner when they need you most.','en_US','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(128,1,'The Independent','independent','You value personal space and autonomy in relationships. You believe that two whole individuals make a stronger partnership than two people who lose themselves in each other.','en_US','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(129,1,'The Harmonizer','harmonizer','You prioritize peace and balance in your relationships. You are skilled at finding compromises and creating an atmosphere where both partners feel heard and valued.','en_US','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(130,1,'The Loyalist','loyalist','Trust and commitment are your core values. Once you commit to someone, you are incredibly dedicated and expect the same level of loyalty and reliability in return.','en_US','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(131,1,'O Comunicador','communicator','Você valoriza a comunicação aberta e honesta acima de tudo. Acredita que conversar sobre problemas e expressar sentimentos claramente é a base de qualquer relacionamento forte.','pt_BR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(132,1,'O Cuidador','nurturer','Você é naturalmente carinhoso e solidário. Demonstra amor através de atos de serviço, carinho físico e estando sempre presente quando seu parceiro mais precisa.','pt_BR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(133,1,'O Independente','independent','Você valoriza espaço pessoal e autonomia nos relacionamentos. Acredita que dois indivíduos completos formam uma parceria mais forte do que duas pessoas que se perdem uma na outra.','pt_BR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(134,1,'O Harmonizador','harmonizer','Você prioriza paz e equilíbrio em seus relacionamentos. É hábil em encontrar compromissos e criar uma atmosfera onde ambos os parceiros se sentem ouvidos e valorizados.','pt_BR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(135,1,'O Leal','loyalist','Confiança e comprometimento são seus valores centrais. Uma vez que se compromete com alguém, você é incrivelmente dedicado e espera o mesmo nível de lealdade e confiabilidade em troca.','pt_BR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(136,1,'El Comunicador','communicator','Valoras la comunicación abierta y honesta por encima de todo. Crees que hablar sobre los problemas y expresar los sentimientos claramente es la base de cualquier relación sólida.','es_ES','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(137,1,'El Cuidador','nurturer','Eres naturalmente cariñoso y solidario. Muestras amor a través de actos de servicio, afecto físico y estando siempre ahí para tu pareja cuando más te necesita.','es_ES','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(138,1,'El Independiente','independent','Valoras el espacio personal y la autonomía en las relaciones. Crees que dos individuos completos forman una asociación más fuerte que dos personas que se pierden el uno en el otro.','es_ES','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(139,1,'El Armonizador','harmonizer','Priorizas la paz y el equilibrio en tus relaciones. Eres hábil encontrando compromisos y creando una atmósfera donde ambos compañeros se sienten escuchados y valorados.','es_ES','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(140,1,'El Leal','loyalist','La confianza y el compromiso son tus valores centrales. Una vez que te comprometes con alguien, eres increíblemente dedicado y esperas el mismo nivel de lealtad y confiabilidad a cambio.','es_ES','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(141,1,'Le Communicateur','communicator','Vous valorisez la communication ouverte et honnête par-dessus tout. Vous croyez que parler des problèmes et exprimer clairement les sentiments est la base de toute relation solide.','fr_FR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(142,1,'Le Bienveillant','nurturer','Vous êtes naturellement attentionné et solidaire. Vous montrez votre amour par des actes de service, de l''affection physique et en étant toujours là pour votre partenaire quand il en a le plus besoin.','fr_FR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(143,1,'L''Indépendant','independent','Vous valorisez l''espace personnel et l''autonomie dans les relations. Vous croyez que deux individus complets forment un partenariat plus fort que deux personnes qui se perdent l''une dans l''autre.','fr_FR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(144,1,'L''Harmonisateur','harmonizer','Vous priorisez la paix et l''équilibre dans vos relations. Vous êtes habile à trouver des compromis et à créer une atmosphère où les deux partenaires se sentent entendus et valorisés.','fr_FR','2025-08-21 23:28:42');
INSERT INTO personality_types VALUES(145,1,'Le Loyal','loyalist','La confiance et l''engagement sont vos valeurs centrales. Une fois que vous vous engagez envers quelqu''un, vous êtes incroyablement dévoué et attendez le même niveau de loyauté et de fiabilité en retour.','fr_FR','2025-08-21 23:28:42');
CREATE TABLE advice (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              personality_type_id INTEGER,
              advice_type TEXT NOT NULL,
              advice_text TEXT NOT NULL,
              advice_order INTEGER DEFAULT 0,
              country VARCHAR(5) DEFAULT 'en_US',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (personality_type_id) REFERENCES personality_types(id) ON DELETE CASCADE
            );
INSERT INTO advice VALUES(1,1,'personality','Practice active listening as much as you practice speaking.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(2,1,'personality','Remember that not everyone communicates as directly as you do.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(3,1,'personality','Balance honesty with tactfulness to avoid hurting others.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(4,1,'personality','Recognize when others need processing time before discussions.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(5,1,'personality','Your clarity is a strength that builds trust in relationships.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(6,1,'relationship','Create regular check-ins with partners to maintain open communication.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(7,1,'relationship','When conflicts arise, focus on understanding before being understood.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(8,1,'relationship','Validate others'' feelings even when they differ from your perspective.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(9,1,'relationship','Use ''I'' statements rather than ''you'' statements during difficult conversations.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(10,1,'relationship','Appreciate different communication styles in your relationships.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(11,2,'personality','Set healthy boundaries to avoid emotional burnout.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(12,2,'personality','Make self-care a priority alongside caring for others.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(13,2,'personality','Recognize when you''re taking on others'' emotional burdens.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(14,2,'personality','Allow yourself to receive support, not just give it.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(15,2,'personality','Your empathy is a gift that strengthens connections.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(16,2,'relationship','Communicate your own needs clearly rather than just focusing on others.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(17,2,'relationship','Seek balance between giving and receiving in relationships.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(18,2,'relationship','Find partners who appreciate your nurturing nature without taking advantage.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(19,2,'relationship','Practice saying ''no'' when necessary without feeling guilty.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(20,2,'relationship','Build a support network beyond your primary relationship.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(21,3,'personality','Recognize that some conflict is healthy and necessary.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(22,3,'personality','Stand firm on your core values even when it creates tension.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(23,3,'personality','Distinguish between healthy compromise and self-sacrifice.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(24,3,'personality','Practice expressing disagreement in constructive ways.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(25,3,'personality','Your flexibility is an asset in navigating relationship challenges.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(26,3,'relationship','Ensure your desire for harmony doesn''t silence your authentic voice.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(27,3,'relationship','Set clear expectations about your needs and boundaries.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(28,3,'relationship','Look for partners who value compromise as much as you do.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(29,3,'relationship','Address small issues before they become major problems.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(30,3,'relationship','Celebrate the strength in your adaptability and peacemaking skills.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(31,4,'personality','Balance independence with vulnerability for deeper connections.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(32,4,'personality','Share your internal process with trusted others.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(33,4,'personality','Recognize when self-reliance becomes a barrier to intimacy.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(34,4,'personality','Practice asking for help when needed.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(35,4,'personality','Your self-sufficiency is a strength that brings stability to relationships.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(36,4,'relationship','Communicate your need for space proactively, not reactively.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(37,4,'relationship','Create rituals of connection to balance your independence.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(38,4,'relationship','Look for partners who respect your autonomy without feeling threatened.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(39,4,'relationship','Invest in interdependence alongside independence.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(40,4,'relationship','Share your growth journey with those closest to you.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(41,5,'personality','Ensure your loyalty to others doesn''t override loyalty to yourself.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(42,5,'personality','Recognize that trust can be rebuilt after small breaches.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(43,5,'personality','Balance consistency with spontaneity and growth.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(44,5,'personality','Allow yourself and others room to evolve and change.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(45,5,'personality','Your steadfastness provides valuable security in relationships.',4,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(46,5,'relationship','Communicate your expectations clearly to avoid disappointment.',0,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(47,5,'relationship','Practice forgiveness for minor transgressions.',1,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(48,5,'relationship','Look for partners who value commitment as much as you do.',2,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(49,5,'relationship','Build trust through small, consistent actions over time.',3,'en_US','2025-08-21 19:12:02');
INSERT INTO advice VALUES(50,5,'relationship','Create space for both security and adventure in your relationships.',4,'en_US','2025-08-21 19:12:02');
CREATE TABLE layout_locale (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              country VARCHAR(5) NOT NULL,
              component_name VARCHAR(100) NOT NULL,
              text_content TEXT NOT NULL,
              description TEXT,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              UNIQUE(country, component_name)
            );
CREATE TABLE scoring_rules (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              personality_type_id INTEGER,
              rule_name TEXT NOT NULL,
              rule_type TEXT NOT NULL,
              rule_conditions TEXT NOT NULL,
              weight INTEGER DEFAULT 1,
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
              FOREIGN KEY (personality_type_id) REFERENCES personality_types(id) ON DELETE CASCADE
            );
CREATE TABLE question_weights (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              question_id INTEGER,
              weight_multiplier REAL DEFAULT 1.0,
              importance_level TEXT DEFAULT 'normal',
              is_required INTEGER DEFAULT 0,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
              FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
            );
CREATE TABLE validation_rules (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              rule_name TEXT NOT NULL,
              rule_type TEXT NOT NULL,
              rule_config TEXT NOT NULL,
              error_message TEXT,
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
            );
CREATE TABLE business_rules (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              rule_name TEXT NOT NULL,
              rule_category TEXT NOT NULL,
              rule_config TEXT NOT NULL,
              priority INTEGER DEFAULT 0,
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
            );
CREATE TABLE system_config (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              config_key TEXT UNIQUE NOT NULL,
              config_value TEXT NOT NULL,
              config_type TEXT NOT NULL,
              description TEXT,
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            );
CREATE TABLE quiz_sessions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              session_id TEXT UNIQUE NOT NULL,
              quiz_id INTEGER,
              email TEXT,
              payment_status TEXT DEFAULT 'pending',
              quiz_answers TEXT,
              result_type TEXT,
              personality_type_id INTEGER,
              detailed_scores TEXT,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id),
              FOREIGN KEY (personality_type_id) REFERENCES personality_types(id)
            );
INSERT INTO quiz_sessions VALUES(1,'quiz_1755808880285_9n34tgb66',6,NULL,'pending','[1,1,1,1,1]','loyalist',5,'{"personalityScores":{"communicator":3,"nurturer":1,"harmonizer":0,"independent":6,"loyalist":10},"winningPersonalityType":"loyalist","maxScore":10,"calculatedAt":"2025-08-21T20:41:20.324Z"}','2025-08-21 20:41:20','2025-08-21 20:41:20');
INSERT INTO quiz_sessions VALUES(2,'quiz_1755808942309_7gyby0wqx',6,NULL,'pending','[3,3,3,3,3]','harmonizer',3,'{"personalityScores":{"communicator":1,"nurturer":2,"harmonizer":10,"independent":4,"loyalist":3},"winningPersonalityType":"harmonizer","maxScore":10,"calculatedAt":"2025-08-21T20:42:22.314Z"}','2025-08-21 20:42:22','2025-08-21 20:42:22');
INSERT INTO quiz_sessions VALUES(3,'quiz_1755809075365_94usq1l46',6,NULL,'pending','[1,1,1,1,1]','loyalist',5,'{"personalityScores":{"communicator":3,"nurturer":1,"harmonizer":0,"independent":6,"loyalist":10},"winningPersonalityType":"loyalist","maxScore":10,"calculatedAt":"2025-08-21T20:44:35.381Z"}','2025-08-21 20:44:35','2025-08-21 20:44:35');
INSERT INTO quiz_sessions VALUES(4,'quiz_1755819162290_8yze3br8k',1,NULL,'pending','[3,3,3,3,3,3,3,3,3,3]','harmonizer',129,'{"personalityScores":{"communicator":2,"nurturer":4,"independent":8,"harmonizer":22,"loyalist":4},"winningPersonalityType":"harmonizer","maxScore":22,"calculatedAt":"2025-08-21T23:32:42.346Z"}','2025-08-21 23:32:42','2025-08-21 23:32:42');
CREATE TABLE payments (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              session_id TEXT,
              stripe_payment_id TEXT UNIQUE,
              amount INTEGER NOT NULL,
              currency TEXT DEFAULT 'usd',
              status TEXT DEFAULT 'pending',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (session_id) REFERENCES quiz_sessions(session_id)
            );
INSERT INTO payments VALUES(1,'quiz_1755808880335_500bobi0m','pi_3RyfISECNj29EPC91yFdjF7c',499,'usd','pending','2025-08-21 20:41:20','2025-08-21 20:41:20');
INSERT INTO payments VALUES(2,'quiz_1755808942318_ucj6zvydc','pi_3RyfJSECNj29EPC916aNhhHS',499,'usd','pending','2025-08-21 20:42:22','2025-08-21 20:42:22');
INSERT INTO payments VALUES(3,'quiz_1755809075386_74ublvg7h','pi_3RyfLbECNj29EPC90u68r8Nz',499,'usd','pending','2025-08-21 20:44:35','2025-08-21 20:44:35');
INSERT INTO payments VALUES(4,'quiz_1755819162385_kch002jsm','pi_3RyhyIECNj29EPC913Wjv3qB',499,'usd','pending','2025-08-21 23:32:42','2025-08-21 23:32:42');
CREATE TABLE currencies (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        country VARCHAR(5) NOT NULL UNIQUE,
                        currency VARCHAR(3) NOT NULL,
                        symbol VARCHAR(10) NOT NULL,
                        amount DECIMAL(10,2) NOT NULL,
                        name VARCHAR(100),
                        flag VARCHAR(10),
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
                    );
INSERT INTO currencies VALUES(1,'en_US','USD','$',4.990000000000000213,'English','🇺🇸','2025-08-20 17:46:31','2025-08-20 17:46:31');
INSERT INTO currencies VALUES(2,'pt_BR','BRL','R$',24.98999999999999844,'Português (Brasil)','🇧🇷','2025-08-20 17:46:31','2025-08-20 17:46:31');
INSERT INTO currencies VALUES(3,'es_ES','EUR','€',4.490000000000000213,'Español','🇪🇸','2025-08-20 17:46:31','2025-08-20 17:46:31');
INSERT INTO currencies VALUES(4,'fr_FR','EUR','€',4.490000000000000213,'Français','🇫🇷','2025-08-20 17:49:29','2025-08-20 17:49:29');
CREATE TABLE quiz_images (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        quiz_id INTEGER,
                        image_url TEXT NOT NULL,
                        image_type TEXT NOT NULL, -- 'background_image', 'starting_image', 'advertising_video', 'icon', 'banner'
                        title TEXT,
                        description TEXT,
                        display_order INTEGER DEFAULT 0,
                        is_active INTEGER DEFAULT 1,
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
                    );
INSERT INTO quiz_images VALUES(1,1,'https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Relacionamentos+Pessoais','background_image','Relacionamentos Pessoais','Construa relacionamentos mais profundos',0,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(2,1,'https://via.placeholder.com/300x300/FF6B6B/FFFFFF?text=💕','starting_image','Início do Quiz','Comece sua jornada de autoconhecimento',1,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(3,2,'https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=Desenvolvimento+de+Carreira','background_image','Carreira Profissional','Encontre seu caminho profissional ideal',0,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(4,2,'https://via.placeholder.com/300x300/4ECDC4/FFFFFF?text=🚀','starting_image','Acelere sua Carreira','Descubra seu potencial profissional',1,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(5,3,'https://via.placeholder.com/800x400/45B7D1/FFFFFF?text=Preparação+Entrevistas','background_image','Entrevistas de Sucesso','Conquiste a vaga dos seus sonhos',0,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(6,3,'https://via.placeholder.com/300x300/45B7D1/FFFFFF?text=✨','starting_image','Brilhe na Entrevista','Mostre seu melhor potencial',1,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(7,4,'https://via.placeholder.com/800x400/E74C3C/FFFFFF?text=Conquistas+Amorosas','background_image','Arte da Conquista','Domine a arte da sedução',0,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(8,4,'https://via.placeholder.com/300x300/E74C3C/FFFFFF?text=🌹','starting_image','Conquiste Corações','Desperte seu poder de sedução',1,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(9,5,'https://via.placeholder.com/800x400/9B59B6/FFFFFF?text=Relacionamentos+Duradouros','background_image','Amor Duradouro','Construa um relacionamento para a vida',0,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(10,5,'https://via.placeholder.com/300x300/9B59B6/FFFFFF?text=🏠','starting_image','Construa Juntos','Fortaleça os laços do amor',1,1,'2025-08-21 18:12:40','2025-08-21 18:12:40');
INSERT INTO quiz_images VALUES(11,1,'https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Relacionamentos+Pessoais','background_image','Relacionamentos Pessoais','Construa relacionamentos mais profundos',0,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(12,1,'https://via.placeholder.com/300x300/FF6B6B/FFFFFF?text=💕','starting_image','Início do Quiz','Comece sua jornada de autoconhecimento',1,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(13,2,'https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=Desenvolvimento+de+Carreira','background_image','Carreira Profissional','Encontre seu caminho profissional ideal',0,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(14,2,'https://via.placeholder.com/300x300/4ECDC4/FFFFFF?text=🚀','starting_image','Acelere sua Carreira','Descubra seu potencial profissional',1,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(15,3,'https://via.placeholder.com/800x400/45B7D1/FFFFFF?text=Preparação+Entrevistas','background_image','Entrevistas de Sucesso','Conquiste a vaga dos seus sonhos',0,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(16,3,'https://via.placeholder.com/300x300/45B7D1/FFFFFF?text=✨','starting_image','Brilhe na Entrevista','Mostre seu melhor potencial',1,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(17,4,'https://via.placeholder.com/800x400/E74C3C/FFFFFF?text=Conquistas+Amorosas','background_image','Arte da Conquista','Domine a arte da sedução',0,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(18,4,'https://via.placeholder.com/300x300/E74C3C/FFFFFF?text=🌹','starting_image','Conquiste Corações','Desperte seu poder de sedução',1,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(19,5,'https://via.placeholder.com/800x400/9B59B6/FFFFFF?text=Relacionamentos+Duradouros','background_image','Amor Duradouro','Construa um relacionamento para a vida',0,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(20,5,'https://via.placeholder.com/300x300/9B59B6/FFFFFF?text=🏠','starting_image','Construa Juntos','Fortaleça os laços do amor',1,1,'2025-08-21 18:59:14','2025-08-21 18:59:14');
INSERT INTO quiz_images VALUES(21,1,'https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Relacionamentos+Pessoais','background_image','Relacionamentos Pessoais','Construa relacionamentos mais profundos',0,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(22,1,'https://via.placeholder.com/300x300/FF6B6B/FFFFFF?text=💕','starting_image','Início do Quiz','Comece sua jornada de autoconhecimento',1,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(23,2,'https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=Desenvolvimento+de+Carreira','background_image','Carreira Profissional','Encontre seu caminho profissional ideal',0,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(24,2,'https://via.placeholder.com/300x300/4ECDC4/FFFFFF?text=🚀','starting_image','Acelere sua Carreira','Descubra seu potencial profissional',1,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(25,3,'https://via.placeholder.com/800x400/45B7D1/FFFFFF?text=Preparação+Entrevistas','background_image','Entrevistas de Sucesso','Conquiste a vaga dos seus sonhos',0,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(26,3,'https://via.placeholder.com/300x300/45B7D1/FFFFFF?text=✨','starting_image','Brilhe na Entrevista','Mostre seu melhor potencial',1,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(27,4,'https://via.placeholder.com/800x400/E74C3C/FFFFFF?text=Conquistas+Amorosas','background_image','Arte da Conquista','Domine a arte da sedução',0,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(28,4,'https://via.placeholder.com/300x300/E74C3C/FFFFFF?text=🌹','starting_image','Conquiste Corações','Desperte seu poder de sedução',1,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(29,5,'https://via.placeholder.com/800x400/9B59B6/FFFFFF?text=Relacionamentos+Duradouros','background_image','Amor Duradouro','Construa um relacionamento para a vida',0,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
INSERT INTO quiz_images VALUES(30,5,'https://via.placeholder.com/300x300/9B59B6/FFFFFF?text=🏠','starting_image','Construa Juntos','Fortaleça os laços do amor',1,1,'2025-08-21 19:05:29','2025-08-21 19:05:29');
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('currencies',4);
INSERT INTO sqlite_sequence VALUES('quiz_images',30);
INSERT INTO sqlite_sequence VALUES('quizzes',6);
INSERT INTO sqlite_sequence VALUES('categories',5);
INSERT INTO sqlite_sequence VALUES('personality_types',145);
INSERT INTO sqlite_sequence VALUES('advice',50);
INSERT INTO sqlite_sequence VALUES('questions',240);
INSERT INTO sqlite_sequence VALUES('answer_options',193);
INSERT INTO sqlite_sequence VALUES('quiz_sessions',4);
INSERT INTO sqlite_sequence VALUES('payments',4);
CREATE INDEX idx_quiz_sessions_session_id ON quiz_sessions(session_id);
CREATE INDEX idx_payments_stripe_id ON payments(stripe_payment_id);
CREATE INDEX idx_payments_session_id ON payments(session_id);
CREATE INDEX idx_questions_quiz_id ON questions(quiz_id);
CREATE INDEX idx_answer_options_question_id ON answer_options(question_id);
CREATE INDEX idx_advice_type_id ON advice(personality_type_id);
CREATE INDEX idx_quiz_images_quiz_id ON quiz_images(quiz_id);
CREATE INDEX idx_quiz_images_type ON quiz_images(image_type);
CREATE INDEX idx_quizzes_coach_type ON quizzes(coach_type);
CREATE INDEX idx_quizzes_coach_category ON quizzes(coach_category);
CREATE INDEX idx_quizzes_is_active ON quizzes(is_active);
COMMIT;
