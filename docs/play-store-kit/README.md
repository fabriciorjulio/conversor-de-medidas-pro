# Kit de publicacao Play Store — Converte Tudo

Tudo o que voce precisa para publicar a versao `2.3.2+9` do Converte
Tudo na Google Play Store e reverter a rejeicao por Metadata Policy.

---

## Ordem sugerida de uso

1. **Gerar o AAB** — [`5-build/COMO_GERAR_AAB.md`](5-build/COMO_GERAR_AAB.md)
   (precisa da maquina com o keystore)
2. **Atualizar os textos da listagem** — arquivos em [`1-textos/`](1-textos/)
3. **Subir as imagens** — arquivos em [`2-visuais/`](2-visuais/)
4. **Colocar links de privacidade** — arquivos em [`3-politicas/`](3-politicas/)
5. **Preencher os formularios** — arquivos em [`4-formularios/`](4-formularios/)
6. **Enviar para revisao** — checklist mais abaixo neste arquivo

---

## Conteudo da pasta

```
play-store-kit/
├── README.md                          (este arquivo)
├── 1-textos/
│   ├── 01-titulo.txt                  (30 chars max)
│   ├── 02-descricao-curta.txt         (80 chars max)
│   ├── 03-descricao-completa.txt      (4000 chars max)
│   ├── 04-notas-versao.txt            (release notes, 500 chars)
│   ├── 05-categoria-e-tags.txt
│   └── 06-contato.txt
├── 2-visuais/
│   ├── icone-512.png                  (512x512, icone do app)
│   ├── feature-graphic-1024x500.png   (banner da listagem)
│   └── screenshots/                   (5 screenshots 1080x1920)
│       ├── 01-comprimento.png
│       ├── 02-moedas.png
│       ├── 03-juros.png
│       ├── 04-fgts.png
│       └── 05-poupanca.png
├── 3-politicas/
│   ├── privacy-policy.html            (ja hospedada via GitHub Pages)
│   └── terms-of-service.html
├── 4-formularios/
│   ├── data-safety.md                 (respostas do Data Safety)
│   └── content-rating.md              (respostas do Content Rating)
└── 5-build/
    └── COMO_GERAR_AAB.md              (passo-a-passo do build assinado)
```

---

## Dados rapidos para copiar/colar

**Titulo** (30 chars): `Converte Tudo: Medidas e FGTS`

**Descricao curta** (80 chars): `Conversor de medidas e calculadoras financeiras brasileiras. Modo offline.`

**Categoria**: Ferramentas (principal) · Financas (secundaria)

**Classificacao**: Livre (3+)

**Email de suporte**: `fabriciorjulio@gmail.com`

**Site oficial**: https://fabriciorjulio.github.io/conversor-de-medidas-pro/

**Politica de Privacidade**:
https://fabriciorjulio.github.io/conversor-de-medidas-pro/privacy-policy.html

**Termos de uso**:
https://fabriciorjulio.github.io/conversor-de-medidas-pro/terms-of-service.html

---

## Checklist de envio

### Antes de enviar

- [ ] AAB gerado e assinado com o keystore original
- [ ] Version code incrementado para `9` (ou maior)
- [ ] SHA-256 do AAB bate com o "Upload certificate" do Play Console

### Listagem da loja (Main store listing)

- [ ] Titulo colado de `1-textos/01-titulo.txt`
- [ ] Descricao curta colada de `1-textos/02-descricao-curta.txt`
- [ ] Descricao completa colada de `1-textos/03-descricao-completa.txt`
- [ ] Icone 512x512 carregado (`2-visuais/icone-512.png`)
- [ ] Feature graphic carregada (`2-visuais/feature-graphic-1024x500.png`)
- [ ] 5 screenshots carregadas (`2-visuais/screenshots/`)
- [ ] Categoria principal: Ferramentas
- [ ] Categoria secundaria: Financas
- [ ] Tags de pesquisa de `1-textos/05-categoria-e-tags.txt`
- [ ] Email de suporte
- [ ] Site oficial
- [ ] URL da politica de privacidade

### App content (menu lateral)

- [ ] **Privacy policy**: URL colada
- [ ] **App access**: "All functionality is available without special access"
- [ ] **Ads**: YES (o app contem anuncios AdMob)
- [ ] **Content rating**: questionario preenchido (`4-formularios/content-rating.md`)
- [ ] **Target audience**: "13 and older" (evitar sensibilidades do publico infantil)
- [ ] **Data safety**: formulario preenchido (`4-formularios/data-safety.md`)
- [ ] **Government apps**: NO
- [ ] **Financial features**: declarar calculadoras FGTS/juros/poupanca
  como "ferramentas educacionais" (nao executamos operacoes financeiras)

### Release

- [ ] AAB carregado em Production → Create new release
- [ ] Release notes colada de `1-textos/04-notas-versao.txt`

### Submissao final

- [ ] Publishing overview → `Send X changes for review`

---

## O que foi corrigido em relacao ao build `8` rejeitado

| Violacao original                     | Correcao aplicada                  |
|---------------------------------------|------------------------------------|
| Titulo com "20+ Conversores"          | Renomeado sem numero promocional   |
| "sem anuncios" (FALSO — tem AdMob)    | Removido da descricao curta        |
| "gratis"                              | Removido (redundante)              |
| "DEFINITIVO", "PERFEITO", "SEM TRAVAMENTOS" | Removidos (linguagem promocional) |
| Dividers "━━━"                        | Removidos                          |
| "20+ conversores" in-app (chips)      | Renomeado para "Conversores"       |
| "Funciona 100% offline" in-app        | "Conversoes funcionam offline"     |
| "100% offline" (pubspec / PWA)        | Removido / reescrito               |
| FAQ promocional "E realmente gratis?" | Removido                           |
| "Tamanho: 48 MB" na descricao         | Removido                           |
| Screenshots com overlay tipo "#1"     | Instrucao de nao usar overlays     |

Detalhes em [`../METADATA_FIX_NOTES.md`](../METADATA_FIX_NOTES.md).

---

## Tempo esperado de revisao

24–72 horas uteis apos o `Send for review`. Se for rejeitado novamente,
o motivo exato aparecera no email de notificacao — copie aqui e podemos
corrigir pontualmente.
