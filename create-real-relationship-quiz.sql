-- Criar perguntas verdadeiras de relacionamento para o Quiz 1

-- Inserir perguntas em inglês
INSERT INTO questions (quiz_id, question_text, question_order, country, category_id) VALUES
(1, 'How do you typically handle conflicts in relationships?', 1, 'en_US', 1),
(1, 'What is most important to you in a relationship?', 2, 'en_US', 2),
(1, 'How do you express affection to your partner?', 3, 'en_US', 3),
(1, 'When making important decisions with a partner, you prefer to:', 4, 'en_US', 4),
(1, 'How do you react when you feel emotionally hurt by someone close?', 5, 'en_US', 5);

-- Inserir perguntas em português
INSERT INTO questions (quiz_id, question_text, question_order, country, category_id) VALUES
(1, 'Como você normalmente lida com conflitos em relacionamentos?', 1, 'pt_BR', 1),
(1, 'O que é mais importante para você em um relacionamento?', 2, 'pt_BR', 2),
(1, 'Como você expressa afeto ao seu parceiro?', 3, 'pt_BR', 3),
(1, 'Ao tomar decisões importantes com um parceiro, você prefere:', 4, 'pt_BR', 4),
(1, 'Como você reage quando se sente emocionalmente ferido por alguém próximo?', 5, 'pt_BR', 5);

-- Inserir perguntas em espanhol
INSERT INTO questions (quiz_id, question_text, question_order, country, category_id) VALUES
(1, '¿Cómo manejas los conflictos en tu relación?', 1, 'es_ES', 1),
(1, '¿Qué es lo más importante para ti en una relación?', 2, 'es_ES', 2),
(1, '¿Cómo expresas tu amor?', 3, 'es_ES', 3),
(1, 'Al tomar decisiones importantes con tu pareja, prefieres:', 4, 'es_ES', 4),
(1, '¿Cómo reaccionas cuando te sientes emocionalmente herido?', 5, 'es_ES', 5);

-- Inserir perguntas em francês
INSERT INTO questions (quiz_id, question_text, question_order, country, category_id) VALUES
(1, 'Comment gérez-vous généralement les conflits dans les relations?', 1, 'fr_FR', 1),
(1, 'Qu''est-ce qui est le plus important pour vous dans une relation?', 2, 'fr_FR', 2),
(1, 'Comment exprimez-vous l''affection à votre partenaire?', 3, 'fr_FR', 3),
(1, 'Lors de prises de décisions importantes avec un partenaire, vous préférez:', 4, 'fr_FR', 4),
(1, 'Comment réagissez-vous quand vous vous sentez blessé émotionnellement?', 5, 'fr_FR', 5);