const { pool, dbType } = require('./database');
const { Pool } = require('pg');
const sqlite3 = require('sqlite3').verbose();

// Dados de advice em português
const portugueseAdvice = {
  communicator: {
    personality: [
      "Sua habilidade de comunicação é um dom - use-a para construir pontes, não muros.",
      "Pratique a escuta ativa tanto quanto você pratica falar.",
      "Lembre-se de que nem todos processam informações da mesma forma que você.",
      "Sua transparência pode ser refrescante, mas considere o timing e o contexto.",
      "Use sua voz para elevar outros, não apenas para se expressar."
    ],
    relationship: [
      "Crie espaços seguros onde seu parceiro se sinta confortável para se abrir.",
      "Equilibre compartilhar suas próprias experiências com fazer perguntas sobre as deles.",
      "Reconheça quando seu parceiro precisa de tempo para processar antes de responder.",
      "Sua abertura pode inspirar intimidade, mas respeite os limites dos outros.",
      "Use conflitos como oportunidades para entender melhor, não para vencer argumentos."
    ]
  },
  nurturer: {
    personality: [
      "Seu cuidado pelos outros é uma força, mas não se esqueça de cuidar de si mesmo.",
      "Estabeleça limites saudáveis para evitar o esgotamento emocional.",
      "Reconheça que ajudar demais pode às vezes impedir o crescimento dos outros.",
      "Sua empatia é valiosa - use-a sabiamente e proteja sua energia emocional.",
      "Lembre-se de que você também merece o mesmo cuidado que oferece aos outros."
    ],
    relationship: [
      "Comunique suas próprias necessidades claramente, não apenas as dos outros.",
      "Permita que seu parceiro também cuide de você às vezes.",
      "Evite assumir responsabilidade pelos sentimentos e problemas do seu parceiro.",
      "Valorize parceiros que reconhecem e apreciam sua natureza cuidadosa.",
      "Crie relacionamentos baseados em reciprocidade, não apenas em dar."
    ]
  },
  harmonizer: {
    personality: [
      "Sua busca por harmonia é admirável, mas não evite todos os conflitos necessários.",
      "Aprenda a expressar discordância de forma construtiva e respeitosa.",
      "Reconheça que algum conflito pode levar a soluções melhores e relacionamentos mais fortes.",
      "Sua habilidade de ver múltiplas perspectivas é um superpoder - use-a sabiamente.",
      "Equilibre manter a paz com defender seus próprios valores e necessidades."
    ],
    relationship: [
      "Pratique expressar suas preferências, mesmo quando diferem das do seu parceiro.",
      "Reconheça que relacionamentos saudáveis incluem desacordos ocasionais.",
      "Procure parceiros que valorizem sua perspectiva, não apenas sua flexibilidade.",
      "Use sua habilidade de mediação para resolver conflitos, não para evitá-los.",
      "Crie espaços onde ambos possam expressar necessidades sem medo de conflito."
    ]
  },
  independent: {
    personality: [
      "Sua independência é uma força, mas lembre-se de que conexão não significa perda de liberdade.",
      "Pratique vulnerabilidade em pequenas doses para construir intimidade.",
      "Reconheça que pedir ajuda às vezes pode ser um sinal de força, não fraqueza.",
      "Equilibre seu tempo sozinho com momentos significativos de conexão.",
      "Sua autossuficiência é admirável, mas não deixe que se torne isolamento."
    ],
    relationship: [
      "Comunique suas necessidades de espaço sem fazer seu parceiro se sentir rejeitado.",
      "Pratique compartilhar seus pensamentos e sentimentos regularmente.",
      "Procure parceiros que respeitem sua independência enquanto valorizam a conexão.",
      "Invista em interdependência junto com independência.",
      "Compartilhe sua jornada de crescimento com aqueles mais próximos de você."
    ]
  },
  loyalist: {
    personality: [
      "Certifique-se de que sua lealdade aos outros não se sobreponha à lealdade a si mesmo.",
      "Reconheça que a confiança pode ser reconstruída após pequenas quebras.",
      "Equilibre consistência com espontaneidade e crescimento.",
      "Permita a si mesmo e aos outros espaço para evoluir e mudar.",
      "Sua constância fornece segurança valiosa nos relacionamentos."
    ],
    relationship: [
      "Comunique suas expectativas claramente para evitar decepções.",
      "Pratique o perdão para transgressões menores.",
      "Procure parceiros que valorizem o compromisso tanto quanto você.",
      "Construa confiança através de pequenas ações consistentes ao longo do tempo.",
      "Crie espaço tanto para segurança quanto para aventura em seus relacionamentos."
    ]
  }
};

// Dados de advice em espanhol
const spanishAdvice = {
  communicator: {
    personality: [
      "Tu habilidad de comunicación es un don: úsala para construir puentes, no muros.",
      "Practica la escucha activa tanto como practicas hablar.",
      "Recuerda que no todos procesan la información de la misma manera que tú.",
      "Tu transparencia puede ser refrescante, pero considera el momento y el contexto.",
      "Usa tu voz para elevar a otros, no solo para expresarte."
    ],
    relationship: [
      "Crea espacios seguros donde tu pareja se sienta cómoda abriéndose.",
      "Equilibra compartir tus propias experiencias con hacer preguntas sobre las suyas.",
      "Reconoce cuando tu pareja necesita tiempo para procesar antes de responder.",
      "Tu apertura puede inspirar intimidad, pero respeta los límites de otros.",
      "Usa los conflictos como oportunidades para entender mejor, no para ganar argumentos."
    ]
  },
  nurturer: {
    personality: [
      "Tu cuidado por otros es una fortaleza, pero no olvides cuidarte a ti mismo.",
      "Establece límites saludables para evitar el agotamiento emocional.",
      "Reconoce que ayudar demasiado a veces puede impedir el crecimiento de otros.",
      "Tu empatía es valiosa: úsala sabiamente y protege tu energía emocional.",
      "Recuerda que tú también mereces el mismo cuidado que ofreces a otros."
    ],
    relationship: [
      "Comunica tus propias necesidades claramente, no solo las de otros.",
      "Permite que tu pareja también te cuide a veces.",
      "Evita asumir responsabilidad por los sentimientos y problemas de tu pareja.",
      "Valora parejas que reconocen y aprecian tu naturaleza cuidadosa.",
      "Crea relaciones basadas en reciprocidad, no solo en dar."
    ]
  },
  harmonizer: {
    personality: [
      "Tu búsqueda de armonía es admirable, pero no evites todos los conflictos necesarios.",
      "Aprende a expresar desacuerdo de forma constructiva y respetuosa.",
      "Reconoce que algún conflicto puede llevar a mejores soluciones y relaciones más fuertes.",
      "Tu habilidad para ver múltiples perspectivas es un superpoder: úsala sabiamente.",
      "Equilibra mantener la paz con defender tus propios valores y necesidades."
    ],
    relationship: [
      "Practica expresar tus preferencias, incluso cuando difieran de las de tu pareja.",
      "Reconoce que las relaciones saludables incluyen desacuerdos ocasionales.",
      "Busca parejas que valoren tu perspectiva, no solo tu flexibilidad.",
      "Usa tu habilidad de mediación para resolver conflictos, no para evitarlos.",
      "Crea espacios donde ambos puedan expresar necesidades sin miedo al conflicto."
    ]
  },
  independent: {
    personality: [
      "Tu independencia es una fortaleza, pero recuerda que conexión no significa pérdida de libertad.",
      "Practica vulnerabilidad en pequeñas dosis para construir intimidad.",
      "Reconoce que pedir ayuda a veces puede ser señal de fortaleza, no debilidad.",
      "Equilibra tu tiempo solo con momentos significativos de conexión.",
      "Tu autosuficiencia es admirable, pero no dejes que se convierta en aislamiento."
    ],
    relationship: [
      "Comunica tus necesidades de espacio sin hacer que tu pareja se sienta rechazada.",
      "Practica compartir tus pensamientos y sentimientos regularmente.",
      "Busca parejas que respeten tu independencia mientras valoran la conexión.",
      "Invierte en interdependencia junto con independencia.",
      "Comparte tu jornada de crecimiento con aquellos más cercanos a ti."
    ]
  },
  loyalist: {
    personality: [
      "Asegúrate de que tu lealtad a otros no anule la lealtad a ti mismo.",
      "Reconoce que la confianza puede reconstruirse después de pequeñas rupturas.",
      "Equilibra consistencia con espontaneidad y crecimiento.",
      "Permítete a ti mismo y a otros espacio para evolucionar y cambiar.",
      "Tu constancia proporciona seguridad valiosa en las relaciones."
    ],
    relationship: [
      "Comunica tus expectativas claramente para evitar decepciones.",
      "Practica el perdón para transgresiones menores.",
      "Busca parejas que valoren el compromiso tanto como tú.",
      "Construye confianza a través de pequeñas acciones consistentes a lo largo del tiempo.",
      "Crea espacio tanto para seguridad como para aventura en tus relaciones."
    ]
  }
};

async function addMissingAdvicePostgreSQL() {
  
  try {
    console.log('🔍 Verificando registros existentes...');
    
    // Verificar registros existentes
    const existingAdvice = await pool.query(`
      SELECT DISTINCT pt.country, a.advice_type 
      FROM personality_types pt
      LEFT JOIN advice a ON pt.id = a.personality_type_id
      WHERE pt.country IN ('pt_BR', 'es_ES') AND a.id IS NOT NULL
      ORDER BY pt.country, a.advice_type
    `);
    
    console.log('Registros existentes:');
    existingAdvice.rows.forEach(row => {
      console.log(`- ${row.country}: ${row.advice_type}`);
    });
    
    // Buscar tipos de personalidade
    const personalityTypes = await pool.query(`
      SELECT id, type_key as personality_key 
      FROM personality_types 
      WHERE country = 'pt_BR'
      ORDER BY type_key
    `);
    
    console.log('\n📝 Adicionando advice em português...');
    
    for (const type of personalityTypes.rows) {
      const adviceData = portugueseAdvice[type.personality_key];
      if (!adviceData) {
        console.log(`⚠️  Dados não encontrados para ${type.personality_key}`);
        continue;
      }
      
      // Verificar se já existe advice para este tipo
      const existing = await pool.query(`
        SELECT COUNT(*) as count 
        FROM advice 
        WHERE personality_type_id = $1
      `, [type.id]);
      
      if (existing.rows[0].count > 0) {
        console.log(`✅ Advice já existe para ${type.personality_key} (pt_BR)`);
        continue;
      }
      
      // Adicionar personality advice
      for (let i = 0; i < adviceData.personality.length; i++) {
        await pool.query(`
          INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order)
          VALUES ($1, 'personality', $2, $3)
        `, [type.id, adviceData.personality[i], i + 1]);
      }
      
      // Adicionar relationship advice
      for (let i = 0; i < adviceData.relationship.length; i++) {
        await pool.query(`
          INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order)
          VALUES ($1, 'relationship', $2, $3)
        `, [type.id, adviceData.relationship[i], i + 1]);
      }
      
      console.log(`✅ Advice adicionado para ${type.personality_key} (pt_BR)`);
    }
    
    console.log('\n📝 Adicionando advice em espanhol...');
    
    // Buscar tipos de personalidade em espanhol
    const spanishTypes = await pool.query(`
      SELECT id, type_key as personality_key 
      FROM personality_types 
      WHERE country = 'es_ES'
      ORDER BY type_key
    `);
    
    for (const type of spanishTypes.rows) {
      const adviceData = spanishAdvice[type.personality_key];
      if (!adviceData) {
        console.log(`⚠️  Dados não encontrados para ${type.personality_key}`);
        continue;
      }
      
      // Verificar se já existe advice para este tipo
      const existing = await pool.query(`
        SELECT COUNT(*) as count 
        FROM advice 
        WHERE personality_type_id = $1
      `, [type.id]);
      
      if (existing.rows[0].count > 0) {
        console.log(`✅ Advice já existe para ${type.personality_key} (es_ES)`);
        continue;
      }
      
      // Adicionar personality advice
      for (let i = 0; i < adviceData.personality.length; i++) {
        await pool.query(`
          INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order)
          VALUES ($1, 'personality', $2, $3)
        `, [type.id, adviceData.personality[i], i + 1]);
      }
      
      // Adicionar relationship advice
      for (let i = 0; i < adviceData.relationship.length; i++) {
        await pool.query(`
          INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order)
          VALUES ($1, 'relationship', $2, $3)
        `, [type.id, adviceData.relationship[i], i + 1]);
      }
      
      console.log(`✅ Advice adicionado para ${type.personality_key} (es_ES)`);
    }
    
    // Verificar resultado final
    console.log('\n📊 Verificando resultado final...');
    const finalCount = await pool.query(`
      SELECT 
        pt.country,
        a.advice_type,
        COUNT(a.id) as count 
      FROM personality_types pt
      LEFT JOIN advice a ON pt.id = a.personality_type_id
      WHERE pt.quiz_id = $1 AND a.id IS NOT NULL
      GROUP BY pt.country, a.advice_type 
      ORDER BY pt.country, a.advice_type
    `, [1]);
    
    finalCount.rows.forEach(row => {
      console.log(`${row.country} (${row.advice_type}): ${row.count} registros`);
    });
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function addMissingAdviceSQLite() {
  return new Promise((resolve, reject) => {
    const db = new sqlite3.Database('./quiz.db');
    
    console.log('🔍 Verificando registros existentes (SQLite)...');
    
    db.serialize(() => {
      // Verificar registros existentes
      db.all(`
        SELECT DISTINCT locale, advice_type 
        FROM advice 
        WHERE locale IN ('pt_BR', 'es_ES')
        ORDER BY locale, advice_type
      `, (err, rows) => {
        if (err) {
          console.error('❌ Erro ao verificar registros:', err.message);
          return reject(err);
        }
        
        console.log('Registros existentes:');
        rows.forEach(row => {
          console.log(`- ${row.locale}: ${row.advice_type}`);
        });
        
        // Buscar tipos de personalidade em português
        db.all(`
          SELECT id, personality_key 
          FROM personality_types 
          WHERE locale = 'pt_BR'
          ORDER BY personality_key
        `, (err, ptTypes) => {
          if (err) {
            console.error('❌ Erro ao buscar tipos pt_BR:', err.message);
            return reject(err);
          }
          
          console.log('\n📝 Adicionando advice em português...');
          
          const addPortugueseAdvice = () => {
            let completed = 0;
            const total = ptTypes.length;
            
            if (total === 0) {
              console.log('⚠️  Nenhum tipo de personalidade encontrado em pt_BR');
              addSpanishAdvice();
              return;
            }
            
            ptTypes.forEach(type => {
              const adviceData = portugueseAdvice[type.personality_key];
              if (!adviceData) {
                console.log(`⚠️  Dados não encontrados para ${type.personality_key}`);
                completed++;
                if (completed === total) addSpanishAdvice();
                return;
              }
              
              // Verificar se já existe
              db.get(`
                SELECT COUNT(*) as count 
                FROM advice 
                WHERE personality_type_id = ? AND locale = 'pt_BR'
              `, [type.id], (err, result) => {
                if (err) {
                  console.error(`❌ Erro ao verificar ${type.personality_key}:`, err.message);
                  completed++;
                  if (completed === total) addSpanishAdvice();
                  return;
                }
                
                if (result.count > 0) {
                  console.log(`✅ Advice já existe para ${type.personality_key} (pt_BR)`);
                  completed++;
                  if (completed === total) addSpanishAdvice();
                  return;
                }
                
                // Adicionar advice
                const stmt = db.prepare(`
                  INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, locale)
                  VALUES (?, ?, ?, ?, 'pt_BR')
                `);
                
                // Personality advice
                adviceData.personality.forEach((advice, index) => {
                  stmt.run([type.id, 'personality', advice, index + 1]);
                });
                
                // Relationship advice
                adviceData.relationship.forEach((advice, index) => {
                  stmt.run([type.id, 'relationship', advice, index + 1]);
                });
                
                stmt.finalize();
                console.log(`✅ Advice adicionado para ${type.personality_key} (pt_BR)`);
                
                completed++;
                if (completed === total) addSpanishAdvice();
              });
            });
          };
          
          const addSpanishAdvice = () => {
            // Buscar tipos de personalidade em espanhol
            db.all(`
              SELECT id, personality_key 
              FROM personality_types 
              WHERE locale = 'es_ES'
              ORDER BY personality_key
            `, (err, esTypes) => {
              if (err) {
                console.error('❌ Erro ao buscar tipos es_ES:', err.message);
                return reject(err);
              }
              
              console.log('\n📝 Adicionando advice em espanhol...');
              
              let completed = 0;
              const total = esTypes.length;
              
              if (total === 0) {
                console.log('⚠️  Nenhum tipo de personalidade encontrado em es_ES');
                showFinalResults();
                return;
              }
              
              esTypes.forEach(type => {
                const adviceData = spanishAdvice[type.personality_key];
                if (!adviceData) {
                  console.log(`⚠️  Dados não encontrados para ${type.personality_key}`);
                  completed++;
                  if (completed === total) showFinalResults();
                  return;
                }
                
                // Verificar se já existe
                db.get(`
                  SELECT COUNT(*) as count 
                  FROM advice 
                  WHERE personality_type_id = ? AND locale = 'es_ES'
                `, [type.id], (err, result) => {
                  if (err) {
                    console.error(`❌ Erro ao verificar ${type.personality_key}:`, err.message);
                    completed++;
                    if (completed === total) showFinalResults();
                    return;
                  }
                  
                  if (result.count > 0) {
                    console.log(`✅ Advice já existe para ${type.personality_key} (es_ES)`);
                    completed++;
                    if (completed === total) showFinalResults();
                    return;
                  }
                  
                  // Adicionar advice
                  const stmt = db.prepare(`
                    INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, locale)
                    VALUES (?, ?, ?, ?, 'es_ES')
                  `);
                  
                  // Personality advice
                  adviceData.personality.forEach((advice, index) => {
                    stmt.run([type.id, 'personality', advice, index + 1]);
                  });
                  
                  // Relationship advice
                  adviceData.relationship.forEach((advice, index) => {
                    stmt.run([type.id, 'relationship', advice, index + 1]);
                  });
                  
                  stmt.finalize();
                  console.log(`✅ Advice adicionado para ${type.personality_key} (es_ES)`);
                  
                  completed++;
                  if (completed === total) showFinalResults();
                });
              });
            });
          };
          
          const showFinalResults = () => {
            console.log('\n📊 Verificando resultado final...');
            db.all(`
              SELECT locale, advice_type, COUNT(*) as count 
              FROM advice 
              GROUP BY locale, advice_type 
              ORDER BY locale, advice_type
            `, (err, rows) => {
              if (err) {
                console.error('❌ Erro ao verificar resultado final:', err.message);
                return reject(err);
              }
              
              rows.forEach(row => {
                console.log(`${row.locale} (${row.advice_type}): ${row.count} registros`);
              });
              
              db.close();
              resolve();
            });
          };
          
          addPortugueseAdvice();
        });
      });
    });
  });
}

async function main() {
  console.log('🚀 Iniciando adição de advice em português e espanhol...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await addMissingAdvicePostgreSQL();
    } else {
      console.log('📊 Usando SQLite');
      await addMissingAdviceSQLite();
    }
    
    console.log('\n✅ Processo concluído com sucesso!');
  } catch (error) {
    console.error('❌ Erro durante o processo:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { main };