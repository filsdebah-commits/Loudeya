// ══════════════════════════════════════════
//  LOUDEYA — Models
// ══════════════════════════════════════════

class Produit {
  final String id;
  String nom, categorie, unite;
  double prixAchat, prixVente;
  int stock, stockMin;
  String? description;
  String createdAt;

  Produit({
    required this.id, required this.nom, required this.categorie,
    required this.unite, required this.prixAchat, required this.prixVente,
    required this.stock, this.stockMin = 5, this.description, required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'nom': nom, 'categorie': categorie, 'unite': unite,
    'prixAchat': prixAchat, 'prixVente': prixVente, 'stock': stock,
    'stockMin': stockMin, 'description': description, 'createdAt': createdAt,
  };

  factory Produit.fromMap(Map<String, dynamic> m) => Produit(
    id: m['id'], nom: m['nom'], categorie: m['categorie'] ?? '',
    unite: m['unite'] ?? 'unité', prixAchat: (m['prixAchat'] ?? 0).toDouble(),
    prixVente: (m['prixVente'] ?? 0).toDouble(), stock: m['stock'] ?? 0,
    stockMin: m['stockMin'] ?? 5, description: m['description'],
    createdAt: m['createdAt'] ?? DateTime.now().toIso8601String(),
  );
}

class Client {
  final String id;
  String nom, telephone, email, adresse;
  String createdAt;

  Client({
    required this.id, required this.nom, required this.telephone,
    required this.email, required this.adresse, required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'nom': nom, 'telephone': telephone,
    'email': email, 'adresse': adresse, 'createdAt': createdAt,
  };

  factory Client.fromMap(Map<String, dynamic> m) => Client(
    id: m['id'], nom: m['nom'], telephone: m['telephone'] ?? '',
    email: m['email'] ?? '', adresse: m['adresse'] ?? '',
    createdAt: m['createdAt'] ?? DateTime.now().toIso8601String(),
  );
}

class VenteItem {
  String produitId, nom;
  int qty;
  double prix;

  VenteItem({required this.produitId, required this.nom, required this.qty, required this.prix});

  Map<String, dynamic> toMap() => {'produitId': produitId, 'nom': nom, 'qty': qty, 'prix': prix};
  factory VenteItem.fromMap(Map<String, dynamic> m) =>
      VenteItem(produitId: m['produitId'] ?? '', nom: m['nom'], qty: m['qty'], prix: (m['prix']).toDouble());

  double get total => qty * prix;
}

class Vente {
  final String id;
  String clientId, clientNom, date, modePaiement;
  List<VenteItem> items;
  double total;
  String createdAt;

  Vente({
    required this.id, required this.clientId, required this.clientNom,
    required this.date, required this.modePaiement, required this.items,
    required this.total, required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'clientId': clientId, 'clientNom': clientNom,
    'date': date, 'modePaiement': modePaiement,
    'items': items.map((e) => e.toMap()).toList().toString(),
    'total': total, 'createdAt': createdAt,
  };
}

class Facture {
  final String id;
  String clientId, clientNom, date, statut;
  List<VenteItem> items;
  double total, remise;
  String? notes;
  String createdAt;

  Facture({
    required this.id, required this.clientId, required this.clientNom,
    required this.date, required this.statut, required this.items,
    required this.total, this.remise = 0, this.notes, required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'clientId': clientId, 'clientNom': clientNom,
    'date': date, 'statut': statut,
    'items': items.map((e) => e.toMap()).toList().toString(),
    'total': total, 'remise': remise, 'notes': notes, 'createdAt': createdAt,
  };
}

class Fournisseur {
  final String id;
  String nom, telephone, email, adresse, produits;
  String createdAt;

  Fournisseur({
    required this.id, required this.nom, required this.telephone,
    required this.email, required this.adresse, required this.produits,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'nom': nom, 'telephone': telephone,
    'email': email, 'adresse': adresse, 'produits': produits, 'createdAt': createdAt,
  };

  factory Fournisseur.fromMap(Map<String, dynamic> m) => Fournisseur(
    id: m['id'], nom: m['nom'], telephone: m['telephone'] ?? '',
    email: m['email'] ?? '', adresse: m['adresse'] ?? '',
    produits: m['produits'] ?? '', createdAt: m['createdAt'] ?? '',
  );
}

class Dette {
  final String id;
  String clientId, clientNom, description, statut, date;
  double montant, montantPaye;
  String createdAt;

  Dette({
    required this.id, required this.clientId, required this.clientNom,
    required this.description, required this.statut, required this.date,
    required this.montant, this.montantPaye = 0, required this.createdAt,
  });

  double get restant => montant - montantPaye;

  Map<String, dynamic> toMap() => {
    'id': id, 'clientId': clientId, 'clientNom': clientNom,
    'description': description, 'statut': statut, 'date': date,
    'montant': montant, 'montantPaye': montantPaye, 'createdAt': createdAt,
  };

  factory Dette.fromMap(Map<String, dynamic> m) => Dette(
    id: m['id'], clientId: m['clientId'] ?? '', clientNom: m['clientNom'],
    description: m['description'] ?? '', statut: m['statut'] ?? 'en_cours',
    date: m['date'] ?? '', montant: (m['montant']).toDouble(),
    montantPaye: (m['montantPaye'] ?? 0).toDouble(),
    createdAt: m['createdAt'] ?? '',
  );
}

class Employe {
  final String id;
  String nom, poste, telephone, statut;
  double salaire;
  String dateEmbauche, createdAt;

  Employe({
    required this.id, required this.nom, required this.poste,
    required this.telephone, required this.statut, required this.salaire,
    required this.dateEmbauche, required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'nom': nom, 'poste': poste, 'telephone': telephone,
    'statut': statut, 'salaire': salaire,
    'dateEmbauche': dateEmbauche, 'createdAt': createdAt,
  };

  factory Employe.fromMap(Map<String, dynamic> m) => Employe(
    id: m['id'], nom: m['nom'], poste: m['poste'] ?? '',
    telephone: m['telephone'] ?? '', statut: m['statut'] ?? 'actif',
    salaire: (m['salaire'] ?? 0).toDouble(),
    dateEmbauche: m['dateEmbauche'] ?? '', createdAt: m['createdAt'] ?? '',
  );
}

class Mouvement {
  final String id;
  String type, produitId, produitNom, motif, date;
  int quantite;
  String createdAt;

  Mouvement({
    required this.id, required this.type, required this.produitId,
    required this.produitNom, required this.motif, required this.date,
    required this.quantite, required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'type': type, 'produitId': produitId,
    'produitNom': produitNom, 'motif': motif, 'date': date,
    'quantite': quantite, 'createdAt': createdAt,
  };

  factory Mouvement.fromMap(Map<String, dynamic> m) => Mouvement(
    id: m['id'], type: m['type'], produitId: m['produitId'] ?? '',
    produitNom: m['produitNom'], motif: m['motif'] ?? '',
    date: m['date'] ?? '', quantite: m['quantite'] ?? 0,
    createdAt: m['createdAt'] ?? '',
  );
}
