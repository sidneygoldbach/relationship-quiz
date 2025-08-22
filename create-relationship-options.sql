-- Criar opções para as perguntas verdadeiras de relacionamento

-- Primeiro, vou buscar os IDs das perguntas criadas
-- Pergunta 1 em inglês: "How do you typically handle conflicts in relationships?"
-- Vou assumir que os IDs começam a partir do próximo disponível

-- Opções para Pergunta 1 (Conflitos) - en_US
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'I prefer to address issues immediately and directly', 0, '{"communicator": 3, "independent": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 1 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'I need time to process before discussing', 1, '{"independent": 3, "loyalist": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 1 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'I try to find a compromise that works for everyone', 2, '{"harmonizer": 3, "nurturer": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 1 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'I sometimes avoid confrontation to keep the peace', 3, '{"harmonizer": 2, "nurturer": 2}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 1 AND country = 'en_US';

-- Opções para Pergunta 2 (Importância) - en_US
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Open and honest communication', 0, '{"communicator": 3, "loyalist": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 2 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Trust and mutual loyalty', 1, '{"loyalist": 3, "nurturer": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 2 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Emotional support and understanding', 2, '{"nurturer": 3, "harmonizer": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 2 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Respect for individual independence', 3, '{"independent": 3, "communicator": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 2 AND country = 'en_US';

-- Opções para Pergunta 3 (Expressão de afeto) - en_US
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Through physical touch and closeness', 0, '{"nurturer": 3, "harmonizer": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 3 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'By giving gifts or doing thoughtful acts of service', 1, '{"nurturer": 3, "loyalist": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 3 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'With words of affirmation and praise', 2, '{"communicator": 3, "nurturer": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 3 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'By spending quality time together', 3, '{"harmonizer": 3, "loyalist": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 3 AND country = 'en_US';

-- Opções para Pergunta 4 (Decisões) - en_US
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Take the lead and make decisions confidently', 0, '{"independent": 3, "communicator": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 4 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Discuss all options thoroughly before deciding together', 1, '{"communicator": 3, "harmonizer": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 4 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Consider your partner needs first', 2, '{"nurturer": 3, "harmonizer": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 4 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Be flexible and go with the flow', 3, '{"harmonizer": 3, "independent": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 4 AND country = 'en_US';

-- Opções para Pergunta 5 (Reações emocionais) - en_US
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Express my feelings immediately and directly', 0, '{"communicator": 3, "independent": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 5 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Withdraw and process my emotions privately', 1, '{"independent": 3, "loyalist": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 5 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Seek comfort and support from my partner', 2, '{"nurturer": 3, "harmonizer": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 5 AND country = 'en_US';

INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
SELECT id, 'Try to understand their perspective first', 3, '{"harmonizer": 3, "loyalist": 1}', 'en_US'
FROM questions WHERE quiz_id = 1 AND question_order = 5 AND country = 'en_US';