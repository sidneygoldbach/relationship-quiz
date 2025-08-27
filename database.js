const fs = require('fs');
require('dotenv').config();

let pool;
let dbType = 'sqlite'; // Default to SQLite

// Check if PostgreSQL is available and configured
if (process.env.DB_HOST && process.env.DB_USER && process.env.DB_PASSWORD !== undefined) {
    try {
        const { Pool } = require('pg');
        pool = new Pool({
            host: process.env.DB_HOST,
            port: process.env.DB_PORT || 5432,
            database: process.env.DB_NAME || 'quiz_app',
            user: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            max: 20,
            idleTimeoutMillis: 30000,
            connectionTimeoutMillis: 2000,
        });
        dbType = 'postgresql';
        console.log('📊 Using PostgreSQL database');
    } catch (error) {
        console.log('⚠️  PostgreSQL not available, falling back to SQLite');
        const sqlite3 = require('sqlite3').verbose();
        const path = require('path');
        const dbPath = path.join(__dirname, 'quiz_app.db');
        pool = new sqlite3.Database(dbPath);
        console.log('📊 Using SQLite database (fallback)');
    }
} else {
    // Use SQLite by default
    const sqlite3 = require('sqlite3').verbose();
    const path = require('path');
    const dbPath = path.join(__dirname, 'quiz_app.db');
    pool = new sqlite3.Database(dbPath);
    console.log('📊 Using SQLite database');
}

// Test database connection
async function testConnection() {
    try {
        if (dbType === 'postgresql') {
            const result = await pool.query('SELECT NOW()');
            console.log('✅ PostgreSQL database connected successfully');
        } else {
            // SQLite connection test
            await new Promise((resolve, reject) => {
                pool.get('SELECT datetime("now") as now', (err, row) => {
                    if (err) reject(err);
                    else resolve(row);
                });
            });
            console.log('✅ SQLite database connected successfully');
        }
        return true;
    } catch (error) {
        console.error('❌ Database connection failed:', error.message);
        return false;
    }
}

if (dbType === 'postgresql') {
    pool.on('connect', () => {
        console.log('Connected to PostgreSQL database');
    });

    pool.on('error', (err) => {
        console.error('Unexpected error on idle client', err);
        process.exit(-1);
    });
}

// Initialize database tables
const initializeDatabase = async () => {
  try {
    if (dbType === 'postgresql') {
      // PostgreSQL table creation
      
      // Main quizzes table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS quizzes (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          title VARCHAR(255) NOT NULL,
          description TEXT,
          result_title VARCHAR(255) DEFAULT 'Personality Type',
          price INTEGER DEFAULT 100,
          currency VARCHAR(3) DEFAULT 'usd',
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Categories table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS categories (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          description TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Questions table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS questions (
          id SERIAL PRIMARY KEY,
          quiz_id INTEGER REFERENCES quizzes(id) ON DELETE CASCADE,
          category_id INTEGER REFERENCES categories(id),
          question_text TEXT NOT NULL,
          question_order INTEGER DEFAULT 0,
          is_active BOOLEAN DEFAULT true,
          country VARCHAR(5) DEFAULT 'en_US',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Answer options table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS answer_options (
          id SERIAL PRIMARY KEY,
          question_id INTEGER REFERENCES questions(id) ON DELETE CASCADE,
          option_text TEXT NOT NULL,
          option_order INTEGER DEFAULT 0,
          personality_weight JSONB,
          country VARCHAR(5) DEFAULT 'en_US',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Personality types table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS personality_types (
          id SERIAL PRIMARY KEY,
          quiz_id INTEGER REFERENCES quizzes(id) ON DELETE CASCADE,
          type_name VARCHAR(255) NOT NULL,
          type_key VARCHAR(100) NOT NULL,
          description TEXT,
          country VARCHAR(5) DEFAULT 'en_US',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Advice table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS advice (
          id SERIAL PRIMARY KEY,
          personality_type_id INTEGER REFERENCES personality_types(id) ON DELETE CASCADE,
          advice_type VARCHAR(50) NOT NULL, -- 'personality' or 'relationship'
          advice_text TEXT NOT NULL,
          advice_order INTEGER DEFAULT 0,
          country VARCHAR(5) DEFAULT 'en_US',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Layout locale table for UI translations
      await pool.query(`
        CREATE TABLE IF NOT EXISTS layout_locale (
          id SERIAL PRIMARY KEY,
          country VARCHAR(5) NOT NULL,
          component_name VARCHAR(100) NOT NULL,
          text_content TEXT NOT NULL,
          description TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(country, component_name)
        )
      `);

      // Scoring rules table (enhanced)
      await pool.query(`
        CREATE TABLE IF NOT EXISTS scoring_rules (
          id SERIAL PRIMARY KEY,
          quiz_id INTEGER REFERENCES quizzes(id) ON DELETE CASCADE,
          personality_type_id INTEGER REFERENCES personality_types(id) ON DELETE CASCADE,
          rule_name VARCHAR(255) NOT NULL,
          rule_type VARCHAR(50) NOT NULL, -- 'scoring_algorithm', 'tie_breaking', 'minimum_threshold'
          rule_conditions JSONB NOT NULL,
          weight INTEGER DEFAULT 1,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Question weights table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS question_weights (
          id SERIAL PRIMARY KEY,
          quiz_id INTEGER REFERENCES quizzes(id) ON DELETE CASCADE,
          question_id INTEGER REFERENCES questions(id) ON DELETE CASCADE,
          weight_multiplier DECIMAL(5,2) DEFAULT 1.0,
          importance_level VARCHAR(20) DEFAULT 'normal', -- 'low', 'normal', 'high', 'critical'
          is_required BOOLEAN DEFAULT false,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Validation rules table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS validation_rules (
          id SERIAL PRIMARY KEY,
          quiz_id INTEGER REFERENCES quizzes(id) ON DELETE CASCADE,
          rule_name VARCHAR(255) NOT NULL,
          rule_type VARCHAR(50) NOT NULL, -- 'completion_rate', 'answer_validation', 'time_limit'
          rule_config JSONB NOT NULL,
          error_message TEXT,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Business rules table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS business_rules (
          id SERIAL PRIMARY KEY,
          quiz_id INTEGER REFERENCES quizzes(id) ON DELETE CASCADE,
          rule_name VARCHAR(255) NOT NULL,
          rule_category VARCHAR(50) NOT NULL, -- 'scoring', 'completion', 'result_display'
          rule_config JSONB NOT NULL,
          priority INTEGER DEFAULT 0,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // System configuration table
      await pool.query(`
        CREATE TABLE IF NOT EXISTS system_config (
          id SERIAL PRIMARY KEY,
          config_key VARCHAR(255) UNIQUE NOT NULL,
          config_value JSONB NOT NULL,
          config_type VARCHAR(50) NOT NULL, -- 'pricing', 'display', 'calculation', 'validation'
          description TEXT,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Quiz sessions table (updated)
      await pool.query(`
        CREATE TABLE IF NOT EXISTS quiz_sessions (
          id SERIAL PRIMARY KEY,
          session_id VARCHAR(255) UNIQUE NOT NULL,
          quiz_id INTEGER REFERENCES quizzes(id),
          email VARCHAR(255),
          payment_status VARCHAR(50) DEFAULT 'pending',
          quiz_answers JSONB,
          result_type VARCHAR(100),
          personality_type_id INTEGER REFERENCES personality_types(id),
          detailed_scores JSONB,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      await pool.query(`
        CREATE TABLE IF NOT EXISTS payments (
          id SERIAL PRIMARY KEY,
          session_id VARCHAR(255) REFERENCES quiz_sessions(session_id),
          stripe_payment_id VARCHAR(255) UNIQUE,
          amount INTEGER NOT NULL,
          currency VARCHAR(3) DEFAULT 'usd',
          status VARCHAR(50) DEFAULT 'pending',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Create indexes for better performance
      await pool.query('CREATE INDEX IF NOT EXISTS idx_quiz_sessions_session_id ON quiz_sessions(session_id)');
      await pool.query('CREATE INDEX IF NOT EXISTS idx_payments_stripe_id ON payments(stripe_payment_id)');
      await pool.query('CREATE INDEX IF NOT EXISTS idx_payments_session_id ON payments(session_id)');
      await pool.query('CREATE INDEX IF NOT EXISTS idx_questions_quiz_id ON questions(quiz_id)');
      await pool.query('CREATE INDEX IF NOT EXISTS idx_answer_options_question_id ON answer_options(question_id)');
      await pool.query('CREATE INDEX IF NOT EXISTS idx_advice_type_id ON advice(personality_type_id)');
    } else {
      // SQLite table creation
      await new Promise((resolve, reject) => {
        pool.serialize(() => {
          // Main quizzes table
          pool.run(`
            CREATE TABLE IF NOT EXISTS quizzes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              title TEXT NOT NULL,
              description TEXT,
              result_title TEXT DEFAULT 'Personality Type',
              price INTEGER DEFAULT 100,
              currency TEXT DEFAULT 'usd',
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Categories table
          pool.run(`
            CREATE TABLE IF NOT EXISTS categories (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Questions table
          pool.run(`
            CREATE TABLE IF NOT EXISTS questions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              category_id INTEGER,
              question_text TEXT NOT NULL,
              question_order INTEGER DEFAULT 0,
              is_active INTEGER DEFAULT 1,
              country VARCHAR(5) DEFAULT 'en_US',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
              FOREIGN KEY (category_id) REFERENCES categories(id)
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Answer options table
          pool.run(`
            CREATE TABLE IF NOT EXISTS answer_options (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              question_id INTEGER,
              option_text TEXT NOT NULL,
              option_order INTEGER DEFAULT 0,
              personality_weight TEXT,
              country VARCHAR(5) DEFAULT 'en_US',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Personality types table
          pool.run(`
            CREATE TABLE IF NOT EXISTS personality_types (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              type_name TEXT NOT NULL,
              type_key TEXT NOT NULL,
              description TEXT,
              country VARCHAR(5) DEFAULT 'en_US',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Advice table
          pool.run(`
            CREATE TABLE IF NOT EXISTS advice (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              personality_type_id INTEGER,
              advice_type TEXT NOT NULL,
              advice_text TEXT NOT NULL,
              advice_order INTEGER DEFAULT 0,
              country VARCHAR(5) DEFAULT 'en_US',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (personality_type_id) REFERENCES personality_types(id) ON DELETE CASCADE
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Layout locale table for UI translations
          pool.run(`
            CREATE TABLE IF NOT EXISTS layout_locale (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              country VARCHAR(5) NOT NULL,
              component_name VARCHAR(100) NOT NULL,
              text_content TEXT NOT NULL,
              description TEXT,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              UNIQUE(country, component_name)
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Scoring rules table (enhanced)
          pool.run(`
            CREATE TABLE IF NOT EXISTS scoring_rules (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              personality_type_id INTEGER,
              rule_name TEXT NOT NULL,
              rule_type TEXT NOT NULL,
              rule_conditions TEXT NOT NULL,
              weight INTEGER DEFAULT 1,
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
              FOREIGN KEY (personality_type_id) REFERENCES personality_types(id) ON DELETE CASCADE
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Question weights table
          pool.run(`
            CREATE TABLE IF NOT EXISTS question_weights (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              question_id INTEGER,
              weight_multiplier REAL DEFAULT 1.0,
              importance_level TEXT DEFAULT 'normal',
              is_required INTEGER DEFAULT 0,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
              FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Validation rules table
          pool.run(`
            CREATE TABLE IF NOT EXISTS validation_rules (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              rule_name TEXT NOT NULL,
              rule_type TEXT NOT NULL,
              rule_config TEXT NOT NULL,
              error_message TEXT,
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Business rules table
          pool.run(`
            CREATE TABLE IF NOT EXISTS business_rules (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              quiz_id INTEGER,
              rule_name TEXT NOT NULL,
              rule_category TEXT NOT NULL,
              rule_config TEXT NOT NULL,
              priority INTEGER DEFAULT 0,
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
            )
          `, (err) => {
            if (err) reject(err);
          });

          // System configuration table
          pool.run(`
            CREATE TABLE IF NOT EXISTS system_config (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              config_key TEXT UNIQUE NOT NULL,
              config_value TEXT NOT NULL,
              config_type TEXT NOT NULL,
              description TEXT,
              is_active INTEGER DEFAULT 1,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Quiz sessions table (updated)
          pool.run(`
            CREATE TABLE IF NOT EXISTS quiz_sessions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              session_id TEXT UNIQUE NOT NULL,
              quiz_id INTEGER,
              email TEXT,
              payment_status TEXT DEFAULT 'pending',
              quiz_answers TEXT,
              result_type TEXT,
              personality_type_id INTEGER,
              detailed_scores TEXT,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (quiz_id) REFERENCES quizzes(id),
              FOREIGN KEY (personality_type_id) REFERENCES personality_types(id)
            )
          `, (err) => {
            if (err) reject(err);
          });

          pool.run(`
            CREATE TABLE IF NOT EXISTS payments (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              session_id TEXT,
              stripe_payment_id TEXT UNIQUE,
              amount INTEGER NOT NULL,
              currency TEXT DEFAULT 'usd',
              status TEXT DEFAULT 'pending',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (session_id) REFERENCES quiz_sessions(session_id)
            )
          `, (err) => {
            if (err) reject(err);
          });

          // Create indexes for better performance
          pool.run('CREATE INDEX IF NOT EXISTS idx_quiz_sessions_session_id ON quiz_sessions(session_id)', (err) => {
            if (err) reject(err);
          });
          pool.run('CREATE INDEX IF NOT EXISTS idx_payments_stripe_id ON payments(stripe_payment_id)', (err) => {
            if (err) reject(err);
          });
          pool.run('CREATE INDEX IF NOT EXISTS idx_payments_session_id ON payments(session_id)', (err) => {
            if (err) reject(err);
          });
          pool.run('CREATE INDEX IF NOT EXISTS idx_questions_quiz_id ON questions(quiz_id)', (err) => {
            if (err) reject(err);
          });
          pool.run('CREATE INDEX IF NOT EXISTS idx_answer_options_question_id ON answer_options(question_id)', (err) => {
            if (err) reject(err);
          });
          pool.run('CREATE INDEX IF NOT EXISTS idx_advice_type_id ON advice(personality_type_id)', (err) => {
            if (err) reject(err);
            else resolve();
          });
        });
      });
    }

    console.log('Database tables initialized successfully');
  } catch (error) {
    console.error('Error initializing database:', error);
  }
};

// Database helper functions
const dbHelpers = {
  // Quiz management functions
  async createQuiz(name, title, description, result_title = 'Personality Type', price = 100, currency = 'usd') {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO quizzes (name, title, description, result_title, price, currency) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
          [name, title, description, result_title, price, currency]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO quizzes (name, title, description, result_title, price, currency) VALUES (?, ?, ?, ?, ?, ?)',
            [name, title, description, result_title, price, currency],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM quizzes WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating quiz:', error);
      throw error;
    }
  },

  async getQuizById(quizId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query('SELECT * FROM quizzes WHERE id = $1', [quizId]);
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.get('SELECT * FROM quizzes WHERE id = ?', [quizId], (err, row) => {
            if (err) reject(err);
            else resolve(row);
          });
        });
      }
    } catch (error) {
      console.error('Error getting quiz:', error);
      throw error;
    }
  },

  async getAllQuizzes() {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query('SELECT * FROM quizzes WHERE is_active = true ORDER BY created_at DESC');
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all('SELECT * FROM quizzes WHERE is_active = 1 ORDER BY created_at DESC', (err, rows) => {
            if (err) reject(err);
            else resolve(rows);
          });
        });
      }
    } catch (error) {
      console.error('Error getting quizzes:', error);
      throw error;
    }
  },

  // Category management functions
  async createCategory(name, description) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO categories (name, description) VALUES ($1, $2) RETURNING *',
          [name, description]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO categories (name, description) VALUES (?, ?)',
            [name, description],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM categories WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating category:', error);
      throw error;
    }
  },

  async getAllCategories() {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query('SELECT * FROM categories ORDER BY name');
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all('SELECT * FROM categories ORDER BY name', (err, rows) => {
            if (err) reject(err);
            else resolve(rows);
          });
        });
      }
    } catch (error) {
      console.error('Error getting categories:', error);
      throw error;
    }
  },

  // Question management functions
  async createQuestion(quizId, categoryId, questionText, questionOrder = 0) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO questions (quiz_id, category_id, question_text, question_order) VALUES ($1, $2, $3, $4) RETURNING *',
          [quizId, categoryId, questionText, questionOrder]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO questions (quiz_id, category_id, question_text, question_order) VALUES (?, ?, ?, ?)',
            [quizId, categoryId, questionText, questionOrder],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM questions WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating question:', error);
      throw error;
    }
  },

  async getQuestionsByQuizId(quizId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          `SELECT q.*, c.name as category_name 
           FROM questions q 
           LEFT JOIN categories c ON q.category_id = c.id 
           WHERE q.quiz_id = $1 AND q.is_active = true 
           ORDER BY q.question_order, q.id`,
          [quizId]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            `SELECT q.*, c.name as category_name 
             FROM questions q 
             LEFT JOIN categories c ON q.category_id = c.id 
             WHERE q.quiz_id = ? AND q.is_active = 1 
             ORDER BY q.question_order, q.id`,
            [quizId],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting questions:', error);
      throw error;
    }
  },

  async getQuestionsByQuizIdAndLocale(quizId, locale = 'en_US') {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          `SELECT q.*, c.name as category_name 
           FROM questions q 
           LEFT JOIN categories c ON q.category_id = c.id 
           WHERE q.quiz_id = $1 AND q.country = $2 AND q.is_active = true 
           ORDER BY q.question_order, q.id`,
          [quizId, locale]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            `SELECT q.*, c.name as category_name 
             FROM questions q 
             LEFT JOIN categories c ON q.category_id = c.id 
             WHERE q.quiz_id = ? AND q.country = ? AND q.is_active = 1 
             ORDER BY q.question_order, q.id`,
            [quizId, locale],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting questions by locale:', error);
      throw error;
    }
  },

  // Answer options management functions
  async createAnswerOption(questionId, optionText, optionOrder = 0, personalityWeight = {}) {
    try {
      const weightStr = dbType === 'postgresql' ? JSON.stringify(personalityWeight) : JSON.stringify(personalityWeight);
      
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO answer_options (question_id, option_text, option_order, personality_weight) VALUES ($1, $2, $3, $4) RETURNING *',
          [questionId, optionText, optionOrder, personalityWeight]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO answer_options (question_id, option_text, option_order, personality_weight) VALUES (?, ?, ?, ?)',
            [questionId, optionText, optionOrder, weightStr],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM answer_options WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating answer option:', error);
      throw error;
    }
  },

  async getAnswerOptionsByQuestionId(questionId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM answer_options WHERE question_id = $1 ORDER BY option_order, id',
          [questionId]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM answer_options WHERE question_id = ? ORDER BY option_order, id',
            [questionId],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting answer options:', error);
      throw error;
    }
  },

  async getAnswerOptionsByQuestionIdAndLocale(questionId, locale = 'en_US') {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM answer_options WHERE question_id = $1 AND country = $2 ORDER BY option_order, id',
          [questionId, locale]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM answer_options WHERE question_id = ? AND country = ? ORDER BY option_order, id',
            [questionId, locale],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting answer options by locale:', error);
      throw error;
    }
  },

  async getAnswerOptionsByGroupIdAndLocale(optionsGroupId, locale = 'en_US') {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM answer_options WHERE options_group_id = $1 AND country = $2 ORDER BY option_order, id',
          [optionsGroupId, locale]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM answer_options WHERE options_group_id = ? AND country = ? ORDER BY option_order, id',
            [optionsGroupId, locale],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting answer options by group ID and locale:', error);
      throw error;
    }
  },

  // Personality types management functions
  async createPersonalityType(quizId, typeName, typeKey, description) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO personality_types (quiz_id, type_name, type_key, description) VALUES ($1, $2, $3, $4) RETURNING *',
          [quizId, typeName, typeKey, description]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO personality_types (quiz_id, type_name, type_key, description) VALUES (?, ?, ?, ?)',
            [quizId, typeName, typeKey, description],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM personality_types WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating personality type:', error);
      throw error;
    }
  },

  async getPersonalityTypesByQuizId(quizId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query('SELECT * FROM personality_types WHERE quiz_id = $1', [quizId]);
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all('SELECT * FROM personality_types WHERE quiz_id = ?', [quizId], (err, rows) => {
            if (err) reject(err);
            else resolve(rows || []);
          });
        });
      }
    } catch (error) {
      console.error('Error getting personality types:', error);
      throw error;
    }
  },

  async getPersonalityTypesByQuizIdAndLocale(quizId, locale = 'en_US') {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query('SELECT * FROM personality_types WHERE quiz_id = $1 AND country = $2', [quizId, locale]);
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all('SELECT * FROM personality_types WHERE quiz_id = ? AND country = ?', [quizId, locale], (err, rows) => {
            if (err) reject(err);
            else resolve(rows || []);
          });
        });
      }
    } catch (error) {
      console.error('Error getting personality types by locale:', error);
      throw error;
    }
  },

  // Personality advice management functions
  async createAdvice(personalityTypeId, adviceType, adviceText, adviceOrder = 0) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order) VALUES ($1, $2, $3, $4) RETURNING *',
          [personalityTypeId, adviceType, adviceText, adviceOrder]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order) VALUES (?, ?, ?, ?)',
            [personalityTypeId, adviceType, adviceText, adviceOrder],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM advice WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating personality advice:', error);
      throw error;
    }
  },

  async getAdviceByTypeId(personalityTypeId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM advice WHERE personality_type_id = $1 ORDER BY advice_type, advice_order',
          [personalityTypeId]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM advice WHERE personality_type_id = ? ORDER BY advice_type, advice_order',
            [personalityTypeId],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting personality advice:', error);
      throw error;
    }
  },

  async getAdviceByTypeIdAndLocale(personalityTypeId, locale = 'en_US') {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM advice WHERE personality_type_id = $1 AND country = $2 ORDER BY advice_type, advice_order',
          [personalityTypeId, locale]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM advice WHERE personality_type_id = ? AND country = ? ORDER BY advice_type, advice_order',
            [personalityTypeId, locale],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting personality advice by locale:', error);
      throw error;
    }
  },

  // Complete quiz data retrieval with locale support
  async getCompleteQuizData(quizId, locale = 'en_US') {
    try {
      const quiz = await dbHelpers.getQuizById(quizId);
      if (!quiz) return null;

      const questions = await dbHelpers.getQuestionsByQuizIdAndLocale(quizId, locale);
      const personalityTypes = await dbHelpers.getPersonalityTypesByQuizIdAndLocale(quizId, locale);

      // Get answer options for each question
      for (let question of questions) {
        // Check if question has options_group_id (for Likert scales)
        if (question.options_group_id !== null && question.options_group_id !== undefined) {
          question.options = await dbHelpers.getAnswerOptionsByGroupIdAndLocale(question.options_group_id, locale);
        } else {
          // Traditional question-specific options
          question.options = await dbHelpers.getAnswerOptionsByQuestionIdAndLocale(question.id, locale);
        }
      }

      // Get advice for each personality type
      for (let type of personalityTypes) {
        const advice = await dbHelpers.getAdviceByTypeIdAndLocale(type.id, locale);
        type.personalityAdvice = advice.filter(a => a.advice_type === 'personality').map(a => a.advice_text);
        type.relationshipAdvice = advice.filter(a => a.advice_type === 'relationship').map(a => a.advice_text);
      }

      return {
        quiz,
        questions,
        personalityTypes
      };
    } catch (error) {
      console.error('Error getting complete quiz data:', error);
      throw error;
    }
  },
  // Save quiz session
  async saveQuizSession(sessionId, email, answers, resultType, quizId = 1, personalityTypeId = null, detailedScores = null) {
    try {
      if (dbType === 'postgresql') {
        const query = `
          INSERT INTO quiz_sessions (session_id, email, quiz_answers, result_type, quiz_id, personality_type_id, detailed_scores)
          VALUES ($1, $2, $3, $4, $5, $6, $7)
          ON CONFLICT (session_id) 
          DO UPDATE SET 
            email = EXCLUDED.email,
            quiz_answers = EXCLUDED.quiz_answers,
            result_type = EXCLUDED.result_type,
            quiz_id = EXCLUDED.quiz_id,
            personality_type_id = EXCLUDED.personality_type_id,
            detailed_scores = EXCLUDED.detailed_scores,
            updated_at = CURRENT_TIMESTAMP
          RETURNING *
        `;
        const result = await pool.query(query, [sessionId, email, JSON.stringify(answers), resultType, quizId, personalityTypeId, JSON.stringify(detailedScores)]);
        return result.rows[0];
      } else {
        // SQLite upsert
        return new Promise((resolve, reject) => {
          const stmt = pool.prepare(`
            INSERT OR REPLACE INTO quiz_sessions 
            (session_id, email, quiz_answers, result_type, quiz_id, personality_type_id, detailed_scores, updated_at) 
            VALUES (?, ?, ?, ?, ?, ?, ?, datetime('now'))
          `);
          stmt.run([sessionId, email, JSON.stringify(answers), resultType, quizId, personalityTypeId, JSON.stringify(detailedScores)], function(err) {
            if (err) {
              reject(err);
            } else {
              // Get the inserted/updated row
              pool.get('SELECT * FROM quiz_sessions WHERE session_id = ?', [sessionId], (err, row) => {
                if (err) reject(err);
                else resolve(row);
              });
            }
          });
          stmt.finalize();
        });
      }
    } catch (error) {
      console.error('Error saving quiz session:', error);
      throw error;
    }
  },

  // Get quiz session
  async getQuizSession(sessionId) {
    try {
      if (dbType === 'postgresql') {
        const query = 'SELECT * FROM quiz_sessions WHERE session_id = $1';
        const result = await pool.query(query, [sessionId]);
        return result.rows[0] || null;
      } else {
        return new Promise((resolve, reject) => {
          pool.get('SELECT * FROM quiz_sessions WHERE session_id = ?', [sessionId], (err, row) => {
            if (err) reject(err);
            else resolve(row || null);
          });
        });
      }
    } catch (error) {
      console.error('Error getting quiz session:', error);
      throw error;
    }
  },

  // Save payment record
  async savePayment(sessionId, stripePaymentId, amount, currency = 'usd', status = 'pending') {
    try {
      if (dbType === 'postgresql') {
        const query = `
          INSERT INTO payments (session_id, stripe_payment_id, amount, currency, status)
          VALUES ($1, $2, $3, $4, $5)
          ON CONFLICT (stripe_payment_id)
          DO UPDATE SET 
            status = EXCLUDED.status,
            updated_at = CURRENT_TIMESTAMP
          RETURNING *
        `;
        const result = await pool.query(query, [sessionId, stripePaymentId, amount, currency, status]);
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          const stmt = pool.prepare(`
            INSERT OR REPLACE INTO payments 
            (session_id, stripe_payment_id, amount, currency, status, updated_at) 
            VALUES (?, ?, ?, ?, ?, datetime('now'))
          `);
          stmt.run([sessionId, stripePaymentId, amount, currency, status], function(err) {
            if (err) {
              reject(err);
            } else {
              pool.get('SELECT * FROM payments WHERE stripe_payment_id = ?', [stripePaymentId], (err, row) => {
                if (err) reject(err);
                else resolve(row);
              });
            }
          });
          stmt.finalize();
        });
      }
    } catch (error) {
      console.error('Error saving payment:', error);
      throw error;
    }
  },

  // Update payment status
  async updatePaymentStatus(stripePaymentId, status) {
    try {
      if (dbType === 'postgresql') {
        const query = `
          UPDATE payments 
          SET status = $1, updated_at = CURRENT_TIMESTAMP 
          WHERE stripe_payment_id = $2 
          RETURNING *
        `;
        const result = await pool.query(query, [status, stripePaymentId]);
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          const stmt = pool.prepare(`
            UPDATE payments 
            SET status = ?, updated_at = datetime('now') 
            WHERE stripe_payment_id = ?
          `);
          stmt.run([status, stripePaymentId], function(err) {
            if (err) {
              reject(err);
            } else {
              pool.get('SELECT * FROM payments WHERE stripe_payment_id = ?', [stripePaymentId], (err, row) => {
                if (err) reject(err);
                else resolve(row);
              });
            }
          });
          stmt.finalize();
        });
      }
    } catch (error) {
      console.error('Error updating payment status:', error);
      throw error;
    }
  },

  // Update quiz session payment status
  async updateQuizSessionPaymentStatus(sessionId, paymentStatus) {
    try {
      if (dbType === 'postgresql') {
        const query = `
          UPDATE quiz_sessions 
          SET payment_status = $1, updated_at = CURRENT_TIMESTAMP 
          WHERE session_id = $2 
          RETURNING *
        `;
        const result = await pool.query(query, [paymentStatus, sessionId]);
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          const stmt = pool.prepare(`
            UPDATE quiz_sessions 
            SET payment_status = ?, updated_at = datetime('now') 
            WHERE session_id = ?
          `);
          stmt.run([paymentStatus, sessionId], function(err) {
            if (err) {
              reject(err);
            } else {
              pool.get('SELECT * FROM quiz_sessions WHERE session_id = ?', [sessionId], (err, row) => {
                if (err) reject(err);
                else resolve(row);
              });
            }
          });
          stmt.finalize();
        });
      }
    } catch (error) {
      console.error('Error updating quiz session payment status:', error);
      throw error;
    }
  },

  // Get payment by session ID
  async getPaymentBySessionId(sessionId) {
    try {
      if (dbType === 'postgresql') {
        const query = 'SELECT * FROM payments WHERE session_id = $1 ORDER BY created_at DESC LIMIT 1';
        const result = await pool.query(query, [sessionId]);
        return result.rows[0] || null;
      } else {
        return new Promise((resolve, reject) => {
          pool.get('SELECT * FROM payments WHERE session_id = ? ORDER BY created_at DESC LIMIT 1', [sessionId], (err, row) => {
            if (err) reject(err);
            else resolve(row || null);
          });
        });
      }
    } catch (error) {
      console.error('Error getting payment by session ID:', error);
      throw error;
    }
  },

  // Get quiz statistics
  async getQuizStats() {
    try {
      if (dbType === 'postgresql') {
        const queries = {
          totalSessions: 'SELECT COUNT(*) as count FROM quiz_sessions',
          paidSessions: 'SELECT COUNT(*) as count FROM quiz_sessions WHERE payment_status = \'completed\'',
          totalRevenue: 'SELECT SUM(amount) as total FROM payments WHERE status = \'succeeded\'',
          recentSessions: 'SELECT COUNT(*) as count FROM quiz_sessions WHERE created_at > NOW() - INTERVAL \'24 hours\''
        };

        const results = {};
        for (const [key, query] of Object.entries(queries)) {
          const result = await pool.query(query);
          results[key] = result.rows[0];
        }
        return results;
      } else {
        const queries = {
          totalSessions: 'SELECT COUNT(*) as count FROM quiz_sessions',
          paidSessions: 'SELECT COUNT(*) as count FROM quiz_sessions WHERE payment_status = "completed"',
          totalRevenue: 'SELECT SUM(amount) as total FROM payments WHERE status = "succeeded"',
          recentSessions: 'SELECT COUNT(*) as count FROM quiz_sessions WHERE created_at > datetime("now", "-24 hours")'
        };

        const results = {};
        for (const [key, query] of Object.entries(queries)) {
          const result = await new Promise((resolve, reject) => {
            pool.get(query, (err, row) => {
              if (err) reject(err);
              else resolve(row);
            });
          });
          results[key] = result;
        }
        return results;
      }
    } catch (error) {
      console.error('Error getting quiz stats:', error);
      throw error;
     }
   },

   // Database Management Functions
  async getAllQuestions() {
    try {
      let questions;
      if (dbType === 'postgresql') {
        const result = await pool.query(`
          SELECT q.*, qz.title as quiz_title 
          FROM questions q 
          LEFT JOIN quizzes qz ON q.quiz_id = qz.id 
          ORDER BY q.quiz_id, q.question_order
        `);
        questions = result.rows;
      } else {
        questions = await new Promise((resolve, reject) => {
          pool.all(`
            SELECT q.*, qz.title as quiz_title 
            FROM questions q 
            LEFT JOIN quizzes qz ON q.quiz_id = qz.id 
            ORDER BY q.quiz_id, q.question_order
          `, (err, rows) => {
            if (err) reject(err);
            else resolve(rows);
          });
        });
      }
      
      // Get answer options for each question
      for (let question of questions) {
        question.options = await dbHelpers.getAnswerOptionsByQuestionId(question.id);
      }
      
      return questions;
    } catch (error) {
      console.error('Error getting all questions with options:', error);
      throw error;
    }
  },

  async getAllPersonalityTypes() {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(`
          SELECT pt.*, pa.advice_type, pa.advice_text, pa.advice_order
          FROM personality_types pt
          LEFT JOIN advice pa ON pt.id = pa.personality_type_id
          ORDER BY pt.id, pa.advice_order
        `);
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(`
            SELECT pt.*, pa.advice_type, pa.advice_text, pa.advice_order
            FROM personality_types pt
            LEFT JOIN advice pa ON pt.id = pa.personality_type_id
            ORDER BY pt.id, pa.advice_order
          `, (err, rows) => {
            if (err) reject(err);
            else resolve(rows);
          });
        });
      }
    } catch (error) {
      console.error('Error getting all personality types:', error);
      throw error;
    }
  },

  // Create scoring rule
  async createScoringRule(quizId, personalityTypeId, ruleConditions, weight = 1) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO scoring_rules (quiz_id, personality_type_id, rule_conditions, weight) VALUES ($1, $2, $3, $4) RETURNING *',
          [quizId, personalityTypeId, JSON.stringify(ruleConditions), weight]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          const stmt = pool.prepare('INSERT INTO scoring_rules (quiz_id, personality_type_id, rule_conditions, weight) VALUES (?, ?, ?, ?)');
          stmt.run([quizId, personalityTypeId, JSON.stringify(ruleConditions), weight], function(err) {
            if (err) {
              reject(err);
            } else {
              pool.get('SELECT * FROM scoring_rules WHERE id = ?', [this.lastID], (err, row) => {
                if (err) reject(err);
                else resolve(row);
              });
            }
          });
          stmt.finalize();
        });
      }
    } catch (error) {
      console.error('Error creating scoring rule:', error);
      throw error;
    }
  },

  // Get scoring rules by quiz ID
  async getScoringRulesByQuizId(quizId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT sr.*, pt.type_name, pt.type_key FROM scoring_rules sr JOIN personality_types pt ON sr.personality_type_id = pt.id WHERE sr.quiz_id = $1 ORDER BY sr.id',
          [quizId]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT sr.*, pt.type_name, pt.type_key FROM scoring_rules sr JOIN personality_types pt ON sr.personality_type_id = pt.id WHERE sr.quiz_id = ? ORDER BY sr.id',
            [quizId],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting scoring rules:', error);
      throw error;
    }
  },

  // Save detailed quiz result with scores
  async saveDetailedQuizResult(sessionId, quizId, answers, personalityScores, winningPersonalityType, maxScore) {
    try {
      const detailedResult = {
        personalityScores,
        winningPersonalityType: winningPersonalityType.type_key,
        maxScore,
        calculatedAt: new Date().toISOString()
      };

      return await dbHelpers.saveQuizSession(
        sessionId,
        null, // email can be added later
        answers,
        winningPersonalityType.type_key,
        quizId,
        winningPersonalityType.id,
        detailedResult
      );
    } catch (error) {
      console.error('Error saving detailed quiz result:', error);
      throw error;
    }
  },

  // Get quiz session with detailed scores
  async getQuizSessionWithScores(sessionId) {
    try {
      const session = await this.getQuizSession(sessionId);
      if (session && session.detailed_scores) {
        if (typeof session.detailed_scores === 'string') {
          session.detailed_scores = JSON.parse(session.detailed_scores);
        }
      }
      return session;
    } catch (error) {
      console.error('Error getting quiz session with scores:', error);
      throw error;
    }
  },

  // ===== CONFIGURATION MANAGEMENT FUNCTIONS =====

  // Question Weights Management
  async createQuestionWeight(quizId, questionId, weightMultiplier, importanceLevel, isRequired) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO question_weights (quiz_id, question_id, weight_multiplier, importance_level, is_required) VALUES ($1, $2, $3, $4, $5) RETURNING *',
          [quizId, questionId, weightMultiplier, importanceLevel, isRequired]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO question_weights (quiz_id, question_id, weight_multiplier, importance_level, is_required) VALUES (?, ?, ?, ?, ?)',
            [quizId, questionId, weightMultiplier, importanceLevel, isRequired ? 1 : 0],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM question_weights WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating question weight:', error);
      throw error;
    }
  },

  async getQuestionWeightsByQuizId(quizId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT qw.*, q.question_text FROM question_weights qw LEFT JOIN questions q ON qw.question_id = q.id WHERE qw.quiz_id = $1 ORDER BY qw.id',
          [quizId]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT qw.*, q.question_text FROM question_weights qw LEFT JOIN questions q ON qw.question_id = q.id WHERE qw.quiz_id = ? ORDER BY qw.id',
            [quizId],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting question weights:', error);
      throw error;
    }
  },

  // Validation Rules Management
  async createValidationRule(quizId, ruleName, ruleType, ruleConfig, errorMessage, isActive = true) {
    try {
      const configStr = typeof ruleConfig === 'string' ? ruleConfig : JSON.stringify(ruleConfig);
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO validation_rules (quiz_id, rule_name, rule_type, rule_config, error_message, is_active) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
          [quizId, ruleName, ruleType, configStr, errorMessage, isActive]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO validation_rules (quiz_id, rule_name, rule_type, rule_config, error_message, is_active) VALUES (?, ?, ?, ?, ?, ?)',
            [quizId, ruleName, ruleType, configStr, errorMessage, isActive ? 1 : 0],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM validation_rules WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating validation rule:', error);
      throw error;
    }
  },

  async getValidationRulesByQuizId(quizId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM validation_rules WHERE quiz_id = $1 ORDER BY id',
          [quizId]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM validation_rules WHERE quiz_id = ? ORDER BY id',
            [quizId],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting validation rules:', error);
      throw error;
    }
  },

  // Business Rules Management
  async createBusinessRule(quizId, ruleName, ruleCategory, ruleConfig, priority = 0, isActive = true) {
    try {
      const configStr = typeof ruleConfig === 'string' ? ruleConfig : JSON.stringify(ruleConfig);
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO business_rules (quiz_id, rule_name, rule_category, rule_config, priority, is_active) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
          [quizId, ruleName, ruleCategory, configStr, priority, isActive]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO business_rules (quiz_id, rule_name, rule_category, rule_config, priority, is_active) VALUES (?, ?, ?, ?, ?, ?)',
            [quizId, ruleName, ruleCategory, configStr, priority, isActive ? 1 : 0],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM business_rules WHERE id = ?', [this.lastID], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating business rule:', error);
      throw error;
    }
  },

  async getBusinessRulesByQuizId(quizId) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM business_rules WHERE quiz_id = $1 ORDER BY priority DESC, id',
          [quizId]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM business_rules WHERE quiz_id = ? ORDER BY priority DESC, id',
            [quizId],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting business rules:', error);
      throw error;
    }
  },

  // System Configuration Management
  async createSystemConfig(configKey, configValue, configType, description, isActive = true) {
    try {
      const valueStr = typeof configValue === 'string' ? configValue : JSON.stringify(configValue);
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'INSERT INTO system_config (config_key, config_value, config_type, description, is_active) VALUES ($1, $2, $3, $4, $5) ON CONFLICT (config_key) DO UPDATE SET config_value = $2, config_type = $3, description = $4, is_active = $5, updated_at = CURRENT_TIMESTAMP RETURNING *',
          [configKey, valueStr, configType, description, isActive]
        );
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(
            'INSERT OR REPLACE INTO system_config (config_key, config_value, config_type, description, is_active, updated_at) VALUES (?, ?, ?, ?, ?, datetime(\'now\'))',
            [configKey, valueStr, configType, description, isActive ? 1 : 0],
            function(err) {
              if (err) reject(err);
              else {
                pool.get('SELECT * FROM system_config WHERE config_key = ?', [configKey], (err, row) => {
                  if (err) reject(err);
                  else resolve(row);
                });
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error creating system config:', error);
      throw error;
    }
  },

  async getSystemConfigByType(configType) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM system_config WHERE config_type = $1 AND is_active = true ORDER BY config_key',
          [configType]
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM system_config WHERE config_type = ? AND is_active = 1 ORDER BY config_key',
            [configType],
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting system config:', error);
      throw error;
    }
  },

  async getAllSystemConfig() {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT * FROM system_config ORDER BY config_type, config_key'
        );
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT * FROM system_config ORDER BY config_type, config_key',
            (err, rows) => {
              if (err) reject(err);
              else resolve(rows || []);
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting all system config:', error);
      throw error;
    }
  },

  async executeRawSQL(query) {
    if (dbType === 'postgresql') {
      const result = await pool.query(query);
      return result.rows;
    } else {
      return new Promise((resolve, reject) => {
        // Determine if it's a SELECT query or modification query
        const isSelect = /^\s*SELECT\s+/i.test(query);
        
        if (isSelect) {
          pool.all(query, (err, rows) => {
            if (err) reject(err);
            else resolve(rows);
          });
        } else {
          pool.run(query, function(err) {
            if (err) reject(err);
            else resolve([{ changes: this.changes, lastID: this.lastID }]);
          });
        }
      });
    }
  },

  // Quiz Images functions
  async createQuizImage(quizId, imageUrl, imageType, title = null, description = null, displayOrder = 0) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(`
          INSERT INTO quiz_images (quiz_id, image_url, image_type, title, description, display_order)
          VALUES ($1, $2, $3, $4, $5, $6)
          RETURNING *
        `, [quizId, imageUrl, imageType, title, description, displayOrder]);
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(`
            INSERT INTO quiz_images (quiz_id, image_url, image_type, title, description, display_order)
            VALUES (?, ?, ?, ?, ?, ?)
          `, [quizId, imageUrl, imageType, title, description, displayOrder], function(err) {
            if (err) {
              reject(err);
            } else {
              pool.get('SELECT * FROM quiz_images WHERE id = ?', [this.lastID], (err, row) => {
                if (err) reject(err);
                else resolve(row);
              });
            }
          });
        });
      }
    } catch (error) {
      console.error('Error creating quiz image:', error);
      throw error;
    }
  },

  async getQuizImagesByQuizId(quizId, imageType = null) {
    try {
      let query, params;
      
      if (imageType) {
        query = `SELECT * FROM quiz_images WHERE quiz_id = ? AND image_type = ? AND is_active = ? ORDER BY display_order, id`;
        params = [quizId, imageType, dbType === 'postgresql' ? true : 1];
      } else {
        query = `SELECT * FROM quiz_images WHERE quiz_id = ? AND is_active = ? ORDER BY display_order, id`;
        params = [quizId, dbType === 'postgresql' ? true : 1];
      }

      if (dbType === 'postgresql') {
        let paramIndex = 0;
        query = query.replace(/\?/g, () => `$${++paramIndex}`);
        const result = await pool.query(query, params);
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(query, params, (err, rows) => {
            if (err) reject(err);
            else resolve(rows || []);
          });
        });
      }
    } catch (error) {
      console.error('Error getting quiz images:', error);
      throw error;
    }
  },

  // Coach functions
  async getAllCoaches() {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(`
          SELECT id, name, title, description, price, currency, coach_type, coach_category, coach_title, coach_description, icon_url
          FROM quizzes 
          WHERE is_active = true
          ORDER BY coach_category, coach_type, name
        `);
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(`
            SELECT id, name, title, description, price, currency, coach_type, coach_category, coach_title, coach_description, icon_url
            FROM quizzes 
            WHERE is_active = 1
            ORDER BY coach_category, coach_type, name
          `, (err, rows) => {
            if (err) reject(err);
            else resolve(rows || []);
          });
        });
      }
    } catch (error) {
      console.error('Error getting all coaches:', error);
      throw error;
    }
  },

  async getCoachesByCategory(category) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(`
          SELECT id, name, title, description, price, currency, coach_type, coach_category, coach_title, coach_description, icon_url
          FROM quizzes 
          WHERE coach_category = $1 AND is_active = true
          ORDER BY coach_type, name
        `, [category]);
        return result.rows;
      } else {
        return new Promise((resolve, reject) => {
          pool.all(`
            SELECT id, name, title, description, price, currency, coach_type, coach_category, coach_title, coach_description, icon_url
            FROM quizzes 
            WHERE coach_category = ? AND is_active = 1
            ORDER BY coach_type, name
          `, [category], (err, rows) => {
            if (err) reject(err);
            else resolve(rows || []);
          });
        });
      }
    } catch (error) {
      console.error('Error getting coaches by category:', error);
      throw error;
    }
  },

  async updateQuizCoachInfo(quizId, coachType, coachCategory, coachTitle, coachDescription, iconUrl) {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(`
          UPDATE quizzes 
          SET coach_type = $1, coach_category = $2, coach_title = $3, coach_description = $4, icon_url = $5, updated_at = CURRENT_TIMESTAMP
          WHERE id = $6
          RETURNING *
        `, [coachType, coachCategory, coachTitle, coachDescription, iconUrl, quizId]);
        return result.rows[0];
      } else {
        return new Promise((resolve, reject) => {
          pool.run(`
            UPDATE quizzes 
            SET coach_type = ?, coach_category = ?, coach_title = ?, coach_description = ?, icon_url = ?, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
          `, [coachType, coachCategory, coachTitle, coachDescription, iconUrl, quizId], function(err) {
            if (err) {
              reject(err);
            } else {
              pool.get('SELECT * FROM quizzes WHERE id = ?', [quizId], (err, row) => {
                if (err) reject(err);
                else resolve(row);
              });
            }
          });
        });
      }
    } catch (error) {
      console.error('Error updating quiz coach info:', error);
      throw error;
    }
  },

  async getSupportedLocales() {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT locale as code, country as name FROM currencies WHERE country IS NOT NULL ORDER BY country'
        );
        return result.rows.map(row => ({
          code: row.code,
          name: row.name || row.code,
          flag: '🌐'
        }));
      } else {
        return new Promise((resolve, reject) => {
          pool.all(
            'SELECT country as code, name, flag FROM currencies WHERE country IS NOT NULL ORDER BY country',
            (err, rows) => {
              if (err) reject(err);
              else {
                const locales = (rows || []).map(row => ({
                  code: row.code,
                  name: row.name || row.code,
                  flag: row.flag || '🌐'
                }));
                resolve(locales);
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error getting supported locales:', error);
      throw error;
    }
  },
};

module.exports = {
  pool,
  dbType,
  initializeDatabase,
  testConnection,
  ...dbHelpers
};