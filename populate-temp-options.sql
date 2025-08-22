-- Script para criar opções de resposta temporárias
-- Primeiro, vamos obter os IDs das perguntas criadas e criar as opções

-- Criar opções para todas as perguntas dos quizzes 2-6
-- Usaremos uma abordagem dinâmica com DO block

DO $$
DECLARE
    question_record RECORD;
    quiz_num INTEGER;
    question_num INTEGER;
    locale_name TEXT;
BEGIN
    -- Loop através de todas as perguntas dos quizzes 2-6
    FOR question_record IN 
        SELECT id, quiz_id, question_text, country 
        FROM questions 
        WHERE quiz_id BETWEEN 2 AND 6 
        AND question_text LIKE '🔧%'
    LOOP
        -- Extrair informações da pergunta
        quiz_num := question_record.quiz_id;
        locale_name := question_record.country;
        
        -- Criar 4 opções para cada pergunta
        FOR i IN 1..4 LOOP
            INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country)
            VALUES (
                question_record.id,
                '🔧 Opcao ' || i || ' - Quiz=' || quiz_num || ' - ' || locale_name,
                i,
                CASE 
                    WHEN i = 1 THEN '{"type_a": 3, "type_b": 1, "type_c": 0}'::jsonb
                    WHEN i = 2 THEN '{"type_a": 1, "type_b": 3, "type_c": 0}'::jsonb
                    WHEN i = 3 THEN '{"type_a": 0, "type_b": 1, "type_c": 3}'::jsonb
                    ELSE '{"type_a": 0, "type_b": 0, "type_c": 1}'::jsonb
                END,
                locale_name
            );
        END LOOP;
    END LOOP;
    
    RAISE NOTICE 'Answer options created successfully!';
END $$;

-- Criar conselhos para todos os tipos de personalidade
DO $$
DECLARE
    personality_record RECORD;
    quiz_num INTEGER;
    locale_name TEXT;
    type_name_clean TEXT;
BEGIN
    -- Loop através de todos os tipos de personalidade dos quizzes 2-6
    FOR personality_record IN 
        SELECT id, quiz_id, type_name, type_key, country 
        FROM personality_types 
        WHERE quiz_id BETWEEN 2 AND 6 
        AND type_name LIKE '🔧%'
    LOOP
        -- Extrair informações do tipo de personalidade
        quiz_num := personality_record.quiz_id;
        locale_name := personality_record.country;
        type_name_clean := personality_record.type_key;
        
        -- Criar conselho geral
        INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, country)
        VALUES (
            personality_record.id,
            'general',
            '🔧 Conselho geral para ' || type_name_clean || ' - Quiz=' || quiz_num || ' - ' || locale_name,
            1,
            locale_name
        );
        
        -- Criar conselho de relacionamento
        INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, country)
        VALUES (
            personality_record.id,
            'relationship',
            '🔧 Conselho de relacionamento para ' || type_name_clean || ' - Quiz=' || quiz_num || ' - ' || locale_name,
            2,
            locale_name
        );
    END LOOP;
    
    RAISE NOTICE 'Advice entries created successfully!';
END $$;

-- Verificar o que foi criado
SELECT 'Quizzes' as table_name, COUNT(*) as count FROM quizzes WHERE title LIKE '🔧%'
UNION ALL
SELECT 'Questions', COUNT(*) FROM questions WHERE question_text LIKE '🔧%'
UNION ALL
SELECT 'Answer Options', COUNT(*) FROM answer_options WHERE option_text LIKE '🔧%'
UNION ALL
SELECT 'Personality Types', COUNT(*) FROM personality_types WHERE type_name LIKE '🔧%'
UNION ALL
SELECT 'Advice', COUNT(*) FROM advice WHERE advice_text LIKE '🔧%';