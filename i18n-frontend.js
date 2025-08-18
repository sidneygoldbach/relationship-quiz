class I18nFrontend {
    constructor() {
        this.locale = 'en_US';
        this.translations = {};
        this.currencyInfo = {};
        this.initialized = false;
    }

    async init() {
        try {
            // Get locale from URL parameter or browser language
            const urlParams = new URLSearchParams(window.location.search);
            const urlLocale = urlParams.get('locale');
            
            if (urlLocale) {
                this.locale = urlLocale;
            } else {
                // Detect browser language
                const browserLang = navigator.language || navigator.userLanguage;
                if (browserLang.startsWith('pt')) {
                    this.locale = 'pt_BR';
                } else if (browserLang.startsWith('es')) {
                    this.locale = 'es_ES';
                } else {
                    this.locale = 'en_US';
                }
            }

            // Fetch translations from server
            const response = await fetch(`/api/translations?locale=${this.locale}`);
            if (response.ok) {
                const data = await response.json();
                this.locale = data.locale;
                this.translations = data.translations;
                this.currencyInfo = data.currencyInfo;
                this.initialized = true;
                
                // Update URL with locale if not present
                if (!urlLocale) {
                    const newUrl = new URL(window.location);
                    newUrl.searchParams.set('locale', this.locale);
                    window.history.replaceState({}, '', newUrl);
                }
                
                // Apply translations to the page
                this.applyTranslations();
                
                console.log('I18n initialized with locale:', this.locale);
            } else {
                console.error('Failed to load translations');
            }
        } catch (error) {
            console.error('Error initializing i18n:', error);
        }
    }

    t(key, params = {}) {
        if (!this.initialized) {
            return key;
        }

        const keys = key.split('.');
        let translation = this.translations;
        
        for (const k of keys) {
            if (translation && typeof translation === 'object' && translation[k]) {
                translation = translation[k];
            } else {
                return key; // Return key if translation not found
            }
        }
        
        if (typeof translation === 'string') {
            // Replace parameters in translation
            return translation.replace(/\{\{(\w+)\}\}/g, (match, param) => {
                return params[param] || match;
            });
        }
        
        return key;
    }

    applyTranslations() {
        // Find all elements with data-i18n attribute
        const elements = document.querySelectorAll('[data-i18n]');
        
        elements.forEach(element => {
            const key = element.getAttribute('data-i18n');
            const translation = this.t(key);
            
            if (element.tagName === 'INPUT' && (element.type === 'submit' || element.type === 'button')) {
                element.value = translation;
            } else if (element.tagName === 'INPUT' && element.placeholder !== undefined) {
                element.placeholder = translation;
            } else {
                element.textContent = translation;
            }
        });

        // Update document title if present
        const titleElement = document.querySelector('[data-i18n-title]');
        if (titleElement) {
            const titleKey = titleElement.getAttribute('data-i18n-title');
            document.title = this.t(titleKey);
        }

        // Update currency displays
        const currencyElements = document.querySelectorAll('[data-currency]');
        currencyElements.forEach(element => {
            element.textContent = `${this.currencyInfo.symbol}${this.currencyInfo.amount.toFixed(2)}`;
        });
    }

    switchLocale(newLocale) {
        const url = new URL(window.location);
        url.searchParams.set('locale', newLocale);
        window.location.href = url.toString();
    }

    formatCurrency(amount) {
        return `${this.currencyInfo.symbol}${amount.toFixed(2)}`;
    }

    getCurrencyInfo() {
        return this.currencyInfo;
    }

    getLocale() {
        return this.locale;
    }

    getSupportedLocales() {
        return [
            { code: 'en_US', name: 'English', flag: '🇺🇸' },
            { code: 'pt_BR', name: 'Português (Brasil)', flag: '🇧🇷' },
            { code: 'es_ES', name: 'Español', flag: '🇪🇸' }
        ];
    }

    createLanguageSwitcher() {
        const switcher = document.createElement('div');
        switcher.className = 'language-switcher';
        switcher.innerHTML = `
            <select id="locale-select" class="locale-select">
                <option value="en_US" ${this.locale === 'en_US' ? 'selected' : ''}>🇺🇸 English</option>
                <option value="pt_BR" ${this.locale === 'pt_BR' ? 'selected' : ''}>🇧🇷 Português</option>
                <option value="es_ES" ${this.locale === 'es_ES' ? 'selected' : ''}>🇪🇸 Español</option>
            </select>
        `;

        const select = switcher.querySelector('#locale-select');
        select.addEventListener('change', (e) => {
            this.switchLocale(e.target.value);
        });

        return switcher;
    }
}

// Create global instance
const i18n = new I18nFrontend();

// Initialize when DOM is loaded
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => i18n.init());
} else {
    i18n.init();
}

// Make it globally available
window.i18n = i18n;