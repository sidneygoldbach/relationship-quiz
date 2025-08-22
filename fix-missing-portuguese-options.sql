-- Adicionar opções para pergunta 135: "Como você normalmente lida com conflitos em relacionamentos?"
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight) VALUES
(135, 'Prefiro abordar questões imediatamente e diretamente', 0, '{"independent": 1, "communicator": 3}'),
(135, 'Preciso de tempo para processar antes de discutir', 1, '{"loyalist": 1, "independent": 3}'),
(135, 'Tento encontrar um compromisso que funcione para todos', 2, '{"nurturer": 1, "harmonizer": 3}'),
(135, 'Às vezes evito confrontos para manter a paz', 3, '{"nurturer": 2, "harmonizer": 2}');

-- Adicionar opções para pergunta 137: "Como você expressa afeto ao seu parceiro?"
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight) VALUES
(137, 'Através de palavras de afirmação e elogios', 0, '{"communicator": 3, "nurturer": 1}'),
(137, 'Através de atos de serviço e ajuda prática', 1, '{"loyalist": 3, "nurturer": 2}'),
(137, 'Através de toque físico e proximidade', 2, '{"harmonizer": 3, "nurturer": 2}'),
(137, 'Através de presentes e gestos especiais', 3, '{"independent": 2, "harmonizer": 2}');

-- Adicionar opções para pergunta 138: "Ao tomar decisões importantes com um parceiro, você prefere:"
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight) VALUES
(138, 'Discutir todas as opções em detalhes juntos', 0, '{"communicator": 3, "harmonizer": 1}'),
(138, 'Confiar na intuição e sentimentos mútuos', 1, '{"nurturer": 3, "harmonizer": 2}'),
(138, 'Analisar os prós e contras logicamente', 2, '{"independent": 3, "loyalist": 1}'),
(138, 'Seguir o que funcionou no passado', 3, '{"loyalist": 3, "independent": 1}');

-- Adicionar opções para pergunta 139: "Como você reage quando se sente emocionalmente ferido por alguém próximo?"
INSERT INTO answer_options (question_id, option_text, option_order, personality_weight) VALUES
(139, 'Expresso meus sentimentos imediatamente', 0, '{"communicator": 3, "independent": 2}'),
(139, 'Preciso de tempo sozinho para processar', 1, '{"independent": 3, "loyalist": 1}'),
(139, 'Busco conforto e apoio de outros', 2, '{"nurturer": 3, "harmonizer": 2}'),
(139, 'Tento entender a perspectiva da outra pessoa', 3, '{"harmonizer": 3, "nurturer": 1}');