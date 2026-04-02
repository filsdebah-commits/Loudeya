# 📱 Loudeya Mobile — Obtenir l'APK via GitHub

## Étapes simples (5 minutes)

### 1. Créer un compte GitHub (si pas déjà fait)
→ https://github.com/signup

---

### 2. Créer un nouveau dépôt
1. Aller sur https://github.com/new
2. Nom du dépôt : `loudeya`
3. Choisir **Private** (recommandé)
4. Cliquer **Create repository**

---

### 3. Uploader les fichiers
Sur la page de ton dépôt vide :
1. Cliquer **uploading an existing file**
2. Glisser-déposer **tout le contenu** du dossier `loudeya_flutter`
3. Cliquer **Commit changes**

---

### 4. Lancer la compilation
1. Aller dans l'onglet **Actions** de ton dépôt
2. Cliquer sur **Build Loudeya APK**
3. Cliquer **Run workflow** → **Run workflow**
4. Attendre ~5 minutes ☕

---

### 5. Télécharger l'APK
1. Une fois le build vert ✅, cliquer dessus
2. Descendre jusqu'à **Artifacts**
3. Cliquer **Loudeya-APK** pour télécharger
4. Extraire le ZIP → tu as l'APK !

---

### 6. Installer l'APK sur Android
1. Copier l'APK sur ton téléphone
2. Activer **Sources inconnues** dans Paramètres > Sécurité
3. Ouvrir l'APK et installer

---

## Structure du projet
```
.github/workflows/build.yml   ← CI automatique
lib/                          ← Code Flutter
android/                      ← Configuration Android
pubspec.yaml                  ← Dépendances
```
