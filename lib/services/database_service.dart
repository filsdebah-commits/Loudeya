import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _db;
  final _uuid = const Uuid();

  String get newId => _uuid.v4();

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'loudeya.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE produits(
      id TEXT PRIMARY KEY, nom TEXT, categorie TEXT, unite TEXT,
      prixAchat REAL, prixVente REAL, stock INTEGER, stockMin INTEGER,
      description TEXT, createdAt TEXT)''');

    await db.execute('''CREATE TABLE clients(
      id TEXT PRIMARY KEY, nom TEXT, telephone TEXT,
      email TEXT, adresse TEXT, createdAt TEXT)''');

    await db.execute('''CREATE TABLE ventes(
      id TEXT PRIMARY KEY, clientId TEXT, clientNom TEXT,
      date TEXT, modePaiement TEXT, items TEXT, total REAL, createdAt TEXT)''');

    await db.execute('''CREATE TABLE factures(
      id TEXT PRIMARY KEY, clientId TEXT, clientNom TEXT,
      date TEXT, statut TEXT, items TEXT, total REAL, remise REAL, notes TEXT, createdAt TEXT)''');

    await db.execute('''CREATE TABLE commandes(
      id TEXT PRIMARY KEY, fournisseurId TEXT, fournisseurNom TEXT,
      date TEXT, statut TEXT, items TEXT, total REAL, notes TEXT, createdAt TEXT)''');

    await db.execute('''CREATE TABLE devis(
      id TEXT PRIMARY KEY, clientId TEXT, clientNom TEXT,
      date TEXT, statut TEXT, items TEXT, total REAL, notes TEXT, createdAt TEXT)''');

    await db.execute('''CREATE TABLE fournisseurs(
      id TEXT PRIMARY KEY, nom TEXT, telephone TEXT,
      email TEXT, adresse TEXT, produits TEXT, createdAt TEXT)''');

    await db.execute('''CREATE TABLE dettes(
      id TEXT PRIMARY KEY, clientId TEXT, clientNom TEXT,
      description TEXT, statut TEXT, date TEXT,
      montant REAL, montantPaye REAL, createdAt TEXT)''');

    await db.execute('''CREATE TABLE employes(
      id TEXT PRIMARY KEY, nom TEXT, poste TEXT, telephone TEXT,
      statut TEXT, salaire REAL, dateEmbauche TEXT, createdAt TEXT)''');

    await db.execute('''CREATE TABLE mouvements(
      id TEXT PRIMARY KEY, type TEXT, produitId TEXT, produitNom TEXT,
      motif TEXT, date TEXT, quantite INTEGER, createdAt TEXT)''');
  }

  // ── PRODUITS ──
  Future<List<Produit>> getProduits() async {
    final d = await db;
    final rows = await d.query('produits', orderBy: 'nom ASC');
    return rows.map(Produit.fromMap).toList();
  }

  Future<void> saveProduit(Produit p) async {
    final d = await db;
    await d.insert('produits', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteProduit(String id) async {
    final d = await db;
    await d.delete('produits', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateStock(String id, int delta) async {
    final d = await db;
    await d.rawUpdate('UPDATE produits SET stock = stock + ? WHERE id = ?', [delta, id]);
  }

  // ── CLIENTS ──
  Future<List<Client>> getClients() async {
    final d = await db;
    final rows = await d.query('clients', orderBy: 'nom ASC');
    return rows.map(Client.fromMap).toList();
  }

  Future<void> saveClient(Client c) async {
    final d = await db;
    await d.insert('clients', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteClient(String id) async {
    final d = await db;
    await d.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  // ── VENTES ──
  Future<List<Map<String, dynamic>>> getVentesRaw() async {
    final d = await db;
    final rows = await d.query('ventes', orderBy: 'createdAt DESC');
    return rows;
  }

  Future<void> saveVente(Vente v) async {
    final d = await db;
    final map = {
      'id': v.id, 'clientId': v.clientId, 'clientNom': v.clientNom,
      'date': v.date, 'modePaiement': v.modePaiement,
      'items': jsonEncode(v.items.map((e) => e.toMap()).toList()),
      'total': v.total, 'createdAt': v.createdAt,
    };
    await d.insert('ventes', map, conflictAlgorithm: ConflictAlgorithm.replace);
    // Déduire le stock
    for (final item in v.items) {
      await updateStock(item.produitId, -item.qty);
    }
  }

  // ── FACTURES ──
  Future<List<Map<String, dynamic>>> getFacturesRaw() async {
    final d = await db;
    return d.query('factures', orderBy: 'createdAt DESC');
  }

  Future<void> saveFacture(Facture f) async {
    final d = await db;
    final map = {
      'id': f.id, 'clientId': f.clientId, 'clientNom': f.clientNom,
      'date': f.date, 'statut': f.statut,
      'items': jsonEncode(f.items.map((e) => e.toMap()).toList()),
      'total': f.total, 'remise': f.remise, 'notes': f.notes, 'createdAt': f.createdAt,
    };
    await d.insert('factures', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateFactureStatut(String id, String statut) async {
    final d = await db;
    await d.update('factures', {'statut': statut}, where: 'id = ?', whereArgs: [id]);
  }

  // ── COMMANDES ──
  Future<List<Map<String, dynamic>>> getCommandesRaw() async {
    final d = await db;
    return d.query('commandes', orderBy: 'createdAt DESC');
  }

  Future<void> saveCommande(Map<String, dynamic> c) async {
    final d = await db;
    await d.insert('commandes', c, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ── DEVIS ──
  Future<List<Map<String, dynamic>>> getDevisRaw() async {
    final d = await db;
    return d.query('devis', orderBy: 'createdAt DESC');
  }

  Future<void> saveDevis(Map<String, dynamic> dv) async {
    final d = await db;
    await d.insert('devis', dv, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ── FOURNISSEURS ──
  Future<List<Fournisseur>> getFournisseurs() async {
    final d = await db;
    final rows = await d.query('fournisseurs', orderBy: 'nom ASC');
    return rows.map(Fournisseur.fromMap).toList();
  }

  Future<void> saveFournisseur(Fournisseur f) async {
    final d = await db;
    await d.insert('fournisseurs', f.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteFournisseur(String id) async {
    final d = await db;
    await d.delete('fournisseurs', where: 'id = ?', whereArgs: [id]);
  }

  // ── DETTES ──
  Future<List<Dette>> getDettes() async {
    final d = await db;
    final rows = await d.query('dettes', orderBy: 'createdAt DESC');
    return rows.map(Dette.fromMap).toList();
  }

  Future<void> saveDette(Dette dt) async {
    final d = await db;
    await d.insert('dettes', dt.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> payerDette(String id, double montant) async {
    final d = await db;
    await d.rawUpdate(
      'UPDATE dettes SET montantPaye = montantPaye + ?, statut = CASE WHEN montantPaye + ? >= montant THEN "payee" ELSE statut END WHERE id = ?',
      [montant, montant, id],
    );
  }

  // ── EMPLOYES ──
  Future<List<Employe>> getEmployes() async {
    final d = await db;
    final rows = await d.query('employes', orderBy: 'nom ASC');
    return rows.map(Employe.fromMap).toList();
  }

  Future<void> saveEmploye(Employe e) async {
    final d = await db;
    await d.insert('employes', e.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteEmploye(String id) async {
    final d = await db;
    await d.delete('employes', where: 'id = ?', whereArgs: [id]);
  }

  // ── MOUVEMENTS ──
  Future<List<Mouvement>> getMouvements() async {
    final d = await db;
    final rows = await d.query('mouvements', orderBy: 'createdAt DESC');
    return rows.map(Mouvement.fromMap).toList();
  }

  Future<void> saveMouvement(Mouvement m) async {
    final d = await db;
    await d.insert('mouvements', m.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    final delta = m.type == 'entree' ? m.quantite : -m.quantite;
    await updateStock(m.produitId, delta);
  }

  // ── STATS DASHBOARD ──
  Future<Map<String, dynamic>> getDashStats() async {
    final d = await db;
    final today = DateTime.now().toIso8601String().split('T')[0];
    final mois  = today.substring(0, 7);

    final nbProduits   = Sqflite.firstIntValue(await d.rawQuery('SELECT COUNT(*) FROM produits')) ?? 0;
    final nbClients    = Sqflite.firstIntValue(await d.rawQuery('SELECT COUNT(*) FROM clients')) ?? 0;
    final alertes      = Sqflite.firstIntValue(await d.rawQuery('SELECT COUNT(*) FROM produits WHERE stock <= stockMin')) ?? 0;

    final caJour = (await d.rawQuery(
      'SELECT COALESCE(SUM(total),0) as ca FROM ventes WHERE date = ?', [today]
    )).first['ca'] as double? ?? 0.0;

    final caMois = (await d.rawQuery(
      "SELECT COALESCE(SUM(total),0) as ca FROM ventes WHERE date LIKE '${mois}%'"
    )).first['ca'] as double? ?? 0.0;

    final caTotal = (await d.rawQuery(
      'SELECT COALESCE(SUM(total),0) as ca FROM ventes'
    )).first['ca'] as double? ?? 0.0;

    // CA 30 derniers jours
    final ca30 = <String, double>{};
    for (int i = 29; i >= 0; i--) {
      final dt = DateTime.now().subtract(Duration(days: i)).toIso8601String().split('T')[0];
      ca30[dt] = 0.0;
    }
    final rows30 = await d.rawQuery(
      "SELECT date, SUM(total) as ca FROM ventes WHERE date >= ? GROUP BY date",
      [DateTime.now().subtract(const Duration(days: 29)).toIso8601String().split('T')[0]],
    );
    for (final r in rows30) {
      final dt = r['date'] as String;
      if (ca30.containsKey(dt)) ca30[dt] = (r['ca'] as double? ?? 0.0);
    }

    return {
      'nbProduits': nbProduits,
      'nbClients': nbClients,
      'alertes': alertes,
      'caJour': caJour,
      'caMois': caMois,
      'caTotal': caTotal,
      'ca30': ca30,
    };
  }
}
