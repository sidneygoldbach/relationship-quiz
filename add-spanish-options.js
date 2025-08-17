const { pool, dbType } = require('./database');

async function addSpanishOptionsPostgreSQL() {
  try {
    console.log('🇪🇸 Adicionando opções em espanhol...');
    
    // Verificar se existem perguntas em espanhol
    console.log('\n🔍 Verificando perguntas em espanhol...');
    const spanishQuestions = await pool.query(`
      SELECT id, question_text, country
      FROM questions
      WHERE country = 'es_ES'
      ORDER BY id
    `);
    
    console.log(`Encontradas ${spanishQuestions.rows.length} perguntas em espanhol`);
    
    if (spanishQuestions.rows.length === 0) {
      console.log('⚠️ Não há perguntas em espanhol no banco de dados');
      return;
    }
    
    // Verificar se já existem opções em espanhol
    const existingSpanishOptions = await pool.query(`
      SELECT COUNT(*) as count
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE q.country = 'es_ES'
    `);
    
    console.log(`Opções existentes em espanhol: ${existingSpanishOptions.rows[0].count}`);
    
    if (existingSpanishOptions.rows[0].count > 0) {
      console.log('✅ Já existem opções em espanhol');
      return;
    }
    
    // Mapear opções de inglês para espanhol baseado na estrutura das perguntas
    console.log('\n🔄 Criando opções em espanhol baseadas nas opções em inglês...');
    
    // Traduções básicas para as opções mais comuns
    const translations = {
      // Pergunta 1 - Como você lida com conflitos?
      'I prefer to address issues immediately and directly.': 'Prefiero abordar los problemas inmediatamente y directamente.',
      'I need time to process before discussing the problem.': 'Necesito tiempo para procesar antes de discutir el problema.',
      'I try to find a compromise that works for everyone.': 'Trato de encontrar un compromiso que funcione para todos.',
      'I sometimes avoid confrontation to keep the peace.': 'A veces evito la confrontación para mantener la paz.',
      'I focus on understanding the root cause first.': 'Me enfoco en entender la causa raíz primero.',
      
      // Pergunta 2 - O que é mais importante em um relacionamento?
      'Open and honest communication.': 'Comunicación abierta y honesta.',
      'Trust and loyalty.': 'Confianza y lealtad.',
      'Shared values and goals.': 'Valores y objetivos compartidos.',
      'Growth and shared experiences.': 'Crecimiento y experiencias compartidas.',
      'Physical and emotional intimacy.': 'Intimidad física y emocional.',
      
      // Pergunta 3 - Como você expressa amor?
      'Through words of affirmation and compliments.': 'A través de palabras de afirmación y cumplidos.',
      'Through physical touch and closeness.': 'A través del contacto físico y la cercanía.',
      'Through acts of service and helping.': 'A través de actos de servicio y ayuda.',
      'Through quality time together.': 'A través de tiempo de calidad juntos.',
      'Through giving gifts and surprises.': 'A través de dar regalos y sorpresas.',
      'Through shared activities and adventures.': 'A través de actividades compartidas y aventuras.',
      'Through deep conversations and emotional connection.': 'A través de conversaciones profundas y conexión emocional.',
      'Through supporting their dreams and goals.': 'A través de apoyar sus sueños y objetivos.',
      
      // Pergunta 4 - Como você toma decisões importantes?
      'I analyze all options carefully before deciding.': 'Analizo todas las opciones cuidadosamente antes de decidir.',
      'I trust my intuition and gut feelings.': 'Confío en mi intuición y sentimientos viscerales.',
      'I seek advice from trusted friends or family.': 'Busco consejo de amigos o familiares de confianza.',
      'I consider my partner\'s needs first.': 'Considero las necesidades de mi pareja primero.',
      'I make quick decisions and adapt as needed.': 'Tomo decisiones rápidas y me adapto según sea necesario.',
      'I research extensively before choosing.': 'Investigo extensivamente antes de elegir.',
      
      // Pergunta 5 - Como você lida com o estresse?
      'I try to understand their perspective before reacting.': 'Trato de entender su perspectiva antes de reaccionar.',
      'I need space to cool down first.': 'Necesito espacio para calmarme primero.',
      'I prefer to talk it out immediately.': 'Prefiero hablarlo inmediatamente.',
      'I look for practical solutions together.': 'Busco soluciones prácticas juntos.',
      'I try to find humor in the situation.': 'Trato de encontrar humor en la situación.',
      'I focus on what we can control.': 'Me enfoco en lo que podemos controlar.',
      'I seek support from others.': 'Busco apoyo de otros.',
      
      // Opções genéricas
      'Be flexible and go with the flow.': 'Ser flexible y seguir la corriente.',
      'Take charge and make decisions confidently.': 'Tomar el control y tomar decisiones con confianza.',
      'Consider my partner\'s needs first.': 'Considerar las necesidades de mi pareja primero.',
      'Discuss all options thoroughly before deciding together.': 'Discutir todas las opciones a fondo antes de decidir juntos.'
    };
    
    // Para cada pergunta em espanhol, criar opções baseadas na pergunta equivalente em inglês
    for (const spanishQ of spanishQuestions.rows) {
      // Encontrar pergunta equivalente em inglês (assumindo que a ordem é a mesma)
      const questionNumber = spanishQ.id - 14; // Ajustar baseado na estrutura
      
      const englishOptions = await pool.query(`
        SELECT option_text, option_order
        FROM answer_options ao
        JOIN questions q ON ao.question_id = q.id
        WHERE q.country = 'en_US' AND q.id = $1
        ORDER BY ao.option_order
      `, [questionNumber]);
      
      console.log(`\n📝 Pergunta ${spanishQ.id} (es_ES): "${spanishQ.question_text}"`);
      console.log(`   Baseada na pergunta ${questionNumber} (en_US)`);
      console.log(`   Opções em inglês encontradas: ${englishOptions.rows.length}`);
      
      // Criar opções em espanhol
      for (let i = 0; i < englishOptions.rows.length; i++) {
        const englishText = englishOptions.rows[i].option_text;
        let spanishText = translations[englishText];
        
        // Se não tiver tradução específica, usar uma tradução genérica
        if (!spanishText) {
          spanishText = `Opción ${i + 1} en español`; // Placeholder
          console.log(`⚠️ Tradução não encontrada para: "${englishText}"`);
        }
        
        // Inserir opção em espanhol
        await pool.query(`
          INSERT INTO answer_options (question_id, option_text, option_order, country)
          VALUES ($1, $2, $3, $4)
        `, [spanishQ.id, spanishText, i, 'es_ES']);
        
        console.log(`   ✅ Adicionada: "${spanishText}"`);
      }
    }
    
    // Verificar resultado final
    console.log('\n📊 Verificando resultado final...');
    const finalCheck = await pool.query(`
      SELECT q.country, COUNT(ao.*) as total_options
      FROM questions q
      LEFT JOIN answer_options ao ON q.id = ao.question_id
      GROUP BY q.country
      ORDER BY q.country
    `);
    
    finalCheck.rows.forEach(row => {
      console.log(`  ${row.country}: ${row.total_options} opções`);
    });
    
    // Mostrar estatísticas por pergunta em espanhol
    console.log('\n📊 Opções por pergunta em espanhol:');
    const spanishStats = await pool.query(`
      SELECT ao.question_id, COUNT(*) as total_options
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE q.country = 'es_ES'
      GROUP BY ao.question_id
      ORDER BY ao.question_id
    `);
    
    spanishStats.rows.forEach(row => {
      console.log(`  Pergunta ${row.question_id} (es_ES): ${row.total_options} opções`);
    });
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function main() {
  console.log('🚀 Iniciando adição de opções em espanhol...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await addSpanishOptionsPostgreSQL();
    } else {
      console.log('📊 Usando SQLite - não implementado');
    }
    
    console.log('\n✅ Adição concluída!');
  } catch (error) {
    console.error('❌ Erro durante a adição:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { main };