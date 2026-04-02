import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/database_service.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

class VentesScreen extends StatefulWidget {
  const VentesScreen({super.key});
  @override
  State<VentesScreen> createState() => _VentesScreenState();
}

class _VentesScreenState extends State<VentesScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(
      title: const Text('Ventes'),
      backgroundColor: LoudeyaTheme.surface,
      bottom: TabBar(
        controller: _tab,
        indicatorColor: LoudeyaTheme.accent,
        labelColor: LoudeyaTheme.accent,
        unselectedLabelColor: LoudeyaTheme.muted,
        tabs: const [Tab(text: 'CAISSE POS'), Tab(text: 'HISTORIQUE')],
      ),
    ),
    body: TabBarView(controller: _tab, children: const [
      _POSTab(), _HistoriqueTab(),
    ]),
  );
}

class _POSTab extends StatefulWidget {
  const _POSTab();
  @override
  State<_POSTab> createState() => _POSTabState();
}

class _POSTabState extends State<_POSTab> {
  final _db = DatabaseService();
  List<Produit> _produits = [];
  List<VenteItem> _panier = [];
  Client? _client;
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final p = await _db.getProduits();
    if (mounted) setState(() => _produits = p);
  }

  List<Produit> get _filtered => _produits.where((p) =>
    p.nom.toLowerCase().contains(_search.toLowerCase())
  ).toList();

  double get _total => _panier.fold(0, (s, i) => s + i.total);

  void _addToCart(Produit p) {
    setState(() {
      final idx = _panier.indexWhere((i) => i.produitId == p.id);
      if (idx >= 0) {
        if (_panier[idx].qty < p.stock) _panier[idx].qty++;
      } else {
        if (p.stock > 0) _panier.add(VenteItem(produitId: p.id, nom: p.nom, qty: 1, prix: p.prixVente));
      }
    });
  }

  Future<void> _valider() async {
    if (_panier.isEmpty) return;
    final vente = Vente(
      id: _db.newId,
      clientId: _client?.id ?? '',
      clientNom: _client?.nom ?? 'Caisse',
      date: DateTime.now().toIso8601String().split('T')[0],
      modePaiement: 'Caisse',
      items: List.from(_panier),
      total: _total,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _db.saveVente(vente);
    setState(() { _panier.clear(); _client = null; });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Vente enregistrée — ${fmtGNF(_total)}'),
        backgroundColor: LoudeyaTheme.accent,
      ));
    }
    _load();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    // Produits
    Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        style: const TextStyle(color: LoudeyaTheme.text),
        decoration: const InputDecoration(
          hintText: 'Rechercher produit…',
          prefixIcon: Icon(Icons.search, color: LoudeyaTheme.muted),
        ),
      ),
    ),
    SizedBox(height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _filtered.length,
        itemBuilder: (_, i) {
          final p = _filtered[i];
          return GestureDetector(
            onTap: () => _addToCart(p),
            child: Container(
              width: 110, margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LoudeyaTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.stock > 0 ? LoudeyaTheme.border : LoudeyaTheme.danger.withOpacity(0.3)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.inventory_2_rounded, color: LoudeyaTheme.accent, size: 28),
                const SizedBox(height: 8),
                Text(p.nom, maxLines: 2, textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: LoudeyaTheme.text, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(fmtGNF(p.prixVente),
                  style: const TextStyle(color: LoudeyaTheme.accent, fontSize: 11, fontWeight: FontWeight.w700)),
                Text('Stock: ${p.stock}',
                  style: TextStyle(color: p.stock > 0 ? LoudeyaTheme.muted : LoudeyaTheme.danger, fontSize: 10)),
              ]),
            ),
          );
        },
      ),
    ),
    const Divider(height: 1),
    // Panier
    Expanded(
      child: _panier.isEmpty
        ? const EmptyState(message: 'Panier vide — appuyez sur un produit', icon: Icons.shopping_cart_outlined)
        : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _panier.length,
          itemBuilder: (_, i) {
            final item = _panier[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: LoudeyaTheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: LoudeyaTheme.border),
              ),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.nom, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w600)),
                  Text(fmtGNF(item.prix), style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                ])),
                Row(children: [
                  IconButton(onPressed: () => setState(() { if (item.qty > 1) item.qty--; else _panier.removeAt(i); }),
                    icon: const Icon(Icons.remove_circle_outline, color: LoudeyaTheme.danger), iconSize: 20),
                  Text('${item.qty}', style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700, fontSize: 16)),
                  IconButton(onPressed: () => setState(() => item.qty++),
                    icon: const Icon(Icons.add_circle_outline, color: LoudeyaTheme.accent), iconSize: 20),
                ]),
                SizedBox(width: 80, child: Text(fmtGNF(item.total),
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: LoudeyaTheme.accent, fontWeight: FontWeight.w700))),
              ]),
            );
          },
        ),
    ),
    // Total + Valider
    Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: LoudeyaTheme.surface,
        border: Border(top: BorderSide(color: LoudeyaTheme.border)),
      ),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('TOTAL', style: TextStyle(color: LoudeyaTheme.muted, fontSize: 11, letterSpacing: 1.5)),
          Text(fmtGNF(_total), style: const TextStyle(color: LoudeyaTheme.accent, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(width: 16),
        Expanded(child: ElevatedButton.icon(
          onPressed: _panier.isNotEmpty ? _valider : null,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Valider la vente'),
        )),
      ]),
    ),
  ]);
}

class _HistoriqueTab extends StatefulWidget {
  const _HistoriqueTab();
  @override
  State<_HistoriqueTab> createState() => _HistoriqueTabState();
}

class _HistoriqueTabState extends State<_HistoriqueTab> {
  final _db = DatabaseService();
  List<Map<String, dynamic>> _ventes = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final v = await _db.getVentesRaw();
    if (mounted) setState(() => _ventes = v);
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: _load, color: LoudeyaTheme.accent,
    child: _ventes.isEmpty
      ? const EmptyState(message: 'Aucune vente enregistrée', icon: Icons.receipt_long_outlined)
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _ventes.length,
        itemBuilder: (_, i) {
          final v = _ventes[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: LoudeyaTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: LoudeyaTheme.border),
            ),
            child: Row(children: [
              Container(width: 40, height: 40,
                decoration: BoxDecoration(color: LoudeyaTheme.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.receipt_rounded, color: LoudeyaTheme.accent, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(v['clientNom'] ?? 'Caisse',
                  style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w600)),
                Text(v['date'] ?? '', style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
              ])),
              Text(fmtGNF((v['total'] as num).toDouble()),
                style: const TextStyle(color: LoudeyaTheme.accent, fontWeight: FontWeight.w800)),
            ]),
          );
        },
      ),
  );
}
