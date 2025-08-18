const { Pool } = require('pg');

// Configuração do banco de dados local (simulando Kamatera)
const pool = new Pool({
  host: 'localhost',
  user: 'quiz_user',
  password: 'quiz_password_2024',
  database: 'quiz_app',
  port: 5432,
});

async function fixKamateraIssues() {
  try {
    console.log('🚀 Iniciando correção dos problemas do servidor Kamatera...');
    
    // 1. Corrigir opções em branco na pergunta em inglês
    console.log('\n🔧 1. Corrigindo opções em branco em inglês...');
    await fixBlankEnglishOptions();
    
    // 2. Adicionar traduções para botões de pagamento em português
    console.log('\n🔧 2. Corrigindo botões de pagamento em português...');
    await fixPortuguesePaymentButtons();
    
    // 3. Corrigir problemas em espanhol
    console.log('\n🔧 3. Corrigindo problemas em espanhol...');
    await fixSpanishIssues();
    
    // 4. Verificação final
    console.log('\n🔍 4. Verificação final...');
    await finalVerification();
    
    console.log('\n✅ Todas as correções foram aplicadas com sucesso!');
    
  } catch (error) {
    console.error('❌ Erro durante a correção:', error);
    throw error;
  }
}

async function fixBlankEnglishOptions() {
  // Verificar se há opções em branco ou com problemas
  const blankOptions = await pool.query(`
    SELECT ao.id, ao.question_id, ao.option_text, q.question_text
    FROM answer_options ao
    JOIN questions q ON ao.question_id = q.id
    WHERE q.country = 'en_US' 
    AND (ao.option_text IS NULL OR ao.option_text = '' OR LENGTH(TRIM(ao.option_text)) = 0)
    ORDER BY ao.question_id, ao.id
  `);
  
  if (blankOptions.rows.length > 0) {
    console.log(`   Encontradas ${blankOptions.rows.length} opções em branco em inglês`);
    
    // Definir opções padrão em inglês para diferentes tipos de perguntas
    const defaultEnglishOptions = {
      1: ['Always', 'Often', 'Sometimes', 'Rarely', 'Never'],
      2: ['Strongly agree', 'Agree', 'Neutral', 'Disagree', 'Strongly disagree'],
      3: ['Very important', 'Important', 'Somewhat important', 'Not very important', 'Not important at all'],
      4: ['Always', 'Usually', 'Sometimes', 'Rarely', 'Never']
    };
    
    for (const option of blankOptions.rows) {
      const questionType = option.question_id % 4 + 1; // Determinar tipo baseado no ID
      const options = defaultEnglishOptions[questionType];
      const optionIndex = (option.id - 1) % options.length;
      const newText = options[optionIndex];
      
      await pool.query(
        'UPDATE answer_options SET option_text = $1 WHERE id = $2',
        [newText, option.id]
      );
      
      console.log(`   ✅ Opção ${option.id} atualizada: "${newText}"`);
    }
  } else {
    console.log('   ✅ Nenhuma opção em branco encontrada em inglês');
  }
}

async function fixPortuguesePaymentButtons() {
  // Verificar se as traduções de pagamento existem
  const existingTranslations = await pool.query(`
    SELECT component_name, text_content, country
    FROM layout_locale
    WHERE component_name IN ('payment.button_pay', 'payment.payButton', 'quiz.finish_quiz')
    AND country = 'pt_BR'
    ORDER BY component_name
  `);
  
  console.log(`   Encontradas ${existingTranslations.rows.length} traduções de pagamento em português`);
  
  // Traduções necessárias para botões de pagamento
  const requiredTranslations = [
    { component: 'payment.button_pay', text: 'Pagar', country: 'pt_BR' },
    { component: 'payment.payButton', text: 'Pagar', country: 'pt_BR' },
    { component: 'quiz.finish_quiz', text: 'Finalizar Quiz', country: 'pt_BR' },
    { component: 'payment.processing', text: 'Processando...', country: 'pt_BR' },
    { component: 'payment.processing_wait', text: 'Pagamento sendo processado. Por favor, aguarde...', country: 'pt_BR' },
    { component: 'payment.success_saving', text: 'Pagamento realizado com sucesso! Salvando seus resultados...', country: 'pt_BR' },
    { component: 'payment.failed', text: 'Pagamento falhou', country: 'pt_BR' }
  ];
  
  for (const translation of requiredTranslations) {
    // Verificar se já existe
    const existing = await pool.query(
      'SELECT id FROM layout_locale WHERE component_name = $1 AND country = $2',
      [translation.component, translation.country]
    );
    
    if (existing.rows.length === 0) {
      // Inserir nova tradução
      await pool.query(
        'INSERT INTO layout_locale (component_name, text_content, country) VALUES ($1, $2, $3)',
        [translation.component, translation.text, translation.country]
      );
      console.log(`   ✅ Adicionada tradução: ${translation.component} = "${translation.text}"`);
    } else {
      // Atualizar tradução existente
      await pool.query(
        'UPDATE layout_locale SET text_content = $1 WHERE component_name = $2 AND country = $3',
        [translation.text, translation.component, translation.country]
      );
      console.log(`   ✅ Atualizada tradução: ${translation.component} = "${translation.text}"`);
    }
  }
}

async function fixSpanishIssues() {
  // 1. Corrigir primeira pergunta sem opções em espanhol
  console.log('   Verificando primeira pergunta em espanhol...');
  
  const spanishQuestion1 = await pool.query(`
    SELECT q.id, q.question_text, COUNT(ao.id) as option_count
    FROM questions q
    LEFT JOIN answer_options ao ON q.id = ao.question_id
    WHERE q.country = 'es_ES' AND q.id = (
      SELECT MIN(id) FROM questions WHERE country = 'es_ES'
    )
    GROUP BY q.id, q.question_text
  `);
  
  if (spanishQuestion1.rows.length > 0 && spanishQuestion1.rows[0].option_count === 0) {
    console.log(`   ❌ Primeira pergunta em espanhol sem opções (ID: ${spanishQuestion1.rows[0].id})`);
    
    // Adicionar opções padrão em espanhol
    const spanishOptions = [
      'Siempre',
      'A menudo', 
      'A veces',
      'Raramente',
      'Nunca'
    ];
    
    for (let i = 0; i < spanishOptions.length; i++) {
      await pool.query(
        'INSERT INTO answer_options (question_id, option_text, weight, country) VALUES ($1, $2, $3, $4)',
        [spanishQuestion1.rows[0].id, spanishOptions[i], i + 1, 'es_ES']
      );
      console.log(`   ✅ Adicionada opção em espanhol: "${spanishOptions[i]}"`);
    }
  } else {
    console.log('   ✅ Primeira pergunta em espanhol tem opções');
  }
  
  // 2. Corrigir primeiro botão com texto incorreto
  console.log('   Verificando traduções de botões em espanhol...');
  
  const spanishButtonTranslations = [
    { component: 'quiz.finish_quiz', text: 'Finalizar Quiz', country: 'es_ES' },
    { component: 'payment.button_pay', text: 'Pagar', country: 'es_ES' },
    { component: 'payment.payButton', text: 'Pagar', country: 'es_ES' },
    { component: 'common.next', text: 'Siguiente', country: 'es_ES' },
    { component: 'common.back', text: 'Atrás', country: 'es_ES' }
  ];
  
  for (const translation of spanishButtonTranslations) {
    const existing = await pool.query(
      'SELECT id FROM layout_locale WHERE component_name = $1 AND country = $2',
      [translation.component, translation.country]
    );
    
    if (existing.rows.length === 0) {
      await pool.query(
        'INSERT INTO layout_locale (component_name, text_content, country) VALUES ($1, $2, $3)',
        [translation.component, translation.text, translation.country]
      );
      console.log(`   ✅ Adicionada tradução em espanhol: ${translation.component} = "${translation.text}"`);
    }
  }
}

async function finalVerification() {
  // Verificar total de opções por idioma
  const optionsByLanguage = await pool.query(`
    SELECT q.country, COUNT(ao.*) as total_options
    FROM questions q
    LEFT JOIN answer_options ao ON q.id = ao.question_id
    GROUP BY q.country
    ORDER BY q.country
  `);
  
  console.log('   �� Total de opções por idioma:');
  optionsByLanguage.rows.forEach(row => {
    console.log(`     ${row.country}: ${row.total_options} opções`);
  });
  
  // Verificar traduções de botões
  const buttonTranslations = await pool.query(`
    SELECT country, COUNT(*) as translation_count
    FROM layout_locale
    WHERE component_name IN ('payment.button_pay', 'quiz.finish_quiz', 'common.next')
    GROUP BY country
    ORDER BY country
  `);
  
  console.log('   📊 Traduções de botões por idioma:');
  buttonTranslations.rows.forEach(row => {
    console.log(`     ${row.country}: ${row.translation_count} traduções`);
  });
  
  // Verificar opções em branco
  const blankOptions = await pool.query(`
    SELECT COUNT(*) as blank_count
    FROM answer_options
    WHERE option_text IS NULL OR option_text = '' OR LENGTH(TRIM(option_text)) = 0
  `);
  
  if (blankOptions.rows[0].blank_count > 0) {
    console.log(`   ⚠️ Ainda existem ${blankOptions.rows[0].blank_count} opções em branco`);
  } else {
    console.log('   ✅ Nenhuma opção em branco encontrada');
  }
}

async function main() {
  try {
    await fixKamateraIssues();
  } catch (error) {
    console.error('❌ Erro na execução:', error.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = { fixKamateraIssues };
