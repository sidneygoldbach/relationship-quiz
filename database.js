const fs = require('fs');
require('dotenv').config();

let pool;
let dbType = 'sqlite'; // Default to SQLite

// Check if PostgreSQL is available and configured
if (process.env.DB_HOST && process.env.DB_USER && process.env.DB_PASSWORD) {
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
      await pool.query(`
        CREATE TABLE IF NOT EXISTS quiz_sessions (
          id SERIAL PRIMARY KEY,
          session_id VARCHAR(255) UNIQUE NOT NULL,
          email VARCHAR(255),
          payment_status VARCHAR(50) DEFAULT 'pending',
          quiz_answers JSONB,
          result_type VARCHAR(100),
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
    } else {
      // SQLite table creation
      await new Promise((resolve, reject) => {
        pool.serialize(() => {
          pool.run(`
            CREATE TABLE IF NOT EXISTS quiz_sessions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              session_id TEXT UNIQUE NOT NULL,
              email TEXT,
              payment_status TEXT DEFAULT 'pending',
              quiz_answers TEXT,
              result_type TEXT,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
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
  // Save quiz session
  async saveQuizSession(sessionId, email, answers, resultType) {
    try {
      if (dbType === 'postgresql') {
        const query = `
          INSERT INTO quiz_sessions (session_id, email, quiz_answers, result_type)
          VALUES ($1, $2, $3, $4)
          ON CONFLICT (session_id) 
          DO UPDATE SET 
            email = EXCLUDED.email,
            quiz_answers = EXCLUDED.quiz_answers,
            result_type = EXCLUDED.result_type,
            updated_at = CURRENT_TIMESTAMP
          RETURNING *
        `;
        const result = await pool.query(query, [sessionId, email, JSON.stringify(answers), resultType]);
        return result.rows[0];
      } else {
        // SQLite upsert
        return new Promise((resolve, reject) => {
          const stmt = pool.prepare(`
            INSERT OR REPLACE INTO quiz_sessions 
            (session_id, email, quiz_answers, result_type, updated_at) 
            VALUES (?, ?, ?, ?, datetime('now'))
          `);
          stmt.run([sessionId, email, JSON.stringify(answers), resultType], function(err) {
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
  }
};

module.exports = {
  pool,
  dbType,
  initializeDatabase,
  testConnection,
  ...dbHelpers
};