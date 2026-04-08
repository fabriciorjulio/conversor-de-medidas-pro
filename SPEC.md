# Converte Tudo
### Documento de Especificacao Tecnica e Funcional — v1.3
**Data:** 07/04/2026
**Repositorio:** `fabriciorjulio/conversor-de-medidas-pro`
**Score da avaliacao AppFactory.AI:** 81/100 — Aprovado

---

## Sumario

1. [Visao Geral](#1-visao-geral)
2. [Arquitetura Tecnica](#2-arquitetura-tecnica)
3. [Funcionalidades](#3-funcionalidades)
   - 3.1 [Tela Principal](#31-tela-principal-home-screen)
   - 3.2 [Conversor de Unidades](#32-conversor-de-unidades)
   - 3.3 [Categorias de Conversao](#33-categorias-de-conversao)
   - 3.4 [Calculadoras Financeiras](#34-calculadoras-financeiras-brasileiras)
   - 3.5 [Historico](#35-historico)
4. [Design System](#4-design-system)
5. [Monetizacao](#5-monetizacao)
6. [Fluxo de Navegacao](#6-fluxo-de-navegacao)
7. [Seguranca e Compliance](#7-seguranca-e-compliance)
8. [Acessibilidade](#8-acessibilidade)
9. [Configuracao de Plataforma](#9-configuracao-de-plataforma)
10. [Estrutura de Arquivos](#10-estrutura-de-arquivos)
11. [ASO — App Store Optimization](#11-aso--app-store-optimization)
12. [Estado Atual do Projeto](#12-estado-atual-do-projeto)
13. [Proximas Evolucoes Sugeridas](#13-proximas-evolucoes-sugeridas)

---

## 1. Visao Geral

| | |
|---|---|
| **Nome** | Converte Tudo |
| **Nome na loja (ASO)** | Converte Tudo: Medidas & FGTS |
| **Plataformas** | Android e iOS |
| **Orientacao** | Portrait only (travado programaticamente + Info.plist) |
| **Modelo de negocio** | Freemium — monetizacao via AdMob banner |
| **Publico-alvo** | Brasileiro em geral — estudantes, profissionais de obra, investidores iniciantes, trabalhadores |
| **Proposta de valor** | App all-in-one de conversao de unidades + calculadoras financeiras BR com legislacao correta, 100% offline |
| **Codebase** | 19 arquivos Dart, 4.791 linhas |
| **Versao** | 1.0.0+1 |

---

## 2. Arquitetura Tecnica

| Componente | Especificacao |
|---|---|
| Framework | Flutter 3.22+ |
| Linguagem | Dart SDK >= 3.0 < 4.0 |
| Gerenciamento de estado | Provider (ChangeNotifier) |
| Persistencia local | SharedPreferences |
| Requisicoes HTTP | package `http ^1.2.2` |
| Publicidade | Google Mobile Ads SDK (AdMob) — banner |
| Tipografia | Google Fonts — Inter |
| Compartilhamento | share_plus |
| Formatacao de datas | intl (locale pt_BR) |
| Design system | Material Design 3 com paleta customizada por categoria |
| Arquitetura de pastas | Feature-first |
| Minificacao/Obfuscation | R8 + ProGuard habilitados no release |
| CI/CD | GitHub Actions — build, sign, upload Play Store (internal track) |

### Dependencias (`pubspec.yaml`)

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.0
  google_mobile_ads: ^5.1.0
  shared_preferences: ^2.3.0
  google_fonts: ^6.2.1
  share_plus: ^7.2.2
  intl: ^0.19.0
  http: ^1.2.2

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^3.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.0
```

---

## 3. Funcionalidades

### 3.0 Tela de Boas-Vindas (Welcome Screen)

Exibida apenas no **primeiro acesso** (flag `welcome_seen` em SharedPreferences).

- Gradiente 4 tons de azul com **particulas flutuantes** animadas (CustomPainter)
- Logo com animacao **elastic bounce** (800ms)
- Titulo "Converte Tudo" + subtitulo com **slide + fade** stagger (900ms)
- 3 **feature pills** com entrada escalonada:
  - 📏 10 categorias de conversao
  - 💵 Cotacoes ao vivo — moedas e cripto
  - 🏦 Calculadoras BR — FGTS · Juros · Poupanca
- Botao **"Comecar"** com pulse sutil + seta
- Badge **"Funciona 100% offline"**
- Transicao fade (500ms) para a Home Screen

---

### 3.1 Tela Principal (Home Screen)

- **Header redesenhado**: logo mini ⇄, nome, badge "Offline", 3 stat chips (10 medidas, Cotacoes, FGTS·CDI)
- Gradiente 3 tons (`#0A3D91` -> `#0D47A1` -> `#1976D2`), borderRadius 28
- Card de **ultima conversao** com acesso rapido — exibido apos o primeiro uso
- Duas secoes com rotulos:
  - **MEDIDAS** — 8 categorias de conversao
  - **FINANCEIRO** 🇧🇷 com badge **"NOVO"** (laranja) — 2 categorias de conversao + 3 calculadoras
- Lista agrupada estilo iOS com emoji, nome, exemplos de unidades, chevron
- Botao de acesso ao **Historico** com contador dinamico
- Transicao animada slide 250ms para todas as telas filhas

---

### 3.2 Conversor de Unidades

Tela compartilhada por todas as 10 categorias de conversao.

**Comportamento:**
- Campo de entrada numerico com suporte a virgula (padrao BR)
- Resultado calculado em tempo real conforme digitacao
- Botao de **swap** (44x44dp, acessivel) com `RotationTransition` e haptic feedback
- Seletor de unidade via modal bottom sheet estilo iOS com badge "Ativo"
- `AnimatedSwitcher` com fade + slide no resultado
- Botao **Compartilhar resultado** aparece apos primeiro resultado valido
- Dica: *"Toque na unidade para trocar"*

**Precisao adaptativa:**

| Condicao | Formato |
|---|---|
| Valor normal | 2 casas decimais |
| Valor < 1 | 4 casas decimais |
| Valor < 0,01 | 8 casas decimais (ex: BTC) |
| Valor > 10^12 ou < 10^-6 | Notacao cientifica |

**Motor de conversao:**
```
base = input / fromFactor
resultado = base * toFactor
```
Temperatura: formulas diretas Celsius <-> Fahrenheit <-> Kelvin.

---

### 3.3 Categorias de Conversao

#### Medidas (8)

| Emoji | Categoria | Cor | Unidades |
|---|---|---|---|
| 📏 | Comprimento | `#1565C0` | metro, centimetro, milimetro, quilometro, polegada, pe, jarda, milha |
| ⚖️ | Peso | `#2E7D32` | quilograma, grama, miligrama, tonelada, libra, onca (oz), arroba |
| 🫙 | Volume | `#0277BD` | litro, mililitro, metro cubico, centimetro cubico, galao (US), onca liquida (fl oz), xicara |
| 🌡️ | Temperatura | `#BF360C` | Celsius, Fahrenheit, Kelvin |
| 📐 | Area | `#6A1B9A` | metro², centimetro², quilometro², milimetro², pe², polegada², hectare, acre |
| 💨 | Velocidade | `#00695C` | km/h, m/s, milha por hora, no |
| 💾 | Dados Digitais | `#283593` | bit, byte, KB, MB, GB, TB, PB |
| ⏱️ | Tempo | `#37474F` | segundo, minuto, hora, dia, semana, mes, ano |

#### Financeiro (2 conversores + 3 calculadoras)

| Emoji | Categoria | Cor | Unidades |
|---|---|---|---|
| 💵 | Moedas | `#1B5E20` | BRL, USD, EUR, GBP, JPY, CHF, CAD, AUD |
| ₿ | Criptomoedas | `#E65100` | BRL, USDT, BTC, ETH, BNB, SOL, XRP |

**Cotacoes ao vivo:**
- Fonte: API publica **AwesomeAPI** (`economia.awesomeapi.com.br`) — sem chave
- Atualizacao: ao abrir o app, em background, sem bloquear UI
- Cache local **6 horas** (SharedPreferences)
- Fallback: taxas-padrao embutidas no codigo — app funciona 100% offline

---

### 3.4 Calculadoras Financeiras Brasileiras

Todas as calculadoras incluem:
- **Disclaimer legal** no rodape: *"Valores simulados para fins educacionais. Nao constitui recomendacao de investimento. Consulte um profissional antes de investir."*
- **Protecao contra overflow**: capital > 10^15, periodo > 1200 meses, verificacao `isInfinite`/`isNaN`

---

#### 💸 Calculadora de Juros

**Campos de entrada:**

| Campo | Detalhe |
|---|---|
| Capital inicial | Campo numerico + chips rapidos: R$ 1K / R$ 5K / R$ 10K / R$ 50K |
| Regime | Toggle: **Juros Simples** / **Juros Compostos** |
| Taxa | Dois modos alternáveis (ver abaixo) |
| Periodo | Campo numerico + toggle meses/anos + chips: 6M / 1 ano / 2 anos / 5 anos |

**Modo Taxa Manual:**
- Valor digitado + toggle **a.m.** / **a.a.**
- Conversao automatica: `r_m = (1 + r_a)^(1/12) - 1`

**Modo % do CDI:**
- Campo editavel com taxa CDI atual (default 13,65% a.a.)
- Nota: *"Taxa CDI: valor de referencia. Edite para a taxa vigente."*
- Slider de **50% a 150%** do CDI (divisoes de 0,5%, thumb 14dp + overlay 24dp)
- Preset chips: **80%** / **100%** / **110%** / **120%** (min 44dp touch target)
- Display em tempo real: `"100% do CDI ≈ 13,65% a.a."`
- `AnimatedCrossFade` entre os dois modos (220ms)

**Formulas:**
```
Simples:     M = P * (1 + r * n)
Compostos:   M = P * (1 + r)^n
CDI efetiva: taxa = CDI * (% / 100)
Anual -> mensal: r_m = (1 + r_a)^(1/12) - 1
Efetiva anual:   r_a = (1 + r_m)^12 - 1
```

**Resultados:**
- Montante final (destaque 28px) com badge `+X.X%`
- **Barra visual** capital (azul escuro) vs juros (azul claro) com percentuais e legenda
- Juros ganhos
- Taxa efetiva anual
- Capital investido
- `AnimatedSize` 300ms para animacao de aparecimento

**Dica informativa:**
*"CDBs geralmente rendem 100-110% do CDI. LCI/LCA costumam render 80-92% do CDI com isencao de IR para PF."*

---

#### 🐷 Rendimento Poupanca

**Campos:** Valor aplicado (R$), Taxa SELIC atual (editavel, default 10,75% a.a.), Periodo (meses).

**Regra (Lei 8.177/1991):**

| Condicao | Rendimento mensal |
|---|---|
| SELIC > 8,5% a.a. | 0,5% a.m. + TR |
| SELIC <= 8,5% a.a. | 70% da SELIC / 12 + TR |

TR ≈ 0%. Capitalizacao composta mensal.

**Resultados:** Saldo final, total rendido, rendimento 1° mes, rentabilidade anual.

**Nota:** *"Taxa SELIC e valor de referencia — edite para a taxa vigente."*

---

#### 🏦 Calculadora de FGTS

**Campos:** Salario bruto (R$), Meses trabalhados (max 600).

**Formulas (Art. 15 Lei 8.036/1990):**
```
Deposito mensal = salario * 8%
Taxa FGTS       = TR + 3% a.a. / 12 (TR ≈ 0%)
Saldo           = Somatorio capitalizado mes a mes
Multa           = saldo * 40%
```

**Resultados:** Saldo FGTS com juros, deposito mensal, total depositado, multa rescisoria 40%.

---

### 3.5 Historico

- Lista das **ultimas 10 conversoes** persistida no dispositivo
- Emoji da categoria, valor de/para, unidades, timestamp relativo
- Timestamps: "agora", "ha 3 min", "ha 2h", "ontem", dd/MM HH:mm
- **Swipe para deletar** item individual
- Botao **"Limpar tudo"** com dialog de confirmacao
- Estado vazio com ilustracao e mensagem orientativa

---

## 4. Design System

### Paleta por categoria

| Categoria | Primaria | Fundo claro | Gradiente |
|---|---|---|---|
| Comprimento | `#1565C0` | `#E8F0FE` | -> `#42A5F5` |
| Peso | `#2E7D32` | `#E8F5E9` | -> `#66BB6A` |
| Volume | `#0277BD` | `#E1F5FE` | -> `#26C6DA` |
| Temperatura | `#BF360C` | `#FBE9E7` | -> `#FF7043` |
| Area | `#6A1B9A` | `#F3E5F5` | -> `#BA68C8` |
| Velocidade | `#00695C` | `#E0F2F1` | -> `#4DB6AC` |
| Dados | `#283593` | `#E8EAF6` | -> `#5C6BC0` |
| Tempo | `#37474F` | `#ECEFF1` | -> `#78909C` |
| Moedas | `#1B5E20` | `#E8F5E9` | -> `#4CAF50` |
| Cripto | `#E65100` | `#FBE9E7` | -> `#FF9800` |
| Fundo global | `#F2F4F7` | — | — |

### Tipografia

| Uso | Tamanho | Peso |
|---|---|---|
| Input / resultado principal | 34-38px | 800 |
| Titulos de secao | 22px | 700 |
| Label de categoria | 15px | 600 |
| Subtitulo / hint | 12-13px | 400-500 |
| Rotulos de campo | 10-11px | 700 (letter-spacing 1.2) |

Familia: **Inter** (Google Fonts). Letter-spacing valores grandes: -0.5.

### Componentes padrao

| Componente | Especificacao |
|---|---|
| Cards | Branco, `borderRadius: 20`, `boxShadow` sutil (6% preto, blur 16) |
| Faixa de identidade | Gradiente 3px no topo de cada tela filha |
| AppBar | Cor da categoria, sem elevacao, titulo centralizado com emoji |
| Bottom sheet | Drag handle, borderRadius 24, lista com badge "Ativo" |
| Botoes de unidade | Pill colorido com ↓, min 44dp height |
| Toggle segmentado | Animacao suave, fundo `#F2F4F7` |
| Slider | Track 4px, thumb 14dp, overlay 24dp |
| Disclaimer | Fundo `#FFF8E1`, borda `#FFE082`, icone warning ambar |

### Animacoes

| Elemento | Tipo | Duracao |
|---|---|---|
| Welcome logo | `Tween` scale + opacity, `Curves.elasticOut` | 800ms |
| Welcome features | Stagger `SlideTransition` + `FadeTransition` | 900ms |
| Welcome CTA | Pulse `AnimationController` repeat | 1500ms |
| Welcome particulas | `CustomPainter` com sin/cos | 6000ms loop |
| Welcome → Home | `FadeTransition` | 500ms |
| Resultado conversor | `AnimatedSwitcher` + `SlideTransition` | 250ms |
| Botao swap | `RotationTransition` | 300ms |
| Card resultado (calcs) | `AnimatedSize` | 300ms |
| Preset chips CDI | `AnimatedContainer` | 180ms |
| Toggle modo taxa | `AnimatedCrossFade` | 220ms |
| Transicao de tela | `SlideTransition` (direita -> esquerda) | 250ms |

### Haptic Feedback
- Swap de unidades: `lightImpact`
- Selecao de unidade no picker: `selectionClick`
- Chips rapidos (capital, periodo, CDI preset): `selectionClick`

---

## 5. Monetizacao

- **AdMob banner** fixo no rodape da tela do conversor (nao aparece nas calculadoras)
- Inicializacao condicional: somente Android e iOS
- IDs de teste em dev; producao via `--dart-define=ADMOB_APP_ID`
- Interstitial counter na arquitetura (trigger a cada 5 interacoes) — pronto para ativar via feature flag
- AdMob app ID injetado no `AndroidManifest.xml` via `${ADMOB_APP_ID}`

---

## 6. Fluxo de Navegacao

```
WelcomeScreen               <- primeiro acesso (animada, salva flag)
|
v
HomeScreen
|
+-- ConverterScreen          <- todas as 10 categorias
|   +-- UnitPickerSheet      <- modal bottom sheet
|
+-- JurosScreen              <- calculadora juros + CDI
+-- PoupancaScreen           <- calculadora poupanca
+-- FgtsScreen               <- calculadora FGTS
|
+-- HistoryScreen            <- historico de conversoes
```

Todas as transicoes: `PageRouteBuilder` com `SlideTransition` (250ms, `Curves.easeOut`).

---

## 7. Seguranca e Compliance

### OWASP Mobile Top 10

| # | Item | Status |
|---|---|---|
| M1 | Improper Credential Usage | OK — API publica sem chave |
| M2 | Supply Chain Security | OK — dependencias versionadas no pubspec.lock |
| M3 | Insecure Authentication | N/A — sem auth |
| M4 | Input Validation | OK — `tryParse()` em todos os campos + overflow protection |
| M5 | Insecure Communication | OK — HTTPS only (AwesomeAPI) |
| M6 | Privacy Controls | OK — nenhum dado pessoal coletado |
| M7 | Binary Protections | OK — R8 + ProGuard habilitados no release |
| M8 | Security Misconfiguration | OK — apenas permissao INTERNET |
| M9 | Data Storage | OK — SharedPreferences com dados publicos apenas |
| M10 | Cryptography | N/A |

### Compliance Legal

| Requisito | Status |
|---|---|
| Privacy Policy (HTTPS) | `docs/privacy-policy.html` — pronta para GitHub Pages |
| Terms of Service | `docs/terms-of-service.html` — pronta para GitHub Pages |
| LGPD (Lei 13.709/2018) | OK — nenhum dado pessoal coletado |
| Disclaimer financeiro | OK — em todas as 3 telas de calculadora |
| Linguagem ASO | "simulador", "educacional", "cotacao informativa" — sem "recomendacao" |
| Permissoes Android | Apenas `INTERNET` e `ACCESS_NETWORK_STATE` |

### Dados e Privacidade

- Nenhum dado pessoal coletado ou transmitido
- Cotacoes via API publica AwesomeAPI — sem autenticacao
- Historico exclusivamente local (SharedPreferences)
- Sem login, sem cadastro, sem analytics, sem rastreamento

---

## 8. Acessibilidade

| Item | Implementacao |
|---|---|
| `Semantics` label | Botao swap ("Inverter unidades"), botoes de unidade ("Selecionar unidade: X") |
| Touch targets | Botoes >= 44dp, swap button 44x44dp, unit pill minHeight 44dp |
| Slider thumb | 14dp radius + 24dp overlay (48dp area total) |
| Chips | Padding minimo 14x10dp, area de toque >= 44dp |
| Orientacao | Travada em portrait (programatico + Info.plist + manifest.json) |

---

## 9. Configuracao de Plataforma

### Android

| Arquivo | Configuracao |
|---|---|
| `android/app/build.gradle.kts` | namespace `com.example.conversor_de_medidas_pro`, Java 17, R8 + ProGuard no release |
| `android/app/proguard-rules.pro` | Keep rules para Flutter e Google Mobile Ads |
| `AndroidManifest.xml` | Label "Converte Tudo", permissoes INTERNET + ACCESS_NETWORK_STATE, AdMob via `${ADMOB_APP_ID}` |

### iOS

| Arquivo | Configuracao |
|---|---|
| `Info.plist` | Display name "Converte Tudo", portrait only, scene manifest |

### Web (PWA)

| Arquivo | Configuracao |
|---|---|
| `web/manifest.json` | Nome "Converte Tudo", short "Converte Tudo", theme `#0D47A1`, background `#F2F4F7`, lang pt-BR, categories utilities + finance, portrait |

### CI/CD

| Arquivo | Configuracao |
|---|---|
| `.github/workflows/build_publish.yml` | Flutter 3.22.0, build appbundle, sign com keystore (secrets), upload Play Store internal track |

---

## 10. Estrutura de Arquivos

```
conversor-de-medidas-pro/
|
+-- docs/
|   +-- privacy-policy.html         <- Privacy Policy (GitHub Pages)
|   +-- terms-of-service.html       <- Terms of Service (GitHub Pages)
|   +-- ASO.md                      <- textos ASO para Play Store e App Store
|
+-- lib/
|   +-- main.dart                   <- init, providers, portrait lock, fetch cotacoes, welcome check
|   |
|   +-- core/
|   |   +-- ads/ad_manager.dart                    <- gerenciador AdMob (98 linhas)
|   |   +-- constants/units.dart                   <- fatores de conversao 10 categorias (112 linhas)
|   |   +-- services/currency_service.dart         <- cotacoes ao vivo + cache 6h (113 linhas)
|   |   +-- theme/app_theme.dart                   <- ThemeData Material 3, Inter (116 linhas)
|   |
|   +-- features/
|   |   +-- home/
|   |   |   +-- models/conversion.dart             <- enum MeasurementCategory + ConversionResult (154 linhas)
|   |   |   +-- providers/converter_provider.dart   <- estado, motor de calculo, historico (239 linhas)
|   |   |   +-- screens/welcome_screen.dart         <- tela boas-vindas animada, 1o acesso (419 linhas)
|   |   |   +-- screens/home_screen.dart            <- tela principal, header + 2 secoes (721 linhas)
|   |   |
|   |   +-- converter/
|   |   |   +-- screens/converter_screen.dart       <- tela de conversao universal (502 linhas)
|   |   |
|   |   +-- history/
|   |   |   +-- screens/history_screen.dart         <- historico swipe-to-delete (280 linhas)
|   |   |
|   |   +-- financial/
|   |       +-- screens/juros_screen.dart           <- calculadora juros + CDI (943 linhas)
|   |       +-- screens/poupanca_screen.dart        <- simulacao poupanca (187 linhas)
|   |       +-- screens/fgts_screen.dart            <- calculadora FGTS (168 linhas)
|   |       +-- widgets/financial_widgets.dart      <- componentes compartilhados (443 linhas)
|   |
|   +-- shared/widgets/
|       +-- banner_ad_widget.dart                   <- banner AdMob com fallback (49 linhas)
|       +-- unit_picker_sheet.dart                  <- modal selecao de unidade (192 linhas)
|
+-- test/
|   +-- converter_provider_test.dart                <- 12 testes unitarios (116 linhas)
|   +-- widget_test.dart                            <- placeholder (11 linhas)
|
+-- android/
|   +-- app/build.gradle.kts                        <- R8, ProGuard, Java 17
|   +-- app/proguard-rules.pro                      <- keep rules Flutter + AdMob
|   +-- app/src/main/AndroidManifest.xml            <- permissoes, AdMob, portrait
|
+-- ios/
|   +-- Runner/Info.plist                           <- portrait only, display name
|
+-- web/
|   +-- manifest.json                               <- PWA config, pt-BR
|
+-- .github/workflows/
|   +-- build_publish.yml                           <- CI/CD Play Store
|
+-- pubspec.yaml                                    <- dependencias, versao 1.0.0+1
+-- SPEC.md                                         <- este documento
```

**Total: 19 arquivos Dart, 4.791 linhas de codigo**

---

## 11. ASO — App Store Optimization

### Google Play Store

| Elemento | Valor |
|---|---|
| **Titulo** (30 chars) | `Converte Tudo: Medidas & FGTS` |
| **Short description** (80 chars) | `Converta medidas e simule FGTS, Poupanca e Juros com CDI. 100% offline.` |
| **Categoria** | Ferramentas (Tools) |
| **Keywords** | conversor medidas, calculadora fgts, calculadora juros compostos, conversor moedas, poupanca simulador, conversor unidades, calculadora cdi, conversor temperatura, conversor area, calculadora financeira, conversor offline |

### Apple App Store

| Elemento | Valor |
|---|---|
| **Nome** (30 chars) | `Converte Tudo: Medidas & FGTS` |
| **Subtitulo** (30 chars) | `Conversoes + Financeiro BR` |
| **Keywords** (100 chars) | `conversor,medidas,fgts,juros,cdi,poupanca,moedas,cripto,calculadora,offline,unidades,temperatura` |

### Screenshots (5 obrigatorias)

| # | Caption | Tela | Beneficio |
|---|---|---|---|
| 1 | Converta qualquer medida em 1 toque | Conversor comprimento com resultado | Velocidade + simplicidade |
| 2 | Simule seu FGTS com a lei correta | Calculadora FGTS com resultado | Confiabilidade legal |
| 3 | Juros compostos + CDI em tempo real | Calculadora Juros com barra visual | Profundidade financeira |
| 4 | Cotacoes atualizadas automaticamente | Conversor de moedas | Dados em tempo real |
| 5 | Funciona 100% offline | Home screen com badge Offline | Confiabilidade |

### Icone (512x512)

Fundo gradiente azul (#0D47A1 -> #1976D2), setas de conversao estilizadas em branco, sem texto pequeno.

### Feature Graphic (1024x500)

Fundo azul escuro, headline "Converte Tudo: Medidas + Financeiro BR", subheadline "FGTS - Poupanca - Juros - CDI - 100% Offline", mockup celular, badge BR.

*Full description completa no arquivo `docs/ASO.md`.*

---

## 12. Estado Atual do Projeto

### Funcionalidades

| Entregavel | Status |
|---|---|
| Tela de boas-vindas animada (1o acesso) | ✅ |
| Header dinamico com stat chips | ✅ |
| 8 categorias de medidas (c/ unidades BR↔US completas) | ✅ |
| Unidades americanas: jarda, milha, onca, fl oz, xicara, arroba | ✅ |
| Defaults BR↔US (metro→pe, kg→libra, litro→galao, km/h→mph) | ✅ |
| 2 categorias financeiras (moedas + cripto) | ✅ |
| Cotacoes ao vivo com cache 6h | ✅ |
| Calculadora de Juros (simples, compostos, CDI) | ✅ |
| Calculadora de Poupanca | ✅ |
| Calculadora de FGTS | ✅ |
| Historico persistido com swipe-to-delete | ✅ |
| AdMob banner com fallback | ✅ |
| Design system com animacoes e haptics | ✅ |

### Qualidade

| Metrica | Status |
|---|---|
| `flutter analyze` | ✅ 0 erros, 0 warnings |
| Testes unitarios | ✅ 12 testes passando |
| OWASP Mobile Top 10 | ✅ 0 issues criticas |
| Acessibilidade (Semantics) | ✅ Botoes e chips |
| Touch targets >= 44dp | ✅ |
| Overflow protection | ✅ Todas as calculadoras |
| Orientacao portrait | ✅ Dart + iOS + Web |

### Compliance

| Requisito | Status |
|---|---|
| Privacy Policy | ✅ `docs/privacy-policy.html` |
| Terms of Service | ✅ `docs/terms-of-service.html` |
| Disclaimer financeiro | ✅ Todas as 3 calculadoras |
| LGPD | ✅ Nenhum dado pessoal |
| R8 + ProGuard | ✅ Habilitados no release |
| ASO completo | ✅ `docs/ASO.md` |

### Pendente para publicacao

| Item | Esforco |
|---|---|
| Hospedar `docs/` no GitHub Pages | 5 min |
| Gerar 5 screenshots reais no emulador | 1h |
| Criar icone 512x512 e feature graphic 1024x500 | 1h |
| `google-services.json` + IDs AdMob producao | 30 min |
| Signing key Android (keystore) | 30 min |
| Apple Developer certificate + provisioning profile | 1h |
| Testar em device fisico de entrada (Redmi A3 / Samsung A15) | 2h |

---

## 13. Proximas Evolucoes Sugeridas

### Curto prazo (v1.1 — primeiros 30 dias)

| Feature | Motivacao |
|---|---|
| Dark mode | 60%+ dos usuarios Android BR usam dark mode |
| Separar ConverterProvider em 3 providers | Responsabilidade unica (conversao, historico, cotacoes) |
| Tooltip contextual para calculadoras | Risco de usuario nunca descobrir a secao financeira (welcome screen parcialmente mitiga) |
| Verificar APK size < 15MB | Font subsetting Inter se necessario |
| Instrumentar metricas D1, D7, session length | Definir antes: D1 >= 25%, D7 >= 12% |

### Medio prazo (v2 — 60-90 dias)

| Feature | Motivacao |
|---|---|
| API BCB para CDI/SELIC em tempo real | Eliminar taxa default desatualizada |
| Card "revisita financeira" na home | Trigger de retorno: "Sua simulacao de R$ X rendeu R$ Y" |
| Calculadora de parcelas (SAC + Price) | Top request em apps financeiros BR |
| Calculadora de desconto | A vista vs parcelado |
| Calculadora de gorjeta | Dividir conta entre pessoas |
| Migrar para Hive/Isar | Historico ilimitado para versao premium |

### Longo prazo

| Feature | Motivacao |
|---|---|
| Versao premium | Remocao de anuncios + historico ilimitado + exportar PDF |
| Widget tela inicial Android/iOS | Ultima conversao ou cotacao do dia |
| Notificacao diaria opcional | Cotacao do dolar como trigger de retorno |
| Simulador IRPF simplificado | Faixas de imposto |
| Comparador de investimentos | Poupanca vs CDB vs LCI/LCA vs Tesouro Direto |
| Conversor de receitas expandido | Colher de sopa, colher de cha, copo americano (xicara ja implementada) |

---

### KPIs de Sucesso

| Metrica | Meta |
|---|---|
| Instalacoes organicas (30 dias) | >= 500 |
| Rating medio | >= 4.5 |
| D1 retention | >= 25% |
| D7 retention | >= 12% |
| Session length | >= 90s |
| APK size | < 15MB |
| Cold start | < 2s (Redmi A3) |
| Crashes (primeiros 1000 installs) | 0 |
| Rejeicoes Play Store | 0 |

---

*Documento gerado em 07/04/2026.*
*Repositorio: `fabriciorjulio/conversor-de-medidas-pro`*
*Avaliacao AppFactory.AI: 81/100 — Aprovado*
