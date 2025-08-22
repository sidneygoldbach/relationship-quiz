const { pool, dbType, initializeDatabase } = require('./database');

async function createQuizImagesTable() {
    try {
        console.log('🖼️  Creating quiz images table...');
        
        if (dbType === 'postgresql') {
            // PostgreSQL version
            await pool.query(`
                CREATE TABLE IF NOT EXISTS quiz_images (
                    id SERIAL PRIMARY KEY,
                    quiz_id INTEGER REFERENCES quizzes(id) ON DELETE CASCADE,
                    image_url VARCHAR(500) NOT NULL,
                    image_type VARCHAR(50) NOT NULL, -- 'background_image', 'starting_image', 'advertising_video', 'icon', 'banner'
                    title VARCHAR(255),
                    description TEXT,
                    display_order INTEGER DEFAULT 0,
                    is_active BOOLEAN DEFAULT true,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            `);
            
            // Create index for better performance
            await pool.query('CREATE INDEX IF NOT EXISTS idx_quiz_images_quiz_id ON quiz_images(quiz_id)');
            await pool.query('CREATE INDEX IF NOT EXISTS idx_quiz_images_type ON quiz_images(image_type)');
            
            console.log('✅ PostgreSQL: quiz_images table created successfully');
            
        } else {
            // SQLite version
            const sqlite3 = require('sqlite3').verbose();
            
            await new Promise((resolve, reject) => {
                pool.run(`
                    CREATE TABLE IF NOT EXISTS quiz_images (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        quiz_id INTEGER,
                        image_url TEXT NOT NULL,
                        image_type TEXT NOT NULL, -- 'background_image', 'starting_image', 'advertising_video', 'icon', 'banner'
                        title TEXT,
                        description TEXT,
                        display_order INTEGER DEFAULT 0,
                        is_active INTEGER DEFAULT 1,
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
                    )
                `, (err) => {
                    if (err) {
                        reject(err);
                    } else {
                        console.log('✅ SQLite: quiz_images table created successfully');
                        resolve();
                    }
                });
            });
            
            // Create indexes for SQLite
            await new Promise((resolve, reject) => {
                pool.run('CREATE INDEX IF NOT EXISTS idx_quiz_images_quiz_id ON quiz_images(quiz_id)', (err) => {
                    if (err) reject(err);
                    else resolve();
                });
            });
            
            await new Promise((resolve, reject) => {
                pool.run('CREATE INDEX IF NOT EXISTS idx_quiz_images_type ON quiz_images(image_type)', (err) => {
                    if (err) reject(err);
                    else resolve();
                });
            });
        }
        
        console.log('🎯 Quiz images table setup completed!');
        
    } catch (error) {
        console.error('❌ Error creating quiz images table:', error);
        throw error;
    }
}

// Run the migration if this file is executed directly
if (require.main === module) {
    createQuizImagesTable()
        .then(() => {
            console.log('✨ Quiz images table migration completed successfully!');
            process.exit(0);
        })
        .catch((error) => {
            console.error('💥 Migration failed:', error);
            process.exit(1);
        });
}

module.exports = { createQuizImagesTable };