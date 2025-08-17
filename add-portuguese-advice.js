const { pool, dbType, initializeDatabase } = require('./database.js');

// Dados de advice em português para cada tipo de personalidade
const portugueseAdviceData = {
  'communicator': {
    personalityAdvice: [
      'Você valoriza a comunicação aberta e honesta em relacionamentos. Continue expressando seus sentimentos claramente.',
      'Sua habilidade de articular pensamentos e emoções é um grande trunfo. Use isso para fortalecer conexões.',
      'Pratique a escuta ativa - às vezes ouvir é tão importante quanto falar.',
      'Seja paciente com parceiros que podem precisar de mais tempo para se expressar.',
      'Use sua comunicação para resolver conflitos de forma construtiva, não para vencer discussões.'
    ],
    relationshipAdvice: [
      'Crie espaços seguros para conversas difíceis com seu parceiro.',
      'Estabeleça check-ins regulares para discutir o estado do relacionamento.',
      'Pratique expressar gratidão e apreço verbalmente todos os dias.',
      'Aprenda a comunicar necessidades sem soar como críticas.',
      'Use "eu sinto" em vez de "você sempre" durante discussões.'
    ]
  },
  'nurturer': {
    personalityAdvice: [
      'Sua natureza cuidadosa é um presente. Lembre-se de também cuidar de si mesmo.',
      'Você tem uma habilidade natural para fazer outros se sentirem amados e valorizados.',
      'Estabeleça limites saudáveis para evitar o esgotamento emocional.',
      'Sua empatia é poderosa - use-a para entender, não para assumir responsabilidades dos outros.',
      'Celebre suas próprias conquistas, não apenas as dos outros.'
    ],
    relationshipAdvice: [
      'Comunique suas próprias necessidades claramente - não espere que seu parceiro adivinhe.',
      'Pratique receber cuidado e apoio, não apenas dar.',
      'Estabeleça momentos regulares para atividades que nutrem você.',
      'Aprenda a dizer "não" quando necessário para preservar sua energia.',
      'Incentive a independência do seu parceiro enquanto oferece apoio.'
    ]
  },
  'harmonizer': {
    personalityAdvice: [
      'Sua busca por harmonia cria ambientes pacíficos e acolhedores.',
      'Desenvolva confiança para expressar suas opiniões, mesmo quando diferem dos outros.',
      'Lembre-se que conflitos saudáveis podem fortalecer relacionamentos.',
      'Sua habilidade de ver múltiplas perspectivas é valiosa - use-a sabiamente.',
      'Pratique a assertividade gentil para expressar suas necessidades.'
    ],
    relationshipAdvice: [
      'Aprenda a navegar conflitos de forma construtiva em vez de evitá-los.',
      'Comunique quando algo o incomoda antes que se torne um problema maior.',
      'Estabeleça compromissos que honrem tanto suas necessidades quanto as do parceiro.',
      'Pratique expressar preferências pessoais sem medo de causar tensão.',
      'Crie rituais de conexão que promovam paz e intimidade no relacionamento.'
    ]
  },
  'independent': {
    personalityAdvice: [
      'Sua independência é uma força. Equilibre-a com vulnerabilidade em relacionamentos íntimos.',
      'Você traz uma perspectiva única e valiosa para situações complexas.',
      'Pratique compartilhar seus pensamentos e sentimentos mais profundos.',
      'Sua autoconfiança inspira outros - use-a para encorajar crescimento mútuo.',
      'Lembre-se que pedir ajuda é um sinal de força, não fraqueza.'
    ],
    relationshipAdvice: [
      'Pratique a interdependência - compartilhe responsabilidades e decisões.',
      'Crie espaço para momentos de vulnerabilidade e intimidade emocional.',
      'Comunique suas necessidades de espaço pessoal de forma clara e gentil.',
      'Inclua seu parceiro em seus planos e decisões importantes.',
      'Equilibre tempo sozinho com tempo de qualidade juntos.'
    ]
  },
  'loyalist': {
    personalityAdvice: [
      'Sua lealdade e comprometimento são qualidades admiráveis e raras.',
      'Confie em seus instintos - eles geralmente estão certos sobre pessoas e situações.',
      'Pratique a autocompaixão quando as coisas não saem como planejado.',
      'Sua dedicação inspira confiança e segurança nos outros.',
      'Lembre-se de que é okay questionar e reavaliar situações quando necessário.'
    ],
    relationshipAdvice: [
      'Construa confiança através de ações consistentes e comunicação honesta.',
      'Crie tradições e rituais que fortaleçam o vínculo com seu parceiro.',
      'Pratique expressar preocupações de forma construtiva, não defensiva.',
      'Estabeleça expectativas claras e realistas no relacionamento.',
      'Celebre marcos e conquistas juntos para fortalecer a conexão.'
    ]
  }
};

async function addPortugueseAdvice() {
  try {
    console.log('🇧🇷 Adicionando advice em português...');
    
    // Inicializar banco de dados
    await initializeDatabase();
    
    if (dbType === 'postgresql') {
      // Buscar tipos de personalidade em português
      const ptTypesResult = await pool.query(
        'SELECT id, type_key, type_name FROM personality_types WHERE quiz_id = $1 AND country = $2',
        [1, 'pt_BR']
      );
      
      if (ptTypesResult.rows.length === 0) {
        console.log('❌ Nenhum tipo de personalidade em português encontrado!');
        console.log('Execute primeiro o script add-portuguese-personality-types.js');
        return;
      }
      
      console.log(`Encontrados ${ptTypesResult.rows.length} tipos de personalidade em português`);
      
      for (const type of ptTypesResult.rows) {
        console.log(`\n📝 Processando ${type.type_name} (${type.type_key})...`);
        
        // Verificar se já existe advice para este tipo
        const existingAdvice = await pool.query(
          'SELECT COUNT(*) as count FROM advice WHERE personality_type_id = $1',
          [type.id]
        );
        
        if (existingAdvice.rows[0].count > 0) {
          console.log(`  ⚠️  Já existe ${existingAdvice.rows[0].count} advice(s) para este tipo. Pulando...`);
          continue;
        }
        
        const adviceData = portugueseAdviceData[type.type_key];
        if (!adviceData) {
          console.log(`  ❌ Dados de advice não encontrados para ${type.type_key}`);
          continue;
        }
        
        // Adicionar personality advice
        for (let i = 0; i < adviceData.personalityAdvice.length; i++) {
          await pool.query(
            'INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, country) VALUES ($1, $2, $3, $4, $5)',
            [type.id, 'personality', adviceData.personalityAdvice[i], i + 1, 'pt_BR']
          );
        }
        
        // Adicionar relationship advice
        for (let i = 0; i < adviceData.relationshipAdvice.length; i++) {
          await pool.query(
            'INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, country) VALUES ($1, $2, $3, $4, $5)',
            [type.id, 'relationship', adviceData.relationshipAdvice[i], i + 1, 'pt_BR']
          );
        }
        
        console.log(`  ✅ Adicionados ${adviceData.personalityAdvice.length} personality advice e ${adviceData.relationshipAdvice.length} relationship advice`);
      }
      
    } else {
      // SQLite version
      console.log('Implementando versão SQLite...');
      
      await new Promise((resolve, reject) => {
        pool.all(
          'SELECT id, type_key, type_name FROM personality_types WHERE quiz_id = ? AND country = ?',
          [1, 'pt_BR'],
          async (err, rows) => {
            if (err) {
              reject(err);
              return;
            }
            
            if (rows.length === 0) {
              console.log('❌ Nenhum tipo de personalidade em português encontrado!');
              resolve();
              return;
            }
            
            console.log(`Encontrados ${rows.length} tipos de personalidade em português`);
            
            for (const type of rows) {
              console.log(`\n📝 Processando ${type.type_name} (${type.type_key})...`);
              
              const adviceData = portugueseAdviceData[type.type_key];
              if (!adviceData) {
                console.log(`  ❌ Dados de advice não encontrados para ${type.type_key}`);
                continue;
              }
              
              // Adicionar personality advice
              for (let i = 0; i < adviceData.personalityAdvice.length; i++) {
                await new Promise((resolveInsert, rejectInsert) => {
                  pool.run(
                    'INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, country) VALUES (?, ?, ?, ?, ?)',
                    [type.id, 'personality', adviceData.personalityAdvice[i], i + 1, 'pt_BR'],
                    (err) => {
                      if (err) rejectInsert(err);
                      else resolveInsert();
                    }
                  );
                });
              }
              
              // Adicionar relationship advice
              for (let i = 0; i < adviceData.relationshipAdvice.length; i++) {
                await new Promise((resolveInsert, rejectInsert) => {
                  pool.run(
                    'INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, country) VALUES (?, ?, ?, ?, ?)',
                    [type.id, 'relationship', adviceData.relationshipAdvice[i], i + 1, 'pt_BR'],
                    (err) => {
                      if (err) rejectInsert(err);
                      else resolveInsert();
                    }
                  );
                });
              }
              
              console.log(`  ✅ Adicionados ${adviceData.personalityAdvice.length} personality advice e ${adviceData.relationshipAdvice.length} relationship advice`);
            }
            
            resolve();
          }
        );
      });
    }
    
    console.log('\n🎉 Advice em português adicionado com sucesso!');
    
  } catch (error) {
    console.error('❌ Erro ao adicionar advice em português:', error);
  } finally {
    if (dbType === 'postgresql') {
      await pool.end();
    } else {
      pool.close();
    }
  }
}

addPortugueseAdvice();