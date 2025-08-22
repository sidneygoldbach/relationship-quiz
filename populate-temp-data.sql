-- Script para popular dados temporários no PostgreSQL
-- Símbolo 🔧 usado para identificar dados temporários

-- Criar quizzes temporários (mantendo quiz 1 intacto)
INSERT INTO quizzes (id, name, title, description, result_title, price, currency) VALUES 
(2, '🔧 professional-coach', '🔧 Professional Coach Quiz', '🔧 Professional relationship coaching quiz', 'Personality Type', 100, 'usd'),
(3, '🔧 romantic-coach', '🔧 Romantic Coach Quiz', '🔧 Romantic relationship coaching quiz', 'Personality Type', 100, 'usd'),
(4, '🔧 family-coach', '🔧 Family Coach Quiz', '🔧 Family relationship coaching quiz', 'Personality Type', 100, 'usd'),
(5, '🔧 friendship-coach', '🔧 Friendship Coach Quiz', '🔧 Friendship relationship coaching quiz', 'Personality Type', 100, 'usd'),
(6, '🔧 personal-growth', '🔧 Personal Growth Quiz', '🔧 Personal growth and development quiz', 'Personality Type', 100, 'usd')
ON CONFLICT (id) DO NOTHING;

-- Criar perguntas temporárias para cada quiz e idioma
-- Quiz 2 - Professional Coach
INSERT INTO questions (quiz_id, question_text, question_order, country) VALUES 
-- English
(2, '🔧 Question 1 - Quiz=2 - en_US', 1, 'en_US'),
(2, '🔧 Question 2 - Quiz=2 - en_US', 2, 'en_US'),
(2, '🔧 Question 3 - Quiz=2 - en_US', 3, 'en_US'),
(2, '🔧 Question 4 - Quiz=2 - en_US', 4, 'en_US'),
(2, '🔧 Question 5 - Quiz=2 - en_US', 5, 'en_US'),
-- Portuguese
(2, '🔧 Pergunta 1 - Quiz=2 - pt_BR', 1, 'pt_BR'),
(2, '🔧 Pergunta 2 - Quiz=2 - pt_BR', 2, 'pt_BR'),
(2, '🔧 Pergunta 3 - Quiz=2 - pt_BR', 3, 'pt_BR'),
(2, '🔧 Pergunta 4 - Quiz=2 - pt_BR', 4, 'pt_BR'),
(2, '🔧 Pergunta 5 - Quiz=2 - pt_BR', 5, 'pt_BR'),
-- Spanish
(2, '🔧 Pregunta 1 - Quiz=2 - es_ES', 1, 'es_ES'),
(2, '🔧 Pregunta 2 - Quiz=2 - es_ES', 2, 'es_ES'),
(2, '🔧 Pregunta 3 - Quiz=2 - es_ES', 3, 'es_ES'),
(2, '🔧 Pregunta 4 - Quiz=2 - es_ES', 4, 'es_ES'),
(2, '🔧 Pregunta 5 - Quiz=2 - es_ES', 5, 'es_ES'),
-- French
(2, '🔧 Question 1 - Quiz=2 - fr_FR', 1, 'fr_FR'),
(2, '🔧 Question 2 - Quiz=2 - fr_FR', 2, 'fr_FR'),
(2, '🔧 Question 3 - Quiz=2 - fr_FR', 3, 'fr_FR'),
(2, '🔧 Question 4 - Quiz=2 - fr_FR', 4, 'fr_FR'),
(2, '🔧 Question 5 - Quiz=2 - fr_FR', 5, 'fr_FR');

-- Quiz 3 - Romantic Coach
INSERT INTO questions (quiz_id, question_text, question_order, country) VALUES 
-- English
(3, '🔧 Question 1 - Quiz=3 - en_US', 1, 'en_US'),
(3, '🔧 Question 2 - Quiz=3 - en_US', 2, 'en_US'),
(3, '🔧 Question 3 - Quiz=3 - en_US', 3, 'en_US'),
(3, '🔧 Question 4 - Quiz=3 - en_US', 4, 'en_US'),
(3, '🔧 Question 5 - Quiz=3 - en_US', 5, 'en_US'),
-- Portuguese
(3, '🔧 Pergunta 1 - Quiz=3 - pt_BR', 1, 'pt_BR'),
(3, '🔧 Pergunta 2 - Quiz=3 - pt_BR', 2, 'pt_BR'),
(3, '🔧 Pergunta 3 - Quiz=3 - pt_BR', 3, 'pt_BR'),
(3, '🔧 Pergunta 4 - Quiz=3 - pt_BR', 4, 'pt_BR'),
(3, '🔧 Pergunta 5 - Quiz=3 - pt_BR', 5, 'pt_BR'),
-- Spanish
(3, '🔧 Pregunta 1 - Quiz=3 - es_ES', 1, 'es_ES'),
(3, '🔧 Pregunta 2 - Quiz=3 - es_ES', 2, 'es_ES'),
(3, '🔧 Pregunta 3 - Quiz=3 - es_ES', 3, 'es_ES'),
(3, '🔧 Pregunta 4 - Quiz=3 - es_ES', 4, 'es_ES'),
(3, '🔧 Pregunta 5 - Quiz=3 - es_ES', 5, 'es_ES'),
-- French
(3, '🔧 Question 1 - Quiz=3 - fr_FR', 1, 'fr_FR'),
(3, '🔧 Question 2 - Quiz=3 - fr_FR', 2, 'fr_FR'),
(3, '🔧 Question 3 - Quiz=3 - fr_FR', 3, 'fr_FR'),
(3, '🔧 Question 4 - Quiz=3 - fr_FR', 4, 'fr_FR'),
(3, '🔧 Question 5 - Quiz=3 - fr_FR', 5, 'fr_FR');

-- Quiz 4 - Family Coach
INSERT INTO questions (quiz_id, question_text, question_order, country) VALUES 
-- English
(4, '🔧 Question 1 - Quiz=4 - en_US', 1, 'en_US'),
(4, '🔧 Question 2 - Quiz=4 - en_US', 2, 'en_US'),
(4, '🔧 Question 3 - Quiz=4 - en_US', 3, 'en_US'),
(4, '🔧 Question 4 - Quiz=4 - en_US', 4, 'en_US'),
(4, '🔧 Question 5 - Quiz=4 - en_US', 5, 'en_US'),
-- Portuguese
(4, '🔧 Pergunta 1 - Quiz=4 - pt_BR', 1, 'pt_BR'),
(4, '🔧 Pergunta 2 - Quiz=4 - pt_BR', 2, 'pt_BR'),
(4, '🔧 Pergunta 3 - Quiz=4 - pt_BR', 3, 'pt_BR'),
(4, '🔧 Pergunta 4 - Quiz=4 - pt_BR', 4, 'pt_BR'),
(4, '🔧 Pergunta 5 - Quiz=4 - pt_BR', 5, 'pt_BR'),
-- Spanish
(4, '🔧 Pregunta 1 - Quiz=4 - es_ES', 1, 'es_ES'),
(4, '🔧 Pregunta 2 - Quiz=4 - es_ES', 2, 'es_ES'),
(4, '🔧 Pregunta 3 - Quiz=4 - es_ES', 3, 'es_ES'),
(4, '🔧 Pregunta 4 - Quiz=4 - es_ES', 4, 'es_ES'),
(4, '🔧 Pregunta 5 - Quiz=4 - es_ES', 5, 'es_ES'),
-- French
(4, '🔧 Question 1 - Quiz=4 - fr_FR', 1, 'fr_FR'),
(4, '🔧 Question 2 - Quiz=4 - fr_FR', 2, 'fr_FR'),
(4, '🔧 Question 3 - Quiz=4 - fr_FR', 3, 'fr_FR'),
(4, '🔧 Question 4 - Quiz=4 - fr_FR', 4, 'fr_FR'),
(4, '🔧 Question 5 - Quiz=4 - fr_FR', 5, 'fr_FR');

-- Quiz 5 - Friendship Coach
INSERT INTO questions (quiz_id, question_text, question_order, country) VALUES 
-- English
(5, '🔧 Question 1 - Quiz=5 - en_US', 1, 'en_US'),
(5, '🔧 Question 2 - Quiz=5 - en_US', 2, 'en_US'),
(5, '🔧 Question 3 - Quiz=5 - en_US', 3, 'en_US'),
(5, '🔧 Question 4 - Quiz=5 - en_US', 4, 'en_US'),
(5, '🔧 Question 5 - Quiz=5 - en_US', 5, 'en_US'),
-- Portuguese
(5, '🔧 Pergunta 1 - Quiz=5 - pt_BR', 1, 'pt_BR'),
(5, '🔧 Pergunta 2 - Quiz=5 - pt_BR', 2, 'pt_BR'),
(5, '🔧 Pergunta 3 - Quiz=5 - pt_BR', 3, 'pt_BR'),
(5, '🔧 Pergunta 4 - Quiz=5 - pt_BR', 4, 'pt_BR'),
(5, '🔧 Pergunta 5 - Quiz=5 - pt_BR', 5, 'pt_BR'),
-- Spanish
(5, '🔧 Pregunta 1 - Quiz=5 - es_ES', 1, 'es_ES'),
(5, '🔧 Pregunta 2 - Quiz=5 - es_ES', 2, 'es_ES'),
(5, '🔧 Pregunta 3 - Quiz=5 - es_ES', 3, 'es_ES'),
(5, '🔧 Pregunta 4 - Quiz=5 - es_ES', 4, 'es_ES'),
(5, '🔧 Pregunta 5 - Quiz=5 - es_ES', 5, 'es_ES'),
-- French
(5, '🔧 Question 1 - Quiz=5 - fr_FR', 1, 'fr_FR'),
(5, '🔧 Question 2 - Quiz=5 - fr_FR', 2, 'fr_FR'),
(5, '🔧 Question 3 - Quiz=5 - fr_FR', 3, 'fr_FR'),
(5, '🔧 Question 4 - Quiz=5 - fr_FR', 4, 'fr_FR'),
(5, '🔧 Question 5 - Quiz=5 - fr_FR', 5, 'fr_FR');

-- Quiz 6 - Personal Growth
INSERT INTO questions (quiz_id, question_text, question_order, country) VALUES 
-- English
(6, '🔧 Question 1 - Quiz=6 - en_US', 1, 'en_US'),
(6, '🔧 Question 2 - Quiz=6 - en_US', 2, 'en_US'),
(6, '🔧 Question 3 - Quiz=6 - en_US', 3, 'en_US'),
(6, '🔧 Question 4 - Quiz=6 - en_US', 4, 'en_US'),
(6, '🔧 Question 5 - Quiz=6 - en_US', 5, 'en_US'),
-- Portuguese
(6, '🔧 Pergunta 1 - Quiz=6 - pt_BR', 1, 'pt_BR'),
(6, '🔧 Pergunta 2 - Quiz=6 - pt_BR', 2, 'pt_BR'),
(6, '🔧 Pergunta 3 - Quiz=6 - pt_BR', 3, 'pt_BR'),
(6, '🔧 Pergunta 4 - Quiz=6 - pt_BR', 4, 'pt_BR'),
(6, '🔧 Pergunta 5 - Quiz=6 - pt_BR', 5, 'pt_BR'),
-- Spanish
(6, '🔧 Pregunta 1 - Quiz=6 - es_ES', 1, 'es_ES'),
(6, '🔧 Pregunta 2 - Quiz=6 - es_ES', 2, 'es_ES'),
(6, '🔧 Pregunta 3 - Quiz=6 - es_ES', 3, 'es_ES'),
(6, '🔧 Pregunta 4 - Quiz=6 - es_ES', 4, 'es_ES'),
(6, '🔧 Pregunta 5 - Quiz=6 - es_ES', 5, 'es_ES'),
-- French
(6, '🔧 Question 1 - Quiz=6 - fr_FR', 1, 'fr_FR'),
(6, '🔧 Question 2 - Quiz=6 - fr_FR', 2, 'fr_FR'),
(6, '🔧 Question 3 - Quiz=6 - fr_FR', 3, 'fr_FR'),
(6, '🔧 Question 4 - Quiz=6 - fr_FR', 4, 'fr_FR'),
(6, '🔧 Question 5 - Quiz=6 - fr_FR', 5, 'fr_FR');

ECHO 'Questions created successfully!';

-- Criar tipos de personalidade temporários
INSERT INTO personality_types (quiz_id, type_name, type_key, description, country) VALUES 
-- Quiz 2 - Professional Coach
(2, '🔧 Type A - Quiz=2 - en_US', 'type_a', '🔧 Description Type A - Quiz=2 - en_US', 'en_US'),
(2, '🔧 Type B - Quiz=2 - en_US', 'type_b', '🔧 Description Type B - Quiz=2 - en_US', 'en_US'),
(2, '🔧 Type C - Quiz=2 - en_US', 'type_c', '🔧 Description Type C - Quiz=2 - en_US', 'en_US'),
(2, '🔧 Tipo A - Quiz=2 - pt_BR', 'type_a', '🔧 Descrição Tipo A - Quiz=2 - pt_BR', 'pt_BR'),
(2, '🔧 Tipo B - Quiz=2 - pt_BR', 'type_b', '🔧 Descrição Tipo B - Quiz=2 - pt_BR', 'pt_BR'),
(2, '🔧 Tipo C - Quiz=2 - pt_BR', 'type_c', '🔧 Descrição Tipo C - Quiz=2 - pt_BR', 'pt_BR'),
(2, '🔧 Tipo A - Quiz=2 - es_ES', 'type_a', '🔧 Descripción Tipo A - Quiz=2 - es_ES', 'es_ES'),
(2, '🔧 Tipo B - Quiz=2 - es_ES', 'type_b', '🔧 Descripción Tipo B - Quiz=2 - es_ES', 'es_ES'),
(2, '🔧 Tipo C - Quiz=2 - es_ES', 'type_c', '🔧 Descripción Tipo C - Quiz=2 - es_ES', 'es_ES'),
(2, '🔧 Type A - Quiz=2 - fr_FR', 'type_a', '🔧 Description Type A - Quiz=2 - fr_FR', 'fr_FR'),
(2, '🔧 Type B - Quiz=2 - fr_FR', 'type_b', '🔧 Description Type B - Quiz=2 - fr_FR', 'fr_FR'),
(2, '🔧 Type C - Quiz=2 - fr_FR', 'type_c', '🔧 Description Type C - Quiz=2 - fr_FR', 'fr_FR');

-- Continuar com outros quizzes...
-- Quiz 3 - Romantic Coach
INSERT INTO personality_types (quiz_id, type_name, type_key, description, country) VALUES 
(3, '🔧 Type A - Quiz=3 - en_US', 'type_a', '🔧 Description Type A - Quiz=3 - en_US', 'en_US'),
(3, '🔧 Type B - Quiz=3 - en_US', 'type_b', '🔧 Description Type B - Quiz=3 - en_US', 'en_US'),
(3, '🔧 Type C - Quiz=3 - en_US', 'type_c', '🔧 Description Type C - Quiz=3 - en_US', 'en_US'),
(3, '🔧 Tipo A - Quiz=3 - pt_BR', 'type_a', '🔧 Descrição Tipo A - Quiz=3 - pt_BR', 'pt_BR'),
(3, '🔧 Tipo B - Quiz=3 - pt_BR', 'type_b', '🔧 Descrição Tipo B - Quiz=3 - pt_BR', 'pt_BR'),
(3, '🔧 Tipo C - Quiz=3 - pt_BR', 'type_c', '🔧 Descrição Tipo C - Quiz=3 - pt_BR', 'pt_BR'),
(3, '🔧 Tipo A - Quiz=3 - es_ES', 'type_a', '🔧 Descripción Tipo A - Quiz=3 - es_ES', 'es_ES'),
(3, '🔧 Tipo B - Quiz=3 - es_ES', 'type_b', '🔧 Descripción Tipo B - Quiz=3 - es_ES', 'es_ES'),
(3, '🔧 Tipo C - Quiz=3 - es_ES', 'type_c', '🔧 Descripción Tipo C - Quiz=3 - es_ES', 'es_ES'),
(3, '🔧 Type A - Quiz=3 - fr_FR', 'type_a', '🔧 Description Type A - Quiz=3 - fr_FR', 'fr_FR'),
(3, '🔧 Type B - Quiz=3 - fr_FR', 'type_b', '🔧 Description Type B - Quiz=3 - fr_FR', 'fr_FR'),
(3, '🔧 Type C - Quiz=3 - fr_FR', 'type_c', '🔧 Description Type C - Quiz=3 - fr_FR', 'fr_FR');

-- Quiz 4, 5, 6 seguem o mesmo padrão...
-- Quiz 4 - Family Coach
INSERT INTO personality_types (quiz_id, type_name, type_key, description, country) VALUES 
(4, '🔧 Type A - Quiz=4 - en_US', 'type_a', '🔧 Description Type A - Quiz=4 - en_US', 'en_US'),
(4, '🔧 Type B - Quiz=4 - en_US', 'type_b', '🔧 Description Type B - Quiz=4 - en_US', 'en_US'),
(4, '🔧 Type C - Quiz=4 - en_US', 'type_c', '🔧 Description Type C - Quiz=4 - en_US', 'en_US'),
(4, '🔧 Tipo A - Quiz=4 - pt_BR', 'type_a', '🔧 Descrição Tipo A - Quiz=4 - pt_BR', 'pt_BR'),
(4, '🔧 Tipo B - Quiz=4 - pt_BR', 'type_b', '🔧 Descrição Tipo B - Quiz=4 - pt_BR', 'pt_BR'),
(4, '🔧 Tipo C - Quiz=4 - pt_BR', 'type_c', '🔧 Descrição Tipo C - Quiz=4 - pt_BR', 'pt_BR'),
(4, '🔧 Tipo A - Quiz=4 - es_ES', 'type_a', '🔧 Descripción Tipo A - Quiz=4 - es_ES', 'es_ES'),
(4, '🔧 Tipo B - Quiz=4 - es_ES', 'type_b', '🔧 Descripción Tipo B - Quiz=4 - es_ES', 'es_ES'),
(4, '🔧 Tipo C - Quiz=4 - es_ES', 'type_c', '🔧 Descripción Tipo C - Quiz=4 - es_ES', 'es_ES'),
(4, '🔧 Type A - Quiz=4 - fr_FR', 'type_a', '🔧 Description Type A - Quiz=4 - fr_FR', 'fr_FR'),
(4, '🔧 Type B - Quiz=4 - fr_FR', 'type_b', '🔧 Description Type B - Quiz=4 - fr_FR', 'fr_FR'),
(4, '🔧 Type C - Quiz=4 - fr_FR', 'type_c', '🔧 Description Type C - Quiz=4 - fr_FR', 'fr_FR');

-- Quiz 5 - Friendship Coach
INSERT INTO personality_types (quiz_id, type_name, type_key, description, country) VALUES 
(5, '🔧 Type A - Quiz=5 - en_US', 'type_a', '🔧 Description Type A - Quiz=5 - en_US', 'en_US'),
(5, '🔧 Type B - Quiz=5 - en_US', 'type_b', '🔧 Description Type B - Quiz=5 - en_US', 'en_US'),
(5, '🔧 Type C - Quiz=5 - en_US', 'type_c', '🔧 Description Type C - Quiz=5 - en_US', 'en_US'),
(5, '🔧 Tipo A - Quiz=5 - pt_BR', 'type_a', '🔧 Descrição Tipo A - Quiz=5 - pt_BR', 'pt_BR'),
(5, '🔧 Tipo B - Quiz=5 - pt_BR', 'type_b', '🔧 Descrição Tipo B - Quiz=5 - pt_BR', 'pt_BR'),
(5, '🔧 Tipo C - Quiz=5 - pt_BR', 'type_c', '🔧 Descrição Tipo C - Quiz=5 - pt_BR', 'pt_BR'),
(5, '🔧 Tipo A - Quiz=5 - es_ES', 'type_a', '🔧 Descripción Tipo A - Quiz=5 - es_ES', 'es_ES'),
(5, '🔧 Tipo B - Quiz=5 - es_ES', 'type_b', '🔧 Descripción Tipo B - Quiz=5 - es_ES', 'es_ES'),
(5, '🔧 Tipo C - Quiz=5 - es_ES', 'type_c', '🔧 Descripción Tipo C - Quiz=5 - es_ES', 'es_ES'),
(5, '🔧 Type A - Quiz=5 - fr_FR', 'type_a', '🔧 Description Type A - Quiz=5 - fr_FR', 'fr_FR'),
(5, '🔧 Type B - Quiz=5 - fr_FR', 'type_b', '🔧 Description Type B - Quiz=5 - fr_FR', 'fr_FR'),
(5, '🔧 Type C - Quiz=5 - fr_FR', 'type_c', '🔧 Description Type C - Quiz=5 - fr_FR', 'fr_FR');

-- Quiz 6 - Personal Growth
INSERT INTO personality_types (quiz_id, type_name, type_key, description, country) VALUES 
(6, '🔧 Type A - Quiz=6 - en_US', 'type_a', '🔧 Description Type A - Quiz=6 - en_US', 'en_US'),
(6, '🔧 Type B - Quiz=6 - en_US', 'type_b', '🔧 Description Type B - Quiz=6 - en_US', 'en_US'),
(6, '🔧 Type C - Quiz=6 - en_US', 'type_c', '🔧 Description Type C - Quiz=6 - en_US', 'en_US'),
(6, '🔧 Tipo A - Quiz=6 - pt_BR', 'type_a', '🔧 Descrição Tipo A - Quiz=6 - pt_BR', 'pt_BR'),
(6, '🔧 Tipo B - Quiz=6 - pt_BR', 'type_b', '🔧 Descrição Tipo B - Quiz=6 - pt_BR', 'pt_BR'),
(6, '🔧 Tipo C - Quiz=6 - pt_BR', 'type_c', '🔧 Descrição Tipo C - Quiz=6 - pt_BR', 'pt_BR'),
(6, '🔧 Tipo A - Quiz=6 - es_ES', 'type_a', '🔧 Descripción Tipo A - Quiz=6 - es_ES', 'es_ES'),
(6, '🔧 Tipo B - Quiz=6 - es_ES', 'type_b', '🔧 Descripción Tipo B - Quiz=6 - es_ES', 'es_ES'),
(6, '🔧 Tipo C - Quiz=6 - es_ES', 'type_c', '🔧 Descripción Tipo C - Quiz=6 - es_ES', 'es_ES'),
(6, '🔧 Type A - Quiz=6 - fr_FR', 'type_a', '🔧 Description Type A - Quiz=6 - fr_FR', 'fr_FR'),
(6, '🔧 Type B - Quiz=6 - fr_FR', 'type_b', '🔧 Description Type B - Quiz=6 - fr_FR', 'fr_FR'),
(6, '🔧 Type C - Quiz=6 - fr_FR', 'type_c', '🔧 Description Type C - Quiz=6 - fr_FR', 'fr_FR');

ECHO 'Personality types created successfully!';

-- Criar opções de resposta temporárias
-- Nota: Este script será executado em partes devido ao tamanho
ECHO 'Script part 1 completed. Run populate-temp-options.sql next for answer options.';