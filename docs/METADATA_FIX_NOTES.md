# Metadata Fix Notes — Converte Tudo

**Rejeicao recebida**: 2026-04-16
**Version code**: 8
**Motivo**: Metadata Policy (Google Play Developer Program Policies)

## Violacoes identificadas e correcoes

### 1. Titulo

- **Antes**: `Converte Tudo - 20+ Conversores` (30 chars)
- **Problema**: o "20+" e considerado numero promocional e keyword stuffing.
  A propria frase "20+ Conversores" e redundante com o nome do app
  ("Converte Tudo" ja implica conversores).
- **Depois**: `Converte Tudo: Medidas e FGTS` (29 chars)
- **Politica**: [Store Listing and Promotion](https://support.google.com/googleplay/android-developer/answer/9898842).

### 2. Descricao curta

- **Antes**: `Medidas, moedas e financas em um app. Offline, gratis, sem anuncios.`
- **Problema critico**: "sem anuncios" e **FALSO** — o app exibe anuncios
  AdMob (ver `android/app/build.gradle.kts` linha 47). Este tipo de
  afirmacao falsa sobre a funcionalidade do app viola explicitamente a
  politica de Metadata (Misleading claims).
- **Problema secundario**: "gratis" e linguagem promocional desnecessaria.
  O proprio sistema da Play Store ja indica que o app e gratuito.
- **Depois**: `Conversor de medidas e calculadoras financeiras brasileiras. Modo offline.`

### 3. Descricao completa

Multiplos problemas acumulados:

#### 3.1 Linguagem promocional e subjetiva
- "🔄 CONVERTE TUDO - SEU CONVERSOR DEFINITIVO" → removido "DEFINITIVO"
- "o conversor definitivo" → removido
- "20+ conversores" → substituido por lista factual
- "FERRAMENTAS EXOTICAS" → "ferramentas adicionais"
- "🚀 SEM TRAVAMENTOS" → removido (performance claim)
- "PERFEITO PARA:" → removida secao
- "Sempre gratis" → removido
- "Sem versao pro" → removido

#### 3.2 Formatacao excessiva
- Removidas todas as linhas `━━━━━━━━━━━━━━━━━━━━`
- Reduzido emoji-por-linha (checkmark `✓` ou `✅` em cada item)
- Sem titulos em CAIXA ALTA inteira (exceto secoes factuais curtas)

#### 3.3 Informacoes contraditoriais e enganosas
- A descricao curta negava anuncios; a descricao longa confirmava. Isso
  era interpretado como enganoso. Agora a secao **PUBLICIDADE** esclarece
  que o app usa AdMob.
- Adicionado disclaimer financeiro: os calculos sao para fins
  informativos e nao sao recomendacao de investimento.

#### 3.4 Testemunhos e claims nao atribuidos
- O FAQ ("E realmente gratis? R: Sim!") funcionava como auto-atestado
  promocional. Substituido por informacoes factuais sobre uso do app.

#### 3.5 Especificacoes incorretas
- "Tamanho: 48 MB" → removido (tamanho pode variar por arquitetura e nao
  deve ser afirmado no texto da loja; a Play Store mostra o tamanho real)
- "100+ use cases" → removido (claim nao verificavel pelo revisor)

### 4. Notas de lancamento (What's new)

- Antes: texto promocional com emojis e "Obrigado por usar Converte Tudo! 🎉"
- Depois: bullets factuais curtos descrevendo as mudancas reais da versao.

### 5. Screenshots / Feature graphic / Icone

**Regra geral**: todas as imagens devem mostrar o app real, sem texto
promocional sobreposto como "#1", "melhor", "o conversor que voce
precisa", etc. Um caption simples identificando a tela e suficiente.

Se o icone atual tiver texto ilegivel em miniatura, regerar conforme
especificacao em `PLAY_STORE_LISTING.md`.

## Apelacao vs reenvio

Recomendacao: **corrigir e reenviar**, sem apelacao. A apelacao deveria
ser usada apenas quando o desenvolvedor discorda da interpretacao da
politica. Neste caso, ha pelo menos uma violacao objetiva inegavel
("sem anuncios" sendo falso), portanto a apelacao seria rejeitada.

## Passos para reenvio

1. Atualizar a listagem no Play Console (`Store presence → Main store listing`)
   com o texto de `DESCRICOES_PRONTAS.txt`
2. Substituir o graphic/screenshots se contiverem overlays promocionais
3. Subir um novo Version code (incrementar `versionCode` no
   `pubspec.yaml` `version: X.Y.Z+N`) — mesmo que nada do codigo tenha
   mudado, o Play Console exige novo build para reanalise
4. Em `Publishing overview`, clicar `Send X changes for review`
5. Aguardar 24-72h para resposta
