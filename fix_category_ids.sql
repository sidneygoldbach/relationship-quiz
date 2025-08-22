-- Script para corrigir category_id NULL nas perguntas
-- Distribuindo categorias de forma equilibrada

BEGIN;

-- Primeiro, vamos ver quantas categorias temos disponíveis
-- SELECT COUNT(*) FROM categories; -- 15 categorias

-- Para o Quiz 1 (Relationship Personality Quiz)
-- Vamos atribuir categorias às 13 perguntas que não têm category_id
UPDATE questions 
SET category_id = CASE 
    WHEN question_order = 1 THEN 1  -- conflict handling
    WHEN question_order = 2 THEN 2  -- relationship priorities
    WHEN question_order = 3 THEN 3  -- affection expression
    WHEN question_order = 4 THEN 4  -- decision-making
    WHEN question_order = 5 THEN 5  -- emotional reactions
    WHEN question_order = 6 THEN 1  -- conflict handling
    WHEN question_order = 7 THEN 2  -- relationship priorities
    WHEN question_order = 8 THEN 3  -- affection expression
    WHEN question_order = 9 THEN 4  -- decision-making
    WHEN question_order = 10 THEN 5 -- emotional reactions
    WHEN question_order = 11 THEN 1 -- conflict handling
    WHEN question_order = 12 THEN 2 -- relationship priorities
    WHEN question_order = 13 THEN 3 -- affection expression
    WHEN question_order = 14 THEN 4 -- decision-making
    WHEN question_order = 15 THEN 5 -- emotional reactions
    WHEN question_order = 16 THEN 1 -- conflict handling
    WHEN question_order = 17 THEN 2 -- relationship priorities
    WHEN question_order = 18 THEN 3 -- affection expression
    ELSE 1 -- fallback
END
WHERE quiz_id = 1 AND category_id IS NULL;

-- Para Quiz 2 (Professional Coach Quiz)
-- Vamos usar categorias relacionadas ao ambiente profissional
UPDATE questions 
SET category_id = CASE 
    WHEN question_order <= 4 THEN 4   -- decision-making
    WHEN question_order <= 8 THEN 1   -- conflict handling
    WHEN question_order <= 12 THEN 2  -- relationship priorities
    WHEN question_order <= 16 THEN 5  -- emotional reactions
    ELSE 3  -- affection expression
END
WHERE quiz_id = 2 AND category_id IS NULL;

-- Para Quiz 3 (Romantic Coach Quiz)
-- Vamos usar categorias relacionadas ao romance
UPDATE questions 
SET category_id = CASE 
    WHEN question_order <= 4 THEN 3   -- affection expression
    WHEN question_order <= 8 THEN 2   -- relationship priorities
    WHEN question_order <= 12 THEN 5  -- emotional reactions
    WHEN question_order <= 16 THEN 1  -- conflict handling
    ELSE 4  -- decision-making
END
WHERE quiz_id = 3 AND category_id IS NULL;

-- Para Quiz 4 (Family Coach Quiz)
-- Vamos usar categorias relacionadas à família
UPDATE questions 
SET category_id = CASE 
    WHEN question_order <= 4 THEN 2   -- relationship priorities
    WHEN question_order <= 8 THEN 5   -- emotional reactions
    WHEN question_order <= 12 THEN 1  -- conflict handling
    WHEN question_order <= 16 THEN 4  -- decision-making
    ELSE 3  -- affection expression
END
WHERE quiz_id = 4 AND category_id IS NULL;

-- Para Quiz 5 (Friendship Coach Quiz)
-- Vamos usar categorias relacionadas à amizade
UPDATE questions 
SET category_id = CASE 
    WHEN question_order <= 4 THEN 1   -- conflict handling
    WHEN question_order <= 8 THEN 4   -- decision-making
    WHEN question_order <= 12 THEN 2  -- relationship priorities
    WHEN question_order <= 16 THEN 3  -- affection expression
    ELSE 5  -- emotional reactions
END
WHERE quiz_id = 5 AND category_id IS NULL;

-- Para Quiz 6 (Personal Growth Quiz)
-- Vamos usar categorias relacionadas ao crescimento pessoal
UPDATE questions 
SET category_id = CASE 
    WHEN question_order <= 4 THEN 5   -- emotional reactions
    WHEN question_order <= 8 THEN 4   -- decision-making
    WHEN question_order <= 12 THEN 1  -- conflict handling
    WHEN question_order <= 16 THEN 2  -- relationship priorities
    ELSE 3  -- affection expression
END
WHERE quiz_id = 6 AND category_id IS NULL;

COMMIT;