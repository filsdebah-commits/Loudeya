import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/models.dart';
import '../../services/database_service.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

class ProduitsScreen extends StatefulWidget {
  const ProduitsScreen({super.key});
  @override
  State<ProduitsScreen> createState() => _ProduitsScreenState();
}

class _ProduitsScreenState extends State<ProduitsScreen> {
  final _db = DatabaseService();
  List<Produit> _produits = [];
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final p = await _db.getProduits();
    if (mounted) setState(() => _produits = p);
  }

  List<Produit> get _filtered => _produits.where((p) =>
    p.nom.toLowerCase().contains(_search.toLowerCase()) ||
    p.categorie.toLowerCase().contains(_search.toLowerCase())
  ).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(title: const Text('Produits'), backgroundColor: LoudeyaTheme.surface,
      bottom: PreferredSize(preferredHeight: 60, child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: TextField(
          onChanged: (v) => setState(() => _search = v),
          style: const TextStyle(color: LoudeyaTheme.text),
          decoration: InputDecoration(
            hintText: 'Rechercher un produit…',
            prefixIcon: const Icon(Icons.search, color: LoudeyaTheme.muted),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          ),
        ),
      )),
    ),
    body: RefreshIndicator(
      onRefresh: _load, color: LoudeyaTheme.accent,
      child: _filtered.isEmpty
        ? const EmptyState(message: 'Aucun produit', icon: Icons.inventory_2_outlined)
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _filtered.length,
          itemBuilder: (_, i) {
            final p = _filtered[i];
            final alerte = p.stock <= p.stockMin;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Slidable(
                endActionPane: ActionPane(motion: const DrawerMotion(), children: [
                  SlidableAction(onPressed: (_) => _showForm(p),
                    backgroundColor: LoudeyaTheme.blue, icon: Icons.edit_rounded, label: 'Modifier'),
                  SlidableAction(onPressed: (_) => _delete(p),
                    backgroundColor: LoudeyaTheme.danger, icon: Icons.delete_rounded, label: 'Suppr.'),
                ]),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: LoudeyaTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: alerte ? LoudeyaTheme.danger.withOpacity(0.4) : LoudeyaTheme.border),
                  ),
                  child: Row(children: [
                    Container(
                      width: 44, height: 44, decoration: BoxDecoration(
                        color: LoudeyaTheme.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.inventory_2_rounded, color: LoudeyaTheme.accent, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.nom, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${p.categorie} • ${fmtGNF(p.prixVente)}',
                        style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                    ])),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('${p.stock}', style: TextStyle(
                        color: alerte ? LoudeyaTheme.danger : LoudeyaTheme.accent,
                        fontWeight: FontWeight.w800, fontSize: 18,
                      )),
                      Text(p.unite, style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 11)),
                    ]),
                  ]),
                ),
              ),
            );
          },
        ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => _showForm(null),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Nouveau'),
    ),
  );

  Future<void> _delete(Produit p) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      backgroundColor: LoudeyaTheme.surface,
      title: const Text('Supprimer ?', style: TextStyle(color: LoudeyaTheme.text)),
      content: Text('Supprimer "${p.nom}" ?', style: const TextStyle(color: LoudeyaTheme.muted)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
        TextButton(onPressed: () => Navigator.pop(context, true),
          child: const Text('Supprimer', style: TextStyle(color: LoudeyaTheme.danger))),
      ],
    ));
    if (ok == true) { await _db.deleteProduit(p.id); _load(); }
  }

  void _showForm(Produit? p) {
    final nomC = TextEditingController(text: p?.nom);
    final catC = TextEditingController(text: p?.categorie);
    final uniteC = TextEditingController(text: p?.unite ?? 'unité');
    final pAchatC = TextEditingController(text: p?.prixAchat.toString() ?? '');
    final pVenteC = TextEditingController(text: p?.prixVente.toString() ?? '');
    final stockC = TextEditingController(text: p?.stock.toString() ?? '0');
    final stockMinC = TextEditingController(text: p?.stockMin.toString() ?? '5');
    final key = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: LoudeyaTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(key: key, child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(p == null ? 'Nouveau produit' : 'Modifier produit',
              style: const TextStyle(color: LoudeyaTheme.text, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            LField(label: 'Nom', controller: nomC, required: true),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: LField(label: 'Catégorie', controller: catC)),
              const SizedBox(width: 12),
              Expanded(child: LField(label: 'Unité', controller: uniteC)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: LField(label: 'Prix achat', controller: pAchatC, keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: LField(label: 'Prix vente', controller: pVenteC, keyboardType: TextInputType.number, required: true)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: LField(label: 'Stock', controller: stockC, keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: LField(label: 'Stock min', controller: stockMinC, keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () async {
                if (!key.currentState!.validate()) return;
                final prod = Produit(
                  id: p?.id ?? _db.newId, nom: nomC.text,
                  categorie: catC.text, unite: uniteC.text,
                  prixAchat: double.tryParse(pAchatC.text) ?? 0,
                  prixVente: double.tryParse(pVenteC.text) ?? 0,
                  stock: int.tryParse(stockC.text) ?? 0,
                  stockMin: int.tryParse(stockMinC.text) ?? 5,
                  createdAt: p?.createdAt ?? DateTime.now().toIso8601String(),
                );
                await _db.saveProduit(prod);
                if (mounted) { Navigator.pop(context); _load(); }
              },
              child: Text(p == null ? 'Enregistrer' : 'Modifier'),
            )),
            const SizedBox(height: 8),
          ])),
        ),
      ),
    );
  }
}
