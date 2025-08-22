const { pool, dbType, initializeDatabase } = require('./database');

async function extendQuizzesTableForCoach() {
    try {
        console.log('🎯 Extending quizzes table for multi-coach support...');
        
        if (dbType === 'postgresql') {
            // PostgreSQL version
            // Add coach_type column
            await pool.query(`
                ALTER TABLE quizzes 
                ADD COLUMN IF NOT EXISTS coach_type VARCHAR(100) DEFAULT 'relationship'
            `);
            
            // Add coach_category column
            await pool.query(`
                ALTER TABLE quizzes 
                ADD COLUMN IF NOT EXISTS coach_category VARCHAR(100) DEFAULT 'personal'
            `);
            
            // Add icon_url column
            await pool.query(`
                ALTER TABLE quizzes 
                ADD COLUMN IF NOT EXISTS icon_url VARCHAR(500)
            `);
            
            // Add coach_title column for display purposes
            await pool.query(`
                ALTER TABLE quizzes 
                ADD COLUMN IF NOT EXISTS coach_title VARCHAR(255)
            `);
            
            // Add coach_description column
            await pool.query(`
                ALTER TABLE quizzes 
                ADD COLUMN IF NOT EXISTS coach_description TEXT
            `);
            
            // Add is_active column to enable/disable coaches
            await pool.query(`
                ALTER TABLE quizzes 
                ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true
            `);
            
            // Create indexes for better performance
            await pool.query('CREATE INDEX IF NOT EXISTS idx_quizzes_coach_type ON quizzes(coach_type)');
            await pool.query('CREATE INDEX IF NOT EXISTS idx_quizzes_coach_category ON quizzes(coach_category)');
            await pool.query('CREATE INDEX IF NOT EXISTS idx_quizzes_is_active ON quizzes(is_active)');
            
            console.log('✅ PostgreSQL: quizzes table extended successfully');
            
        } else {
            // SQLite version - need to check if columns exist first
            const checkColumn = async (columnName) => {
                return new Promise((resolve, reject) => {
                    pool.get(`PRAGMA table_info(quizzes)`, (err, rows) => {
                        if (err) {
                            reject(err);
                        } else {
                            pool.all(`PRAGMA table_info(quizzes)`, (err, columns) => {
                                if (err) {
                                    reject(err);
                                } else {
                                    const columnExists = columns.some(col => col.name === columnName);
                                    resolve(columnExists);
                                }
                            });
                        }
                    });
                });
            };
            
            // Add columns if they don't exist
            const columnsToAdd = [
                { name: 'coach_type', definition: 'TEXT DEFAULT "relationship"' },
                { name: 'coach_category', definition: 'TEXT DEFAULT "personal"' },
                { name: 'icon_url', definition: 'TEXT' },
                { name: 'coach_title', definition: 'TEXT' },
                { name: 'coach_description', definition: 'TEXT' },
                { name: 'is_active', definition: 'INTEGER DEFAULT 1' }
            ];
            
            for (const column of columnsToAdd) {
                const exists = await checkColumn(column.name);
                if (!exists) {
                    await new Promise((resolve, reject) => {
                        pool.run(`ALTER TABLE quizzes ADD COLUMN ${column.name} ${column.definition}`, (err) => {
                            if (err) {
                                reject(err);
                            } else {
                                console.log(`✅ Added column: ${column.name}`);
                                resolve();
                            }
                        });
                    });
                } else {
                    console.log(`ℹ️  Column ${column.name} already exists`);
                }
            }
            
            // Create indexes for SQLite
            const indexes = [
                'CREATE INDEX IF NOT EXISTS idx_quizzes_coach_type ON quizzes(coach_type)',
                'CREATE INDEX IF NOT EXISTS idx_quizzes_coach_category ON quizzes(coach_category)',
                'CREATE INDEX IF NOT EXISTS idx_quizzes_is_active ON quizzes(is_active)'
            ];
            
            for (const indexQuery of indexes) {
                await new Promise((resolve, reject) => {
                    pool.run(indexQuery, (err) => {
                        if (err) reject(err);
                        else resolve();
                    });
                });
            }
            
            console.log('✅ SQLite: quizzes table extended successfully');
        }
        
        console.log('🎯 Quizzes table extension completed!');
        
    } catch (error) {
        console.error('❌ Error extending quizzes table:', error);
        throw error;
    }
}

// Run the migration if this file is executed directly
if (require.main === module) {
    extendQuizzesTableForCoach()
        .then(() => {
            console.log('✨ Quizzes table extension completed successfully!');
            process.exit(0);
        })
        .catch((error) => {
            console.error('💥 Migration failed:', error);
            process.exit(1);
        });
}

module.exports = { extendQuizzesTableForCoach };