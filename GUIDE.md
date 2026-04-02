# 📱 Loudeya Mobile — Guide Flutter

## Architecture du projet

```
loudeya_flutter/
├── lib/
│   ├── main.dart                    ← Point d'entrée + navigation
│   ├── theme/app_theme.dart         ← Couleurs, typographie (identique desktop)
│   ├── models/models.dart           ← Tous les modèles de données
│   ├── services/database_service.dart ← SQLite (toutes les opérations DB)
│   ├── widgets/common_widgets.dart  ← KpiCard, BarChart30, LField, etc.
│   └── screens/
│       ├── dashboard/               ← Dashboard + graphique 30j
│       ├── ventes/                  ← POS Caisse + Historique
│       ├── produits/                ← Liste + CRUD produits
│       ├── clients/                 ← Liste + CRUD clients
│       └── secondary_screens.dart  ← Factures, Devis, Commandes,
│                                     Fournisseurs, Dettes, Mouvements,
│                                     Paie, Alertes, Rapports
```

---

## 🚀 Installation — Étapes

### 1. Prérequis

- Flutter SDK ≥ 3.0 → https://flutter.dev/docs/get-started/install
- Android Studio (pour Android) + JDK 17
- Xcode ≥ 14 (pour iOS, Mac uniquement)
- Git

### 2. Extraire et préparer

```bash
# Extraire le zip
unzip Loudeya_Flutter.zip
cd loudeya_flutter

# Installer les dépendances
flutter pub get
```

### 3. Lancer en mode développement

```bash
# Android (avec téléphone connecté ou émulateur)
flutter run

# iOS (Mac uniquement)
flutter run -d ios
```

---

## 📦 Générer l'APK Android

```bash
# APK de debug (test rapide)
flutter build apk --debug

# APK de release (à distribuer)
flutter build apk --release --split-per-abi

# Les APKs se trouvent dans :
# build/app/outputs/flutter-apk/
```

## 🍎 Générer l'IPA iOS (Mac requis)

```bash
# Ouvrir dans Xcode
open ios/Runner.xcworkspace

# Puis : Product → Archive → Distribute App

# Ou en ligne de commande :
flutter build ios --release
```

---

## 🔑 Fonctionnalités par module

| Module | Fonctionnalités |
|--------|----------------|
| **Dashboard** | 6 KPIs, graphique CA 30 jours, pull-to-refresh |
| **Ventes POS** | Catalogue horizontal, panier, quantités, validation |
| **Produits** | Liste avec search, CRUD, alertes stock, swipe actions |
| **Clients** | Liste avec search, CRUD, swipe actions |
| **Factures** | Liste avec statuts colorés |
| **Devis** | Liste avec statuts |
| **Commandes** | Liste fournisseurs avec statuts |
| **Fournisseurs** | CRUD complet, swipe delete |
| **Dettes** | Total dû, paiement rapide |
| **Mouvements** | Entrées/sorties stock avec impact automatique |
| **Paie** | CRUD employés, masse salariale auto |
| **Alertes** | Produits sous seuil, niveau critique |
| **Rapports** | KPIs + graphique 30 jours |

---

## 🗄️ Base de données

- **Moteur** : SQLite via `sqflite`
- **Fichier** : `loudeya.db` stocké localement sur l'appareil
- **Tables** : produits, clients, ventes, factures, commandes, devis, fournisseurs, dettes, employes, mouvements
- **Stock** : mis à jour automatiquement à chaque vente ou mouvement

---

## 🎨 Design

- **Couleur principale** : `#00E5A0` (accent vert)
- **Fond** : `#0B0F0C` (dark)
- **Police** : Syne (Google Fonts)
- **Composants** : Material 3

---

## 📱 Navigation

```
Bottom NavBar (5 onglets)
├── Dashboard
├── Ventes (POS + Historique)
├── Produits
├── Clients
└── Plus → grille 3×3
    ├── Factures    Devis      Commandes
    ├── Fournisseurs Dettes   Mouvements
    └── Paie        Alertes   Rapports
```

---

## 🔧 Personnalisation rapide

### Changer l'ID de l'app Android
Dans `android/app/build.gradle` :
```gradle
applicationId "com.loudeya.app"  // ← modifier ici
```

### Changer l'ID iOS
Dans `ios/Runner/Info.plist` et Xcode → Signing & Capabilities.

### Ajouter un module
1. Créer `lib/screens/monmodule/mon_screen.dart`
2. L'ajouter dans `_modules` dans `main.dart`

---

## ⚠️ Notes importantes

- Les données sont **locales** à l'appareil (SQLite)
- Pas de synchronisation cloud dans cette version
- Pour iOS, un compte développeur Apple est requis pour distribuer hors TestFlight
- L'APK release doit être signé avec un keystore pour Google Play
