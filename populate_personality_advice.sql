-- Script para popular a tabela personality_advice
-- Criando conselhos genéricos para todos os tipos de personalidade

BEGIN;

-- Conselhos para tipos de personalidade do Quiz 1 (Relationship Personality Quiz)
INSERT INTO personality_advice (personality_type_id, advice_type, advice_text, advice_order)
SELECT 
    pt.id,
    'personality',
    CASE 
        WHEN pt.type_name LIKE '%Communicator%' OR pt.type_name LIKE '%Comunicador%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'You excel at expressing yourself clearly and listening actively. Use these skills to build deeper connections with others.'
                WHEN 'pt_BR' THEN 'Você se destaca em se expressar claramente e ouvir ativamente. Use essas habilidades para construir conexões mais profundas com outros.'
                WHEN 'es_ES' THEN 'Sobresales expresándote claramente y escuchando activamente. Usa estas habilidades para construir conexiones más profundas con otros.'
                ELSE 'You excel at expressing yourself clearly and listening actively. Use these skills to build deeper connections with others.'
            END
        WHEN pt.type_name LIKE '%Nurturer%' OR pt.type_name LIKE '%Cuidador%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'Your caring nature is a gift. Remember to also nurture yourself while supporting others in their growth.'
                WHEN 'pt_BR' THEN 'Sua natureza cuidadosa é um presente. Lembre-se de também cuidar de si mesmo enquanto apoia outros em seu crescimento.'
                WHEN 'es_ES' THEN 'Tu naturaleza cariñosa es un regalo. Recuerda también cuidarte a ti mismo mientras apoyas a otros en su crecimiento.'
                ELSE 'Your caring nature is a gift. Remember to also nurture yourself while supporting others in their growth.'
            END
        WHEN pt.type_name LIKE '%Harmonizer%' OR pt.type_name LIKE '%Harmonizador%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'You bring peace and balance to relationships. Your ability to see all sides helps resolve conflicts effectively.'
                WHEN 'pt_BR' THEN 'Você traz paz e equilíbrio aos relacionamentos. Sua capacidade de ver todos os lados ajuda a resolver conflitos efetivamente.'
                WHEN 'es_ES' THEN 'Traes paz y equilibrio a las relaciones. Tu capacidad de ver todos los lados ayuda a resolver conflictos efectivamente.'
                ELSE 'You bring peace and balance to relationships. Your ability to see all sides helps resolve conflicts effectively.'
            END
        WHEN pt.type_name LIKE '%Independent%' OR pt.type_name LIKE '%Independente%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'Your self-reliance is admirable. Balance your independence with openness to support and connection from others.'
                WHEN 'pt_BR' THEN 'Sua autossuficiência é admirável. Equilibre sua independência com abertura ao apoio e conexão de outros.'
                WHEN 'es_ES' THEN 'Tu autosuficiencia es admirable. Equilibra tu independencia con apertura al apoyo y conexión de otros.'
                ELSE 'Your self-reliance is admirable. Balance your independence with openness to support and connection from others.'
            END
        WHEN pt.type_name LIKE '%Loyalist%' OR pt.type_name LIKE '%Leal%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'Your loyalty and commitment create strong, lasting bonds. Trust in your ability to build meaningful relationships.'
                WHEN 'pt_BR' THEN 'Sua lealdade e compromisso criam vínculos fortes e duradouros. Confie em sua capacidade de construir relacionamentos significativos.'
                WHEN 'es_ES' THEN 'Tu lealtad y compromiso crean vínculos fuertes y duraderos. Confía en tu capacidad de construir relaciones significativas.'
                ELSE 'Your loyalty and commitment create strong, lasting bonds. Trust in your ability to build meaningful relationships.'
            END
        ELSE 
            CASE pt.country
                WHEN 'en_US' THEN 'Embrace your unique qualities and use them to build authentic connections with others.'
                WHEN 'pt_BR' THEN 'Abrace suas qualidades únicas e use-as para construir conexões autênticas com outros.'
                WHEN 'es_ES' THEN 'Abraza tus cualidades únicas y úsalas para construir conexiones auténticas con otros.'
                WHEN 'fr_FR' THEN 'Embrassez vos qualités uniques et utilisez-les pour construire des connexions authentiques avec les autres.'
                ELSE 'Embrace your unique qualities and use them to build authentic connections with others.'
            END
    END,
    1
FROM personality_types pt
WHERE pt.quiz_id = 1;

-- Conselhos de relacionamento para tipos de personalidade do Quiz 1
INSERT INTO personality_advice (personality_type_id, advice_type, advice_text, advice_order)
SELECT 
    pt.id,
    'relationship',
    CASE 
        WHEN pt.type_name LIKE '%Communicator%' OR pt.type_name LIKE '%Comunicador%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'In relationships, practice patience and give others time to process. Not everyone communicates at your pace.'
                WHEN 'pt_BR' THEN 'Nos relacionamentos, pratique paciência e dê tempo aos outros para processar. Nem todos se comunicam no seu ritmo.'
                WHEN 'es_ES' THEN 'En las relaciones, practica la paciencia y da tiempo a otros para procesar. No todos se comunican a tu ritmo.'
                ELSE 'In relationships, practice patience and give others time to process. Not everyone communicates at your pace.'
            END
        WHEN pt.type_name LIKE '%Nurturer%' OR pt.type_name LIKE '%Cuidador%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'Set healthy boundaries in relationships. Your giving nature is beautiful, but remember your needs matter too.'
                WHEN 'pt_BR' THEN 'Estabeleça limites saudáveis nos relacionamentos. Sua natureza generosa é linda, mas lembre-se que suas necessidades também importam.'
                WHEN 'es_ES' THEN 'Establece límites saludables en las relaciones. Tu naturaleza generosa es hermosa, pero recuerda que tus necesidades también importan.'
                ELSE 'Set healthy boundaries in relationships. Your giving nature is beautiful, but remember your needs matter too.'
            END
        WHEN pt.type_name LIKE '%Harmonizer%' OR pt.type_name LIKE '%Harmonizador%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'While avoiding conflict is natural for you, sometimes addressing issues directly strengthens relationships.'
                WHEN 'pt_BR' THEN 'Embora evitar conflitos seja natural para você, às vezes abordar questões diretamente fortalece os relacionamentos.'
                WHEN 'es_ES' THEN 'Aunque evitar conflictos es natural para ti, a veces abordar problemas directamente fortalece las relaciones.'
                ELSE 'While avoiding conflict is natural for you, sometimes addressing issues directly strengthens relationships.'
            END
        WHEN pt.type_name LIKE '%Independent%' OR pt.type_name LIKE '%Independente%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'Allow yourself to be vulnerable in close relationships. Interdependence can coexist with your independence.'
                WHEN 'pt_BR' THEN 'Permita-se ser vulnerável em relacionamentos próximos. A interdependência pode coexistir com sua independência.'
                WHEN 'es_ES' THEN 'Permítete ser vulnerable en relaciones cercanas. La interdependencia puede coexistir con tu independencia.'
                ELSE 'Allow yourself to be vulnerable in close relationships. Interdependence can coexist with your independence.'
            END
        WHEN pt.type_name LIKE '%Loyalist%' OR pt.type_name LIKE '%Leal%' THEN 
            CASE pt.country
                WHEN 'en_US' THEN 'Your loyalty is precious. Ensure it is reciprocated and that you are valued for who you are, not just what you give.'
                WHEN 'pt_BR' THEN 'Sua lealdade é preciosa. Certifique-se de que seja recíproca e que você seja valorizado por quem é, não apenas pelo que dá.'
                WHEN 'es_ES' THEN 'Tu lealtad es preciosa. Asegúrate de que sea recíproca y que seas valorado por quien eres, no solo por lo que das.'
                ELSE 'Your loyalty is precious. Ensure it is reciprocated and that you are valued for who you are, not just what you give.'
            END
        ELSE 
            CASE pt.country
                WHEN 'en_US' THEN 'Focus on building relationships based on mutual respect, understanding, and shared values.'
                WHEN 'pt_BR' THEN 'Concentre-se em construir relacionamentos baseados em respeito mútuo, compreensão e valores compartilhados.'
                WHEN 'es_ES' THEN 'Enfócate en construir relaciones basadas en respeto mutuo, comprensión y valores compartidos.'
                WHEN 'fr_FR' THEN 'Concentrez-vous sur la construction de relations basées sur le respect mutuel, la compréhension et les valeurs partagées.'
                ELSE 'Focus on building relationships based on mutual respect, understanding, and shared values.'
            END
    END,
    2
FROM personality_types pt
WHERE pt.quiz_id = 1;

-- Conselhos genéricos para quizzes de coach (2-6)
INSERT INTO personality_advice (personality_type_id, advice_type, advice_text, advice_order)
SELECT 
    pt.id,
    'coaching',
    CASE pt.country
        WHEN 'en_US' THEN 'Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.'
        WHEN 'pt_BR' THEN 'Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.'
        WHEN 'es_ES' THEN 'Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.'
        WHEN 'fr_FR' THEN 'Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.'
        ELSE 'Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.'
    END,
    1
FROM personality_types pt
WHERE pt.quiz_id IN (2, 3, 4, 5, 6);

-- Conselhos de desenvolvimento para quizzes de coach
INSERT INTO personality_advice (personality_type_id, advice_type, advice_text, advice_order)
SELECT 
    pt.id,
    'development',
    CASE pt.country
        WHEN 'en_US' THEN 'Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.'
        WHEN 'pt_BR' THEN 'Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.'
        WHEN 'es_ES' THEN 'Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.'
        WHEN 'fr_FR' THEN 'Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.'
        ELSE 'Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.'
    END,
    2
FROM personality_types pt
WHERE pt.quiz_id IN (2, 3, 4, 5, 6);

COMMIT;