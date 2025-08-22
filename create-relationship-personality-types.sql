-- Criar tipos de personalidade para o Quiz 1 (Relationship Personality Quiz)

-- Tipos de personalidade baseados em estilos de relacionamento
INSERT INTO personality_types (quiz_id, type_name, type_key, description, country) VALUES
-- English
(1, 'The Communicator', 'communicator', 'You value open and honest communication above all else. You believe that talking through problems and expressing feelings clearly is the foundation of any strong relationship.', 'en_US'),
(1, 'The Nurturer', 'nurturer', 'You are naturally caring and supportive. You show love through acts of service, physical affection, and by always being there for your partner when they need you most.', 'en_US'),
(1, 'The Independent', 'independent', 'You value personal space and autonomy in relationships. You believe that two whole individuals make a stronger partnership than two people who lose themselves in each other.', 'en_US'),
(1, 'The Harmonizer', 'harmonizer', 'You prioritize peace and balance in your relationships. You are skilled at finding compromises and creating an atmosphere where both partners feel heard and valued.', 'en_US'),
(1, 'The Loyalist', 'loyalist', 'Trust and commitment are your core values. Once you commit to someone, you are incredibly dedicated and expect the same level of loyalty and reliability in return.', 'en_US'),

-- Portuguese
(1, 'O Comunicador', 'communicator', 'Você valoriza a comunicação aberta e honesta acima de tudo. Acredita que conversar sobre problemas e expressar sentimentos claramente é a base de qualquer relacionamento forte.', 'pt_BR'),
(1, 'O Cuidador', 'nurturer', 'Você é naturalmente carinhoso e solidário. Demonstra amor através de atos de serviço, carinho físico e estando sempre presente quando seu parceiro mais precisa.', 'pt_BR'),
(1, 'O Independente', 'independent', 'Você valoriza espaço pessoal e autonomia nos relacionamentos. Acredita que dois indivíduos completos formam uma parceria mais forte do que duas pessoas que se perdem uma na outra.', 'pt_BR'),
(1, 'O Harmonizador', 'harmonizer', 'Você prioriza paz e equilíbrio em seus relacionamentos. É hábil em encontrar compromissos e criar uma atmosfera onde ambos os parceiros se sentem ouvidos e valorizados.', 'pt_BR'),
(1, 'O Leal', 'loyalist', 'Confiança e comprometimento são seus valores centrais. Uma vez que se compromete com alguém, você é incrivelmente dedicado e espera o mesmo nível de lealdade e confiabilidade em troca.', 'pt_BR'),

-- Spanish
(1, 'El Comunicador', 'communicator', 'Valoras la comunicación abierta y honesta por encima de todo. Crees que hablar sobre los problemas y expresar los sentimientos claramente es la base de cualquier relación sólida.', 'es_ES'),
(1, 'El Cuidador', 'nurturer', 'Eres naturalmente cariñoso y solidario. Muestras amor a través de actos de servicio, afecto físico y estando siempre ahí para tu pareja cuando más te necesita.', 'es_ES'),
(1, 'El Independiente', 'independent', 'Valoras el espacio personal y la autonomía en las relaciones. Crees que dos individuos completos forman una asociación más fuerte que dos personas que se pierden el uno en el otro.', 'es_ES'),
(1, 'El Armonizador', 'harmonizer', 'Priorizas la paz y el equilibrio en tus relaciones. Eres hábil encontrando compromisos y creando una atmósfera donde ambos compañeros se sienten escuchados y valorados.', 'es_ES'),
(1, 'El Leal', 'loyalist', 'La confianza y el compromiso son tus valores centrales. Una vez que te comprometes con alguien, eres increíblemente dedicado y esperas el mismo nivel de lealtad y confiabilidad a cambio.', 'es_ES'),

-- French
(1, 'Le Communicateur', 'communicator', 'Vous valorisez la communication ouverte et honnête par-dessus tout. Vous croyez que parler des problèmes et exprimer clairement les sentiments est la base de toute relation solide.', 'fr_FR'),
(1, 'Le Bienveillant', 'nurturer', 'Vous êtes naturellement attentionné et solidaire. Vous montrez votre amour par des actes de service, de l''affection physique et en étant toujours là pour votre partenaire quand il en a le plus besoin.', 'fr_FR'),
(1, 'L''Indépendant', 'independent', 'Vous valorisez l''espace personnel et l''autonomie dans les relations. Vous croyez que deux individus complets forment un partenariat plus fort que deux personnes qui se perdent l''une dans l''autre.', 'fr_FR'),
(1, 'L''Harmonisateur', 'harmonizer', 'Vous priorisez la paix et l''équilibre dans vos relations. Vous êtes habile à trouver des compromis et à créer une atmosphère où les deux partenaires se sentent entendus et valorisés.', 'fr_FR'),
(1, 'Le Loyal', 'loyalist', 'La confiance et l''engagement sont vos valeurs centrales. Une fois que vous vous engagez envers quelqu''un, vous êtes incroyablement dévoué et attendez le même niveau de loyauté et de fiabilité en retour.', 'fr_FR');