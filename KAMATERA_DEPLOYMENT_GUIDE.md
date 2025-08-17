# Guia de Deploy - Servidor Kamatera
## Sistema i18n Database-Driven

### 📋 **Pré-requisitos**
- Acesso SSH ao servidor Kamatera
- Git configurado no servidor
- PostgreSQL rodando no servidor
- Node.js e npm instalados
- PM2 ou similar para gerenciamento de processos

---

## 🚀 **Passos para Deploy no Servidor Kamatera**

### **1. Conectar ao Servidor Kamatera**
```bash
# Substitua pelos seus dados reais do servidor
ssh root@SEU_IP_KAMATERA
# ou
ssh usuario@SEU_IP_KAMATERA
```

### **2. Fazer Backup dos Dados Atuais**
```bash
# Backup do banco de dados PostgreSQL
pg_dump -U quiz_user -h localhost quiz_app > backup_$(date +%Y%m%d_%H%M%S).sql

# Backup dos arquivos da aplicação
cp -r /path/to/your/app /path/to/backup/app_backup_$(date +%Y%m%d_%H%M%S)
```

### **3. Navegar para o Diretório da Aplicação**
```bash
cd /path/to/your/relationship-quiz
# Exemplo: cd /var/www/relationship-quiz
```

### **4. Parar os Serviços Atuais**
```bash
# Se usando PM2
pm2 stop all

# Se usando systemctl
sudo systemctl stop relationship-quiz

# Ou se rodando diretamente
pkill -f "node server.js"
```

### **5. Atualizar o Código do GitHub**
```bash
# Verificar branch atual
git branch

# Fazer pull das últimas mudanças
git pull origin main

# Verificar se houve conflitos
git status
```

### **6. Instalar/Atualizar Dependências**
```bash
# Instalar novas dependências
npm install

# Limpar cache se necessário
npm cache clean --force
```

### **7. Configurar Variáveis de Ambiente**
```bash
# Verificar se o arquivo .env existe e está correto
cat .env

# Se necessário, criar/atualizar o .env
cp .env.example .env
nano .env
```

**Configurações importantes no .env:**
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=quiz_app
DB_USER=quiz_user
DB_PASSWORD=sua_senha_aqui
NODE_ENV=production
PORT=3000
```

### **8. Executar Migrações do Banco de Dados**

**RECOMENDADO**: Para resolver todos os problemas de uma vez, use o script de correção completa:

```bash
# Script que resolve todos os problemas automaticamente:
node fix-kamatera-complete.js
```

**OU** se preferir executar individualmente:

```bash
# Se houve erro de foreign key constraint:
node fix-kamatera-migration.js

# OU se não houve erros, execute na ordem:
node add-portuguese-options.js
node fix-personality-keys.js
node migrate_translations.js
```

**Para diagnosticar problemas específicos:**

```bash
# Para verificar se as opções estão aparecendo:
node diagnose-kamatera-options.js
```

### **9. Verificar Estrutura do Banco de Dados**
```bash
# Conectar ao PostgreSQL e verificar tabelas
psql -U quiz_user -d quiz_app -c "\dt"

# Verificar se as novas tabelas foram criadas
psql -U quiz_user -d quiz_app -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"
```

### **10. Testar a Aplicação Localmente**
```bash
# Testar se a aplicação inicia sem erros
node server.js

# Em outro terminal, testar endpoints
curl http://localhost:3000/api/quiz/1
curl -H "Accept-Language: pt-BR" http://localhost:3000/api/quiz/1
```

### **11. Reiniciar os Serviços**
```bash
# Se usando PM2
pm2 start ecosystem.config.js
# ou
pm2 start server.js --name "relationship-quiz"

# Se usando systemctl
sudo systemctl start relationship-quiz
sudo systemctl enable relationship-quiz

# Verificar status
pm2 status
# ou
sudo systemctl status relationship-quiz
```

### **12. Configurar Nginx (se aplicável)**
```bash
# Verificar configuração do Nginx
sudo nginx -t

# Recarregar configuração
sudo systemctl reload nginx
```

### **13. Testes Finais**
```bash
# Testar endpoint principal
curl https://seu-dominio.com/api/quiz/1

# Testar com diferentes idiomas
curl -H "Accept-Language: pt-BR" https://seu-dominio.com/api/quiz/1
curl -H "Accept-Language: es-ES" https://seu-dominio.com/api/quiz/1

# Testar cálculo de resultado
curl -H "Authorization: Bearer TOKEN" -H "Content-Type: application/json" -H "Accept-Language: pt-BR" -X POST -d '{"answers": [0, 1, 2, 3, 0, 1]}' https://seu-dominio.com/api/quiz/1/calculate
```

---

## 🔧 **Comandos Úteis para Troubleshooting**

### **Erro de Foreign Key Constraint durante migração**
Se você recebeu o erro "insert or update on table 'questions' violates foreign key constraint 'questions_quiz_id_fkey'", execute:

```bash
node fix-kamatera-migration.js
```

Este script criará o quiz padrão necessário e executará a migração corretamente.

### **Verificar Logs**
```bash
# Logs do PM2
pm2 logs

# Logs do sistema
sudo journalctl -u relationship-quiz -f

# Logs do Nginx
sudo tail -f /var/log/nginx/error.log
```

### **Verificar Banco de Dados**
```bash
# Conectar ao PostgreSQL
psql -U quiz_user -d quiz_app

# Verificar dados das traduções
SELECT * FROM layout_locale WHERE country = 'pt_BR' LIMIT 5;

# Verificar tipos de personalidade
SELECT * FROM personality_types WHERE country = 'pt_BR';

# Verificar opções de resposta
SELECT * FROM answer_options WHERE country = 'pt_BR' LIMIT 5;
```

### **Rollback em Caso de Problemas**
```bash
# Restaurar backup do banco
psql -U quiz_user -d quiz_app < backup_YYYYMMDD_HHMMSS.sql

# Voltar para commit anterior
git reset --hard HEAD~1

# Reinstalar dependências
npm install

# Reiniciar serviços
pm2 restart all
```

---

## ⚠️ **Pontos de Atenção**

1. **Backup Obrigatório:** Sempre faça backup antes de qualquer deploy
2. **Ordem das Migrações:** Execute os scripts de migração na ordem correta
3. **Variáveis de Ambiente:** Verifique se todas as variáveis estão configuradas
4. **Permissões:** Certifique-se de que o usuário tem permissões adequadas
5. **Firewall:** Verifique se as portas necessárias estão abertas
6. **SSL:** Se usando HTTPS, verifique os certificados

---

## 📞 **Suporte**

Em caso de problemas:
1. Verifique os logs da aplicação
2. Teste os endpoints individualmente
3. Verifique a conectividade com o banco de dados
4. Confirme se todas as migrações foram executadas

**Commit atual:** `12ba17b - feat: Implement database-driven i18n system with multilingual support`