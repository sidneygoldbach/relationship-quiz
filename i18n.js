const fs = require('fs');
const path = require('path');

const { pool, dbType, getSupportedLocales } = require('./database');

class I18n {
  constructor() {
    this.translations = {};
    this.defaultLocale = 'en_US';
    this.supportedLocales = [];
    this.currencyData = {};
    this.initialized = false;
  }

  async initialize() {
    if (!this.initialized) {
      await this.loadSupportedLocales();
      await this.loadCurrencyData();
      await this.loadTranslations();
      this.initialized = true;
    }
  }

  async loadSupportedLocales() {
    try {
      const locales = await getSupportedLocales();
      this.supportedLocales = locales.map(locale => locale.code);
    } catch (error) {
      console.error('Error loading supported locales:', error);
      this.supportedLocales = ['en_US']; // Minimal fallback
    }
  }

  async loadCurrencyData() {
    try {
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT country, currency, symbol, conversion2us FROM currencies WHERE country IS NOT NULL'
        );
        result.rows.forEach(row => {
          this.currencyData[row.country] = {
            currency: row.currency,
            symbol: row.symbol,
            amount: parseFloat(row.conversion2us)
          };
        });
      } else {
        await new Promise((resolve, reject) => {
          pool.all(
            'SELECT country, currency, symbol, amount FROM currencies WHERE country IS NOT NULL',
            (err, rows) => {
              if (err) reject(err);
              else {
                (rows || []).forEach(row => {
                  this.currencyData[row.country] = {
                    currency: row.currency,
                    symbol: row.symbol,
                    amount: parseFloat(row.amount)
                  };
                });
                resolve();
              }
            }
          );
        });
      }
    } catch (error) {
      console.error('Error loading currency data:', error);
      this.currencyData = {};
    }
  }

  async loadTranslations() {
    try {
      // Carregar traduções do banco de dados
      await this.loadTranslationsFromDatabase();
    } catch (error) {
      console.error('Error loading translations from database, falling back to JSON files:', error);
      // Fallback para arquivos JSON
      this.loadTranslationsFromFiles();
    }
  }

  async loadTranslationsFromDatabase() {
    for (const locale of this.supportedLocales) {
      this.translations[locale] = {};
      
      if (dbType === 'postgresql') {
        const result = await pool.query(
          'SELECT component_name, text_content FROM layout_locale WHERE country = $1',
          [locale]
        );
        
        result.rows.forEach(row => {
          this.setNestedProperty(this.translations[locale], row.component_name, row.text_content);
        });
      } else {
        await new Promise((resolve, reject) => {
          pool.all(
            'SELECT component_name, text_content FROM layout_locale WHERE country = ?',
            [locale],
            (err, rows) => {
              if (err) {
                reject(err);
                return;
              }
              
              rows.forEach(row => {
                this.setNestedProperty(this.translations[locale], row.component_name, row.text_content);
              });
              resolve();
            }
          );
        });
      }
    }
  }

  loadTranslationsFromFiles() {
    const localesDir = path.join(__dirname, 'locales');
    
    this.supportedLocales.forEach(locale => {
      try {
        const filePath = path.join(localesDir, `${locale}.json`);
        if (fs.existsSync(filePath)) {
          const content = fs.readFileSync(filePath, 'utf8');
          this.translations[locale] = JSON.parse(content);
        }
      } catch (error) {
        console.error(`Error loading translations for ${locale}:`, error);
      }
    });
  }

  setNestedProperty(obj, path, value) {
    const keys = path.split('.');
    let current = obj;
    
    for (let i = 0; i < keys.length - 1; i++) {
      const key = keys[i];
      if (!(key in current)) {
        current[key] = {};
      }
      current = current[key];
    }
    
    current[keys[keys.length - 1]] = value;
  }

  detectLocale(req) {
    // Priority order:
    // 1. URL parameter (?locale=pt_BR)
    // 2. Accept-Language header
    // 3. Default locale
    
    if (req.query && req.query.locale && this.supportedLocales.includes(req.query.locale)) {
      return req.query.locale;
    }
    
    if (req.headers && req.headers['accept-language']) {
      const acceptLanguage = req.headers['accept-language'];
      
      // Check for exact matches first
      for (const locale of this.supportedLocales) {
        if (acceptLanguage.includes(locale.replace('_', '-'))) {
          return locale;
        }
      }
      
      // Check for language matches dynamically
      const language = acceptLanguage.split(',')[0].split('-')[0].toLowerCase();
      for (const locale of this.supportedLocales) {
        if (locale.toLowerCase().startsWith(language + '_')) {
          return locale;
        }
      }
    }
    
    return this.defaultLocale;
  }

  getNestedProperty(obj, path) {
    const keys = path.split('.');
    let current = obj;
    
    for (const key of keys) {
      if (current && typeof current === 'object' && current[key]) {
        current = current[key];
      } else {
        return null;
      }
    }
    
    return typeof current === 'string' ? current : null;
  }

  async translate(key, locale = this.defaultLocale, params = {}) {
    await this.initialize();
    
    if (!this.translations[locale]) {
      locale = this.defaultLocale;
    }
    
    const translation = this.getNestedProperty(this.translations[locale], key);
    
    if (!translation) {
      // Fallback to default locale
      const fallbackTranslation = this.getNestedProperty(this.translations[this.defaultLocale], key);
      if (!fallbackTranslation) {
        console.warn(`Translation missing for key: ${key} in locale: ${locale}`);
        return key;
      }
      
      // Simple parameter replacement
      return fallbackTranslation.replace(/\{\{(\w+)\}\}/g, (match, param) => {
        return params[param] || match;
      });
    }
    
    // Simple parameter replacement
    return translation.replace(/\{\{(\w+)\}\}/g, (match, param) => {
      return params[param] || match;
    });
  }

  // Método síncrono para compatibilidade (usa cache)
  t(key, locale = this.defaultLocale, params = {}) {
    if (!this.initialized) {
      console.warn('I18n not initialized, returning key:', key);
      return key;
    }
    
    if (!this.translations[locale]) {
      locale = this.defaultLocale;
    }
    
    const translation = this.getNestedProperty(this.translations[locale], key);
    
    if (!translation) {
      // Fallback to default locale
      const fallbackTranslation = this.getNestedProperty(this.translations[this.defaultLocale], key);
      if (!fallbackTranslation) {
        console.warn(`Translation missing for key: ${key} in locale: ${locale}`);
        return key;
      }
      
      // Simple parameter replacement
      return fallbackTranslation.replace(/\{\{(\w+)\}\}/g, (match, param) => {
        return params[param] || match;
      });
    }
    
    // Simple parameter replacement
    return translation.replace(/\{\{(\w+)\}\}/g, (match, param) => {
      return params[param] || match;
    });
  }

  getTranslations(locale = this.defaultLocale) {
    return this.translations[locale] || this.translations[this.defaultLocale];
  }

  getSupportedLocales() {
    return this.supportedLocales;
  }

  getCurrencyInfo(locale) {
    return this.currencyData[locale] || this.currencyData[this.defaultLocale] || {
      currency: 'USD',
      symbol: '$',
      amount: 4.99
    };
  }
}

// Create singleton instance
const i18n = new I18n();

// Express middleware
function i18nMiddleware(req, res, next) {
  const locale = i18n.detectLocale(req);
  req.locale = locale;
  req.t = (key, params) => i18n.t(key, locale, params); // Usar método síncrono
  req.tAsync = async (key, params) => await i18n.translate(key, locale, params); // Método assíncrono
  req.translations = i18n.getTranslations(locale);
  req.currencyInfo = i18n.getCurrencyInfo(locale);
  next();
}

module.exports = {
  i18n,
  i18nMiddleware
};