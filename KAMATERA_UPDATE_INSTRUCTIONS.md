# 🚀 Instruções para Atualizar o Servidor Kamatera

## Problema Resolvido
Este update corrige o problema de **opções duplicadas** no quiz que estava acontecendo no servidor Kamatera.

## ⚠️ IMPORTANTE - Leia Antes de Executar

### Pré-requisitos
1. Acesso SSH ao servidor Kamatera
2. Usuário com permissões sudo
3. Banco de dados PostgreSQL funcionando
4. Aplicação atualmente rodando

### Tempo Estimado
- **Downtime**: ~2-3 minutos
- **Processo completo**: ~5-10 minutos

## 📋 Passo a Passo

### 1. Conectar ao Servidor Kamatera
```bash
ssh seu-usuario@seu-servidor-ip
```

### 2. Navegar para o Diretório da Aplicação
```bash
cd /var/www/relationship-quiz
```

### 3. Baixar o Script de Atualização
```bash
# Baixar as últimas mudanças do GitHub
git pull origin main

# Verificar se o script existe
ls -la update-kamatera.sh
```

### 4. Executar o Script de Atualização
```bash
# Tornar o script executável (se necessário)
chmod +x update-kamatera.sh

# Executar a atualização
./update-kamatera.sh
```

## 📊 O que o Script Faz

1. **📦 Backup**: Cria backup automático do banco de dados
2. **🛑 Para Serviços**: Para a aplicação temporariamente
3. **📥 Atualiza Código**: Puxa as últimas mudanças do GitHub
4. **📦 Dependências**: Verifica e instala dependências necessárias
5. **🔧 Correções**: Aplica todas as correções de opções duplicadas:
   - Remove opções duplicadas
   - Corrige idiomas misturados
   - Adiciona opções em espanhol faltantes
   - Reorganiza ordem das opções
6. **🔄 Reinicia**: Reinicia todos os serviços
7. **🧪 Testa**: Verifica se a aplicação está funcionando

## 🔍 Verificação Pós-Atualização

### 1. Verificar Status dos Serviços
```bash
sudo systemctl status relationship-quiz
```

### 2. Verificar Logs
```bash
# Ver logs em tempo real
sudo journalctl -u relationship-quiz -f

# Ver últimas 50 linhas
sudo journalctl -u relationship-quiz -n 50
```

### 3. Testar a Aplicação
```bash
# Teste HTTP
curl -I http://localhost:3000

# Deve retornar: HTTP/1.1 200 OK
```

### 4. Testar no Browser
Acesse: `http://seu-servidor-ip:3000`

- ✅ Verifique se as perguntas não têm opções duplicadas
- ✅ Teste em português, inglês e espanhol
- ✅ Complete um quiz para verificar se funciona end-to-end

## 🆘 Troubleshooting

### Se a Aplicação Não Iniciar
```bash
# Verificar logs de erro
sudo journalctl -u relationship-quiz --no-pager -n 50

# Verificar se o processo está rodando
ps aux | grep node

# Verificar porta
sudo netstat -tlnp | grep :3000
```

### Se Houver Erro no Banco de Dados
```bash
# Verificar conexão com PostgreSQL
psql -h localhost -U relationship_quiz_user -d relationship_quiz -c "\dt"

# Restaurar backup se necessário (substitua YYYYMMDD_HHMMSS pela data do backup)
psql -h localhost -U relationship_quiz_user -d relationship_quiz < relationship_quiz_backup_YYYYMMDD_HHMMSS.sql
```

### Rollback (Se Necessário)
```bash
# Voltar para versão anterior
git log --oneline -5  # Ver últimos commits
git reset --hard COMMIT_HASH_ANTERIOR

# Restaurar backup do banco
psql -h localhost -U relationship_quiz_user -d relationship_quiz < relationship_quiz_backup_YYYYMMDD_HHMMSS.sql

# Reiniciar serviços
sudo systemctl restart relationship-quiz
```

## 📞 Suporte

Se encontrar problemas:

1. **Verifique os logs** primeiro
2. **Documente o erro** (copie a mensagem completa)
3. **Verifique se o backup foi criado** antes de fazer rollback
4. **Entre em contato** com as informações do erro

## ✅ Checklist Final

- [ ] Backup criado com sucesso
- [ ] Código atualizado do GitHub
- [ ] Serviços reiniciados sem erro
- [ ] Aplicação responde HTTP 200
- [ ] Quiz funciona no browser
- [ ] Não há mais opções duplicadas
- [ ] Todos os idiomas funcionam corretamente

---

**🎉 Após a atualização bem-sucedida, o problema de opções duplicadas estará completamente resolvido!**