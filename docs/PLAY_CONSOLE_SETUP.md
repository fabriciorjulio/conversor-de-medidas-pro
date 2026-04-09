# 🚀 Guia Passo-a-Passo: Play Console Setup

## ✅ PASSO 1: CRIAR CONTA GOOGLE PLAY DEVELOPER

### 1.1 Acessar Play Console
```
https://play.google.com/console
```

### 1.2 Login com Google
- Use sua conta Google pessoal
- Se não tiver, crie uma: https://accounts.google.com

### 1.3 Pagar Taxa de Desenvolvedor ($25 USD)
- Clique em "Ir para Play Console"
- Será solicitado cartão de crédito
- Cobra uma única vez (não recorrente)
- Aceite os termos

### 1.4 Preencher Dados do Desenvolvedor
```
Nome do Desenvolvedor: Seu Nome (ou empresa)
Email de Contato: fabriciorjulio@gmail.com
Website (opcional): https://github.com/fabriciorjulio
Telefone: +55 (seu telefone)
Endereço: Seu endereço completo
```

### 1.5 Aguardar Confirmação
- Email será enviado para validação
- Clique no link de confirmação
- Conta ativa em minutos

---

## ✅ PASSO 2: CRIAR APP NO PLAY CONSOLE

### 2.1 Clique em "Criar App"
```
Play Console → Apps → Criar app
```

### 2.2 Preencher Dados Básicos

**Nome da app:**
```
Converte Tudo
```

**Descrição resumida:**
```
Medidas, moedas e finanças em um app
```

**Idioma padrão:**
```
Português (Brasil)
```

**Tipo de app:**
```
Aplicativo
```

**Categoria:**
```
Produtividade
```

### 2.3 Selecionar Categoria
```
Categoria: Produtividade
Categoria secundária (opcional): Ferramentas (Tools)
```

### 2.4 Informações de Classificação Etária
```
Classificação: 3+ / Irrestrito (PEGI 3)
Razão: Aplicativo de utilidade, sem conteúdo prejudicial
```

---

## ✅ PASSO 3: CONFIGURAR STORE LISTING

### 3.1 Acessar Configuração
```
Play Console → Sua App → Store listing
```

### 3.2 PREENCHIMENTO PRINCIPAL

#### Título (30 caracteres max)
```
Converte Tudo - 20+ Conversores
```

#### Descrição Resumida (80 caracteres)
```
Medidas, moedas e finanças em um app. Offline, gratuito, sem anúncios.
```

#### Descrição Completa (4000 caracteres max)
```
[COPIE INTEGRO DO ARQUIVO: PLAY_STORE_LISTING.md - seção "DESCRIÇÃO COMPLETA"]
```

### 3.3 PALAVRA-CHAVE
```
- conversor de medidas
- calculadora financeira
- cotações ao vivo
- converte moedas
- ferramentas offline
```

### 3.4 CONTATO DE SUPORTE
```
Email: fabriciorjulio@gmail.com
Telefone: (opcional)
Website: https://github.com/fabriciorjulio/conversor-de-medidas-pro
```

---

## ✅ PASSO 4: CAPTURAR SCREENSHOTS

### 4.1 Requisitos
- **Resolução**: Pixel 6 (1440 x 3120 px)
- **Quantidade**: Mínimo 2, máximo 8
- **Formato**: PNG ou JPG
- **Tamanho máximo**: 8 MB por imagem
- **Idioma**: PT-BR

### 4.2 Emulador para Capturar
```bash
# Use Android Studio com emulador Pixel 6
# Ou use seu celular real (melhor qualidade)

# Para capturar screenshot no Android:
# 1. Conecte via USB e habilite "Modo desenvolvedor"
# 2. Use: adb shell screencap -p /sdcard/screenshot.png
# 3. Puxe: adb pull /sdcard/screenshot.png ./screenshot.png

# OU use Android Studio Tools → Device Explorer
```

### 4.3 Screenshots Recomendadas (5)

**1️⃣ Home Screen**
- Mostrar menu com categorias
- Destacar "20+ Conversores"
- Modo claro (light mode)
- Texto overlay: "Acesso rápido a todos os conversores"

**2️⃣ Conversor em Ação**
- Exemplo: 1 metro = 100 centímetro
- Mostrar input field + resultado
- Destacar botão SWAP
- Texto: "Conversões precisas em tempo real"

**3️⃣ Ferramentas (5 tools)**
- Mostrar cards de FIPE, PDF, Imagens, Commodities, Tamanhos
- Texto: "5 ferramentas exóticas integradas"

**4️⃣ Dark Mode**
- Mesma interface em dark mode
- Mostrar toggle de tema
- Texto: "Dark mode automático para seu conforto"

**5️⃣ Histórico**
- Mostrar histórico com 3-5 conversões
- Mostrar botões de remover e limpar
- Texto: "Histórico completo das últimas 10 conversões"

### 4.4 Upload de Screenshots
```
Play Console → Sua App → Store listing → Screenshots
Clique em "Adicionar imagens"
Faça upload dos 5 screenshots em PNG
```

---

## ✅ PASSO 5: UPLOAD DO AAB

### 5.1 Acessar Seção de Release
```
Play Console → Sua App → App releases → Production → Novo release
```

### 5.2 Upload do Arquivo AAB
```
Clique em "Browse files" ou arraste
Selecione: build/app/outputs/bundle/release/app-release.aab (48.2 MB)
```

### 5.3 Preencher Informações de Release

**Número de versão:**
```
1.0
```

**Build number:**
```
1
```

**Nome da release (opcional):**
```
Lançamento Inicial v1.0
```

**Notas de release (PT-BR):**
```
VERSÃO 1.0 - LANÇAMENTO OFICIAL

✨ Novo
- 20+ conversores de medidas
- Calculadoras financeiras
- 5 ferramentas exóticas
- Cotações ao vivo
- Dark mode
- Histórico completo
- 100% offline

🎯 Perfeito para: cozinha, viagem, negócios, estudo

Desenvolvido com Flutter 3.22 para máxima performance.
```

---

## ✅ PASSO 6: CONTENT RATING

### 6.1 Acessar Classificação
```
Play Console → Sua App → App content → Content rating
```

### 6.2 Preencher Questionário

**1. Conteúdo sexual ou indecente?**
```
☑ Nenhum
```

**2. Conteúdo violento?**
```
☑ Nenhum
```

**3. Linguagem ofensiva?**
```
☑ Nenhum
```

**4. Apuestas ou jogos de azar?**
```
☑ Nenhum
```

**5. Uso de álcool/tabaco?**
```
☑ Nenhum
```

**6. Drogas ilícitas?**
```
☑ Nenhum
```

**7. Compras in-app?**
```
☑ Não há compras in-app
```

**8. Publicidade?**
```
☑ Sim - Google AdMob (não personalizada)
```

**9. Coleta de dados pessoais?**
```
☑ Não coleta dados pessoais
```

### 6.3 Enviar Questionário
```
Clique em "Enviar questionário"
Receber: Certificado de classificação etária
Resultado: 3+ (Irrestrito) / PEGI 3
```

---

## ✅ PASSO 7: PRIVACIDADE E POLÍTICAS

### 7.1 Política de Privacidade
```
Play Console → Sua App → App content → Privacy policy
```

**Cole a URL:**
```
https://raw.githubusercontent.com/fabriciorjulio/conversor-de-medidas-pro/main/docs/PRIVACY_POLICY.md
```

### 7.2 Segurança e Conformidade
```
Play Console → Sua App → App content → Targeted content

Selecione:
☑ Não é direcionado para crianças
```

### 7.3 Permissões
```
Play Console → Sua App → App content → Permissions
Revise automaticamente detectadas:
- INTERNET (para cotações ao vivo) ✅
- WRITE_EXTERNAL_STORAGE (para salvar arquivos) ✅
```

---

## ✅ PASSO 8: REVISAR E PUBLICAR

### 8.1 Checklist Final

```
☑ Nome da app preenchido
☑ Descrição completa preenchida
☑ Palavras-chave adicionadas
☑ Screenshots (5) enviadas
☑ AAB (48.2 MB) enviado
☑ Notas de release preenchidas
☑ Content rating completado
☑ Política de privacidade linkada
☑ Email de suporte configurado
☑ Categoria selecionada
☑ Classificação etária definida
```

### 8.2 Clicar "Review and publish"
```
Play Console → Sua App → All releases → Production
Clique em "Review and publish"
Leia todos os requisitos
Confirme que tudo está correto
```

### 8.3 Clicar "Publish to Production"
```
⚠️ ÚLTIMO PASSO - NÃO HÁ VOLTA
Clique em "Publish to Production"
```

### 8.4 Aguardar Revisão
```
Status: "Em revisão"
Tempo: 24-48 horas
Email: Será notificado quando aprovado/rejeitado
```

---

## ⏱️ TIMELINE

| Etapa | Tempo |
|-------|-------|
| Criar conta Google Play | 5 min |
| Pagar taxa ($25) | 10 min |
| Criar app | 5 min |
| Preencher store listing | 20 min |
| Capturar screenshots | 30 min |
| Upload AAB | 5 min |
| Content rating | 10 min |
| Revisar e publicar | 5 min |
| **TOTAL** | **90 min** |

**Depois**: Aguarde 24-48h para aprovação do Google

---

## ✅ SINAIS DE SUCESSO

### App Publicada
```
✅ Status muda para "Publicada"
✅ Email de confirmação recebido
✅ App aparece em Play Store
✅ Link de download disponível
```

### URL da App
```
https://play.google.com/store/apps/details?id=com.fabriciorjulio.convertetudo
```

---

## ⚠️ MOTIVOS COMUNS DE REJEIÇÃO

```
❌ Falta política de privacidade
   → Solução: Adicionar em "Privacy policy"

❌ Permissões não justificadas
   → Solução: Documentar uso de INTERNET e STORAGE

❌ Descrição com links suspeitos
   → Solução: Remover links a sites desconhecidos

❌ Screenshots de baixa qualidade
   → Solução: Usar emulador Pixel 6 ou celular real

❌ App quebrada/não abre
   → Solução: Testar AAB em dispositivo antes

❌ Falta informações de desenvolvedor
   → Solução: Preencher todos os campos obrigatórios
```

---

## 🎉 PARABÉNS!

Se você chegou aqui, sua app está **LIVE NA PLAY STORE**! 🚀

**Próximas ações:**
1. Compartilhe o link com amigos
2. Peça reviews (classificações)
3. Monitore comentários
4. Considere atualizações futuras

---

**Desenvolvido com ❤️ - Converte Tudo**
