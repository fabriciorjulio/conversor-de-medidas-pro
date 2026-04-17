# Play Store Listing - Converte Tudo

> **Status**: revisado apos rejeicao por Metadata Policy (Version code 8 — 2026-04-16).
> Todas as violacoes identificadas foram corrigidas. Ver `METADATA_FIX_NOTES.md`.

## Dados basicos

- **Nome da app**: Converte Tudo
- **Package name**: `com.fabriciorjulio.convertetudo`
- **Categoria principal**: Ferramentas
- **Categoria secundaria**: Financas
- **Classificacao etaria**: Livre (3+)
- **Idioma principal**: Portugues (Brasil)
- **Pais primario**: Brasil
- **Monetizacao**: Gratuito com anuncios (Google AdMob)

---

## Titulo (maximo 30 caracteres)

```
Converte Tudo: Medidas e FGTS
```

(29 caracteres, sem numeros promocionais, sem emojis, sem palavras marketing)

---

## Descricao curta (maximo 80 caracteres)

```
Conversor de medidas e calculadoras financeiras brasileiras. Modo offline.
```

(74 caracteres — sem "gratis", sem "sem anuncios", sem claims falsos)

---

## Descricao completa (maximo 4000 caracteres)

```
Converte Tudo reune conversores de medidas e calculadoras financeiras
brasileiras em um unico aplicativo. Funciona offline para conversoes de
unidades e simulacoes; conexao com a internet e necessaria apenas para
cotacoes ao vivo.

CONVERSORES DE MEDIDAS

- Comprimento: metro, centimetro, quilometro, polegada, pe, jarda, milha
- Peso: quilograma, grama, libra, onca, tonelada
- Volume: litro, mililitro, galao, metro cubico, xicara
- Temperatura: Celsius, Fahrenheit, Kelvin
- Area: metro quadrado, hectare, quilometro quadrado, acre
- Velocidade: km/h, m/s, milha por hora, no
- Tempo: segundo, minuto, hora, dia, semana, mes, ano
- Dados: byte, kilobyte, megabyte, gigabyte, terabyte
- Culinaria: xicara, colher de sopa, colher de cha
- Tamanhos de roupa: tabela BR, US e EU

CALCULADORAS FINANCEIRAS

- Juros compostos com taxa configuravel e modo percentual do CDI
- Simulador de poupanca com regra SELIC
- Calculo de FGTS (deposito de 8%, TR + 3% ao ano)
- Conversor de moedas (Real, Dolar, Euro, Libra, Iene e outras)
- Conversor de criptomoedas (Bitcoin, Ethereum, BNB, Solana e outras)

FERRAMENTAS ADICIONAIS

- Consulta FIPE para carros, motos e caminhoes
- Conversao de texto, imagens e DOCX para PDF
- Conversao entre formatos de imagem (PNG, JPG, BMP)
- Conversor de commodities (soja, milho, cafe) em kg e saca

RECURSOS

- Conversoes de unidades e calculadoras funcionam sem internet
- Cotacoes ao vivo sao atualizadas quando ha conexao e ficam em cache
- Historico das ultimas conversoes
- Tema claro e escuro
- Compartilhamento de resultados
- Interface em portugues do Brasil com virgula como separador decimal

PRIVACIDADE

Nao coletamos dados pessoais. O historico e as preferencias ficam
armazenados apenas no seu dispositivo. A politica de privacidade completa
esta disponivel dentro do app e no link oficial.

PUBLICIDADE

O aplicativo exibe anuncios do Google AdMob. Voce pode gerenciar as
preferencias de publicidade nas configuracoes do Android.

AVISO

Os calculos financeiros sao apresentados para fins informativos e
educacionais e nao constituem recomendacao de investimento. Consulte um
profissional qualificado antes de tomar decisoes financeiras.

SUPORTE

Email: fabriciorjulio@gmail.com
```

---

## Tags de pesquisa (5 palavras-chave)

```
conversor de medidas
calculadora financeira
calculadora fgts
conversor de moedas
juros compostos
```

---

## Screenshots (5 obrigatorias, 1080x1920 portrait)

| # | Tela                               | Caption (max 40 chars)                    |
|---|------------------------------------|-------------------------------------------|
| 1 | Home com lista de conversores      | Conversores de medidas e financeiros      |
| 2 | Conversor de comprimento           | Conversoes de unidades em tempo real      |
| 3 | Calculadora FGTS                   | Simulador de FGTS com TR + 3 por cento    |
| 4 | Calculadora de juros com CDI       | Juros compostos com percentual do CDI     |
| 5 | Conversor de moedas                | Cotacoes atualizadas por internet         |

> **IMPORTANTE**: screenshots devem ser capturas reais do app, sem overlays
> marketing excessivos, sem texto "#1", "melhor", setas gritando etc. Um
> caption simples identificando a tela e suficiente.

---

## Feature graphic (1024x500 px)

- Fundo: gradiente azul `#0D47A1` -> `#1565C0`
- Texto principal: "Converte Tudo"
- Subtitulo: "Medidas e financeiro BR"
- Mockup discreto do aparelho com a home em paralelo
- SEM claims promocionais ("100%", "o melhor", "todos em um")

---

## Icone (512x512 px)

- Base azul (`#1976D2`) com simbolo neutro de conversao (setas duplas ↔)
- Sem texto minusculo (ilegivel em miniatura)
- Sem bandeiras, sem "grafismo promocional"
- Adaptive Icon compatible (safe area central)

---

## Classificacao de conteudo (IARC)

| Questao                                     | Resposta |
|---------------------------------------------|----------|
| Conteudo sexual ou indecente                | Nao      |
| Violencia                                   | Nao      |
| Linguagem ofensiva                          | Nao      |
| Apostas ou jogos de azar                    | Nao      |
| Alcool ou tabaco                            | Nao      |
| Drogas ilicitas                             | Nao      |
| Compras dentro do app                       | Nao      |
| Publicidade                                 | Sim (AdMob) |
| Compartilha dados pessoais                  | Nao      |
| Conteudo gerado por usuarios                | Nao      |

Resultado esperado: **Livre (3+)**.

---

## Data Safety (Seguranca dos dados)

- Dados coletados: **nenhum**
- Dados compartilhados: **nenhum pelo app**; o AdMob SDK pode receber o
  identificador de publicidade, conforme politica do Google
- Pratica de seguranca: dados armazenados localmente via
  `SharedPreferences`; usuario pode apagar via Configuracoes do Android
- Criptografia em transito: sim (apenas para cotacoes, via HTTPS)
- Usuario pode solicitar remocao: sim (desinstalar remove tudo)

---

## Links obrigatorios

| Item                           | URL                                                                                          |
|--------------------------------|----------------------------------------------------------------------------------------------|
| Email de suporte               | `fabriciorjulio@gmail.com`                                                                   |
| Website oficial                | `https://fabriciorjulio.github.io/conversor-de-medidas-pro/`                                 |
| Politica de privacidade        | `https://fabriciorjulio.github.io/conversor-de-medidas-pro/privacy-policy.html`              |

> Hospedagem do website e da privacy policy via GitHub Pages do repositorio
> `fabriciorjulio/conversor-de-medidas-pro`, pasta `docs/`.

---

## Notas da versao (What's new)

```
Correcoes e melhorias:
- Ajustes na descricao da loja em conformidade com a politica da Google Play
- Correcoes de estabilidade
- Melhorias na conversao de PDF e imagens
- Atualizacao de cotacoes em cache
```

---

## Checklist antes de enviar para revisao

- [ ] Titulo sem numeros promocionais e sem emojis
- [ ] Descricao curta nao afirma "sem anuncios" nem "gratis"
- [ ] Descricao completa sem "definitivo", "perfeito", "exoticas", "sempre gratis"
- [ ] Descricao completa sem dividers `━━━` e sem emoji-por-linha
- [ ] Descricao completa menciona AdMob e disclaimer financeiro
- [ ] Screenshots sao capturas reais (sem claims promocionais em overlay)
- [ ] Feature graphic sem claims "#1", "melhor" etc
- [ ] Icone sem texto pequeno e sem marcas de terceiros
- [ ] Privacy policy publicada em HTTPS
- [ ] Website publicado em HTTPS (GitHub Pages)
- [ ] Data Safety preenchido com "nenhum dado coletado" e AdMob declarado
- [ ] Classificacao etaria via IARC -> Livre (3+)
