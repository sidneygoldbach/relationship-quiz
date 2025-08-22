-- Script para popular a tabela question_weights para quizzes 2-6
-- Baseado na estrutura real da tabela

BEGIN;

-- Vamos verificar os dados existentes do quiz 1 primeiro
-- SELECT * FROM question_weights WHERE quiz_id = 1;

-- Criar pesos para todas as perguntas dos quizzes 2-6
INSERT INTO question_weights (quiz_id, question_id, weight_multiplier, importance_level, is_required)
SELECT 
    q.quiz_id,
    q.id as question_id,
    CASE 
        WHEN q.question_order <= 5 THEN 2.0  -- Primeiras 5 perguntas são mais importantes
        WHEN q.question_order <= 10 THEN 1.5 -- Próximas 5 são moderadamente importantes
        ELSE 1.0  -- Restantes têm peso normal
    END as weight_multiplier,
    CASE 
        WHEN q.question_order <= 3 THEN 'high'
        WHEN q.question_order <= 8 THEN 'normal'
        ELSE 'low'
    END as importance_level,
    CASE 
        WHEN q.question_order <= 5 THEN true  -- Primeiras 5 são obrigatórias
        ELSE false
    END as is_required
FROM questions q
WHERE q.quiz_id IN (2, 3, 4, 5, 6)
  AND NOT EXISTS (
    SELECT 1 FROM question_weights qw 
    WHERE qw.question_id = q.id
  );

-- Vamos criar algumas variações específicas por quiz para tornar mais realista

-- Quiz 2 (Professional Coach Quiz) - foco em perguntas de liderança
UPDATE question_weights 
SET weight_multiplier = 2.5, importance_level = 'high'
WHERE quiz_id = 2 
  AND question_id IN (
    SELECT id FROM questions 
    WHERE quiz_id = 2 
    AND question_order IN (1, 5, 10, 15, 20)
  );

-- Quiz 3 (Romantic Coach Quiz) - foco em perguntas de relacionamento
UPDATE question_weights 
SET weight_multiplier = 2.5, importance_level = 'high'
WHERE quiz_id = 3 
  AND question_id IN (
    SELECT id FROM questions 
    WHERE quiz_id = 3 
    AND question_order IN (2, 6, 11, 16, 19)
  );

-- Quiz 4 (Family Coach Quiz) - foco em perguntas de família
UPDATE question_weights 
SET weight_multiplier = 2.5, importance_level = 'high'
WHERE quiz_id = 4 
  AND question_id IN (
    SELECT id FROM questions 
    WHERE quiz_id = 4 
    AND question_order IN (3, 7, 12, 17, 20)
  );

-- Quiz 5 (Friendship Coach Quiz) - foco em perguntas de amizade
UPDATE question_weights 
SET weight_multiplier = 2.5, importance_level = 'high'
WHERE quiz_id = 5 
  AND question_id IN (
    SELECT id FROM questions 
    WHERE quiz_id = 5 
    AND question_order IN (4, 8, 13, 18, 20)
  );

-- Quiz 6 (Personal Growth Quiz) - foco em perguntas de crescimento pessoal
UPDATE question_weights 
SET weight_multiplier = 2.5, importance_level = 'high'
WHERE quiz_id = 6 
  AND question_id IN (
    SELECT id FROM questions 
    WHERE quiz_id = 6 
    AND question_order IN (1, 9, 14, 18, 20)
  );

COMMIT;