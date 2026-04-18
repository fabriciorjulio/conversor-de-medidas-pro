# Como gerar o AAB assinado

Este guia assume que voce esta na **maquina que tem o keystore original**
do upload da versao `8`. Se voce gerar um AAB assinado com keystore
diferente, a Play Store vai rejeitar com erro de assinatura.

---

## 1. Pre-requisitos

- Flutter 3.29.3 ou superior (mesma versao usada nos builds anteriores)
- JDK 17
- Android SDK com build-tools instalado
- Keystore `.jks` da Play Store + senha + alias + senha do alias

Confirme com:

```bash
flutter --version       # deve aparecer Flutter 3.29.x
java -version           # deve aparecer OpenJDK 17
```

---

## 2. Clonar o projeto (se ainda nao tiver)

```bash
git clone https://github.com/fabriciorjulio/conversor-de-medidas-pro.git
cd conversor-de-medidas-pro
flutter pub get
```

Se ja tiver o repo, so:

```bash
cd conversor-de-medidas-pro
git pull origin main
flutter pub get
```

---

## 3. Colocar o keystore no lugar certo

Copie o arquivo `.jks` (o keystore que voce usou nas publicacoes
anteriores) para dentro do projeto. Sugestao de path:

```
<raiz-do-projeto>/android/keystore/converte-tudo.jks
```

---

## 4. Criar `android/key.properties`

**NAO** commitar este arquivo (ele ja esta no .gitignore por padrao da
Flutter, mas confirme).

Crie `android/key.properties` com:

```properties
storePassword=<senha-do-keystore>
keyPassword=<senha-do-alias>
keyAlias=<nome-do-alias>
storeFile=keystore/converte-tudo.jks
```

O caminho `storeFile` e relativo ao diretorio `android/app/`. Se voce
colocar o `.jks` em `android/keystore/converte-tudo.jks`, o valor e
`../keystore/converte-tudo.jks`. Ajuste conforme onde voce colocou.

---

## 5. Verificar o `versionCode`

Abra `pubspec.yaml` e confirme que a linha `version:` esta com um numero
**maior** que o ultimo build enviado. O ultimo enviado foi `8`. Este
repo ja esta com:

```yaml
version: 2.3.2+9
```

O `+9` = versionCode 9. Se voce tiver enviado algum build novo depois,
incremente (+10, +11, ...).

---

## 6. Gerar o AAB

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Se tudo der certo, o AAB fica em:

```
build/app/outputs/bundle/release/app-release.aab
```

---

## 7. Verificar a assinatura

Antes de enviar, confirme que o AAB foi assinado com o keystore certo:

```bash
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
```

Compare o **SHA-256** com o do keystore original
(voce pode ver no Play Console → Release → Setup → App signing →
Upload certificate). Se baterem, esta tudo certo.

---

## 8. Enviar para o Play Console

1. Play Console → `Production` → `Create new release`
2. `Upload` → arraste o `app-release.aab`
3. `Release notes (What's new)` → cole o texto de
   `1-textos/04-notas-versao.txt`
4. `Next` → `Save` → `Review release`

Depois, atualize a listagem da loja (Main store listing) com os textos
de `1-textos/` **antes** de clicar `Send X changes for review`.

---

## Troubleshooting

**"Keystore was tampered with, or password was incorrect"**
→ senha errada no `key.properties`.

**"You uploaded an APK or Android App Bundle that was signed with a
different key"**
→ keystore errado. Use exatamente o mesmo `.jks` do upload anterior.

**"Version code X has already been used"**
→ incremente o numero depois do `+` no `version:` do `pubspec.yaml`.

**"The app signing key used to sign APK(s) is rotated"**
→ Play App Signing detectou rotacao. Se nao foi intencional, pare e
investigue antes de confirmar.

---

## Se voce perdeu o keystore

Use o fluxo de reset via Play Console:
1. Play Console → seu app → `Setup` → `App integrity` → `App signing`
2. `Request upload key reset`
3. Siga as instrucoes (precisa enviar novo keystore PEM via formulario)
4. Espera de 1-2 dias uteis
5. Depois do reset, gere um keystore novo e use nele daqui pra frente
