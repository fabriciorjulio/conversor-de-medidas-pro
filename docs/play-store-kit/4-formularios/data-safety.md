# Formulario de Seguranca dos Dados (Data Safety)

Play Console → App content → Data safety

Preencha as respostas abaixo. Todas foram validadas contra o codigo-fonte
do aplicativo (nao ha coleta de dados pessoais pelo proprio app; o SDK
do Google AdMob coleta para personalizacao de anuncios).

---

## 1. Data collection and security

**Does your app collect or share any of the required user data types?**
YES

*Justificativa*: O SDK do Google AdMob coleta identificadores do
dispositivo (Advertising ID) para exibicao de anuncios. O app em si nao
coleta dados. A resposta tem que ser YES por causa do AdMob.

**Is all of the user data collected by your app encrypted in transit?**
YES

*Justificativa*: As requisicoes de cotacoes ao vivo sao feitas via HTTPS
(economia.awesomeapi.com.br). O AdMob tambem usa HTTPS.

**Do you provide a way for users to request that their data be deleted?**
NO

*Justificativa*: O app nao armazena dados em servidor. Preferencias e
historico ficam apenas no dispositivo e sao apagados ao desinstalar o
app. Nao ha o que deletar em servidor.

---

## 2. Data types

### Location
- **Approximate location**:          NO
- **Precise location**:              NO

### Personal info
- **Name**:                          NO
- **Email address**:                 NO
- **User IDs**:                      NO
- **Address**:                       NO
- **Phone number**:                  NO
- **Race and ethnicity**:            NO
- **Political or religious beliefs**: NO
- **Sexual orientation**:            NO
- **Other info**:                    NO

### Financial info
- **User payment info**:             NO
- **Purchase history**:              NO
- **Credit score**:                  NO
- **Other financial info**:          NO

*Nota*: as calculadoras (FGTS, poupanca, juros) processam valores
digitados pelo usuario apenas no dispositivo, sem envio para servidor.

### Health and fitness
Todos NO.

### Messages
Todos NO.

### Photos and videos
- **Photos**:                        NO
- **Videos**:                        NO

*Nota*: a ferramenta de conversao PDF/imagem usa o storage local do
dispositivo apenas enquanto a conversao ocorre. Nenhum arquivo e enviado
para servidor.

### Audio files
Todos NO.

### Files and docs
- **Files and docs**:                NO

*Justificativa*: a conversao de PDF/DOCX acontece 100% no dispositivo.
Os arquivos nao saem do celular.

### Calendar
Todos NO.

### Contacts
Todos NO.

### App activity
- **App interactions**:              NO
- **In-app search history**:         NO
- **Installed apps**:                NO
- **Other user-generated content**:  NO
- **Other actions**:                 NO

### Web browsing
- **Web browsing history**:          NO

### App info and performance
- **Crash logs**:                    NO
- **Diagnostics**:                   NO
- **Other app info**:                NO

*Nota*: o app nao usa Firebase Crashlytics nem Analytics. Caso queira
adicionar depois, atualize este formulario.

### Device or other IDs
- **Device or other IDs**:           YES
  - Collected: YES
  - Shared: YES
  - Processed ephemerally: NO
  - Optional: NO (coleta acontece pelo AdMob SDK)
  - Purposes: **Advertising or marketing**

*Justificativa*: o SDK do Google AdMob usa o Android Advertising ID para
seleciionar e medir anuncios.

---

## 3. Purposes to declare for "Device or other IDs"

- App functionality:                 NO
- Analytics:                         NO
- Developer communications:          NO
- Advertising or marketing:          YES
- Fraud prevention, security, and compliance: NO
- Personalization:                   NO
- Account management:                NO

---

## 4. Security practices

- **Is your data encrypted in transit?**  YES
- **Committed to follow Play Families Policy**?  N/A (app nao e primariamente para criancas)
- **Has your app been independently validated against a global security standard?**  NO

---

## 5. Confirmation statements

Marque:
- [x] "I have reviewed the answers and they are accurate"
- [x] "I understand that Google may take action if my answers are inaccurate"
