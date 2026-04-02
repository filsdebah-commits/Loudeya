// ══════════════════════════════════════════
//  LOUDEYA — Screens secondaires
// ══════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/models.dart';
import '../../services/database_service.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

// ─────────────────── FACTURES ───────────────────
class FacturesScreen extends StatefulWidget {
  const FacturesScreen({super.key});
  @override State<FacturesScreen> createState() => _FacturesState();
}
class _FacturesState extends State<FacturesScreen> {
  final _db = DatabaseService();
  List<Map<String, dynamic>> _factures = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final f = await _db.getFacturesRaw(); if (mounted) setState(() => _factures = f); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(title: const Text('Factures'), backgroundColor: LoudeyaTheme.surface),
    body: RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
      child: _factures.isEmpty
        ? const EmptyState(message: 'Aucune facture', icon: Icons.receipt_long_outlined)
        : ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _factures.length,
          itemBuilder: (_, i) {
            final f = _factures[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.border)),
              child: Row(children: [
                const Icon(Icons.description_rounded, color: LoudeyaTheme.blue, size: 36),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(f['clientNom'] ?? '', style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                  Text(f['date'] ?? '', style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(fmtGNF((f['total'] as num).toDouble()), style: const TextStyle(color: LoudeyaTheme.accent, fontWeight: FontWeight.w800)),
                  StatutChip(statut: f['statut'] ?? 'en_attente'),
                ]),
              ]),
            );
          },
        ),
    ),
  );
}

// ─────────────────── DEVIS ───────────────────
class DevisScreen extends StatefulWidget {
  const DevisScreen({super.key});
  @override State<DevisScreen> createState() => _DevisState();
}
class _DevisState extends State<DevisScreen> {
  final _db = DatabaseService();
  List<Map<String, dynamic>> _devis = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final d = await _db.getDevisRaw(); if (mounted) setState(() => _devis = d); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(title: const Text('Devis'), backgroundColor: LoudeyaTheme.surface),
    body: RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
      child: _devis.isEmpty
        ? const EmptyState(message: 'Aucun devis', icon: Icons.request_quote_outlined)
        : ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _devis.length,
          itemBuilder: (_, i) {
            final d = _devis[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.border)),
              child: Row(children: [
                const Icon(Icons.request_quote_rounded, color: LoudeyaTheme.accent2, size: 36),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d['clientNom'] ?? '', style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                  Text(d['date'] ?? '', style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(fmtGNF((d['total'] as num).toDouble()), style: const TextStyle(color: LoudeyaTheme.accent2, fontWeight: FontWeight.w800)),
                  StatutChip(statut: d['statut'] ?? 'en_attente'),
                ]),
              ]),
            );
          },
        ),
    ),
  );
}

// ─────────────────── COMMANDES ───────────────────
class CommandesScreen extends StatefulWidget {
  const CommandesScreen({super.key});
  @override State<CommandesScreen> createState() => _CommandesState();
}
class _CommandesState extends State<CommandesScreen> {
  final _db = DatabaseService();
  List<Map<String, dynamic>> _commandes = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final c = await _db.getCommandesRaw(); if (mounted) setState(() => _commandes = c); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(title: const Text('Commandes'), backgroundColor: LoudeyaTheme.surface),
    body: RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
      child: _commandes.isEmpty
        ? const EmptyState(message: 'Aucune commande', icon: Icons.shopping_bag_outlined)
        : ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _commandes.length,
          itemBuilder: (_, i) {
            final c = _commandes[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.border)),
              child: Row(children: [
                const Icon(Icons.shopping_bag_rounded, color: LoudeyaTheme.warning, size: 36),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c['fournisseurNom'] ?? '', style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                  Text(c['date'] ?? '', style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                ])),
                StatutChip(statut: c['statut'] ?? 'en_attente'),
              ]),
            );
          },
        ),
    ),
  );
}

// ─────────────────── FOURNISSEURS ───────────────────
class FournisseursScreen extends StatefulWidget {
  const FournisseursScreen({super.key});
  @override State<FournisseursScreen> createState() => _FournisseursState();
}
class _FournisseursState extends State<FournisseursScreen> {
  final _db = DatabaseService();
  List<Fournisseur> _fournisseurs = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final f = await _db.getFournisseurs(); if (mounted) setState(() => _fournisseurs = f); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(title: const Text('Fournisseurs'), backgroundColor: LoudeyaTheme.surface),
    body: RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
      child: _fournisseurs.isEmpty
        ? const EmptyState(message: 'Aucun fournisseur', icon: Icons.local_shipping_outlined)
        : ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _fournisseurs.length,
          itemBuilder: (_, i) {
            final f = _fournisseurs[i];
            return Padding(padding: const EdgeInsets.only(bottom: 10),
              child: Slidable(
                endActionPane: ActionPane(motion: const DrawerMotion(), children: [
                  SlidableAction(onPressed: (_) async { await _db.deleteFournisseur(f.id); _load(); },
                    backgroundColor: LoudeyaTheme.danger, icon: Icons.delete_rounded, label: 'Suppr.'),
                ]),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.border)),
                  child: Row(children: [
                    CircleAvatar(backgroundColor: LoudeyaTheme.warning.withOpacity(0.15),
                      child: Text(f.nom[0].toUpperCase(), style: const TextStyle(color: LoudeyaTheme.warning, fontWeight: FontWeight.w700))),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(f.nom, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                      if (f.telephone.isNotEmpty) Text(f.telephone, style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                    ])),
                  ]),
                ),
              ),
            );
          },
        ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => _showForm(), icon: const Icon(Icons.add_rounded), label: const Text('Nouveau'),
    ),
  );

  void _showForm() {
    final nomC = TextEditingController(); final telC = TextEditingController();
    final emailC = TextEditingController(); final adrC = TextEditingController();
    final prodsC = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: LoudeyaTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Nouveau fournisseur', style: TextStyle(color: LoudeyaTheme.text, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          LField(label: 'Nom', controller: nomC, required: true),
          const SizedBox(height: 12),
          LField(label: 'Téléphone', controller: telC, keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          LField(label: 'Email', controller: emailC),
          const SizedBox(height: 12),
          LField(label: 'Adresse', controller: adrC),
          const SizedBox(height: 12),
          LField(label: 'Produits fournis', controller: prodsC),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () async {
              await _db.saveFournisseur(Fournisseur(id: _db.newId, nom: nomC.text, telephone: telC.text, email: emailC.text, adresse: adrC.text, produits: prodsC.text, createdAt: DateTime.now().toIso8601String()));
              if (mounted) { Navigator.pop(context); _load(); }
            }, child: const Text('Enregistrer'),
          )),
          const SizedBox(height: 8),
        ])),
      ),
    );
  }
}

// ─────────────────── DETTES ───────────────────
class DettesScreen extends StatefulWidget {
  const DettesScreen({super.key});
  @override State<DettesScreen> createState() => _DettesState();
}
class _DettesState extends State<DettesScreen> {
  final _db = DatabaseService();
  List<Dette> _dettes = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final d = await _db.getDettes(); if (mounted) setState(() => _dettes = d); }

  @override
  Widget build(BuildContext context) {
    final totalDu = _dettes.fold(0.0, (s, d) => s + d.restant);
    return Scaffold(
      backgroundColor: LoudeyaTheme.bg,
      appBar: AppBar(title: const Text('Dettes'), backgroundColor: LoudeyaTheme.surface),
      body: Column(children: [
        Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: LoudeyaTheme.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.danger.withOpacity(0.3))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('TOTAL DÛ', style: TextStyle(color: LoudeyaTheme.muted, letterSpacing: 1.5, fontSize: 11)),
            Text(fmtGNF(totalDu), style: const TextStyle(color: LoudeyaTheme.danger, fontWeight: FontWeight.w800, fontSize: 20)),
          ]),
        ),
        Expanded(child: RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
          child: _dettes.isEmpty
            ? const EmptyState(message: 'Aucune dette', icon: Icons.money_off_outlined)
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _dettes.length,
              itemBuilder: (_, i) {
                final d = _dettes[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.border)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(d.clientNom, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                      StatutChip(statut: d.statut),
                    ]),
                    const SizedBox(height: 6),
                    Text(d.description, style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Restant: ${fmtGNF(d.restant)}', style: const TextStyle(color: LoudeyaTheme.danger, fontWeight: FontWeight.w700)),
                      if (d.statut != 'payee') TextButton(
                        onPressed: () async { await _db.payerDette(d.id, d.restant); _load(); },
                        child: const Text('Marquer payée', style: TextStyle(color: LoudeyaTheme.accent)),
                      ),
                    ]),
                  ]),
                );
              },
            ),
        )),
      ]),
    );
  }
}

// ─────────────────── MOUVEMENTS ───────────────────
class MouvementsScreen extends StatefulWidget {
  const MouvementsScreen({super.key});
  @override State<MouvementsScreen> createState() => _MouvementsState();
}
class _MouvementsState extends State<MouvementsScreen> {
  final _db = DatabaseService();
  List<Mouvement> _mvts = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final m = await _db.getMouvements(); if (mounted) setState(() => _mvts = m); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(title: const Text('Mouvements stock'), backgroundColor: LoudeyaTheme.surface),
    body: RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
      child: _mvts.isEmpty
        ? const EmptyState(message: 'Aucun mouvement', icon: Icons.swap_vert_outlined)
        : ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _mvts.length,
          itemBuilder: (_, i) {
            final m = _mvts[i];
            final isEntree = m.type == 'entree';
            return Container(
              margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.border)),
              child: Row(children: [
                Icon(isEntree ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: isEntree ? LoudeyaTheme.accent : LoudeyaTheme.danger, size: 28),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m.produitNom, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                  Text('${m.motif} • ${m.date}', style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                ])),
                Text('${isEntree ? '+' : '-'}${m.quantite}',
                  style: TextStyle(color: isEntree ? LoudeyaTheme.accent : LoudeyaTheme.danger,
                    fontWeight: FontWeight.w800, fontSize: 18)),
              ]),
            );
          },
        ),
    ),
  );
}

// ─────────────────── PAIE ───────────────────
class PaieScreen extends StatefulWidget {
  const PaieScreen({super.key});
  @override State<PaieScreen> createState() => _PaieState();
}
class _PaieState extends State<PaieScreen> {
  final _db = DatabaseService();
  List<Employe> _employes = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final e = await _db.getEmployes(); if (mounted) setState(() => _employes = e); }

  @override
  Widget build(BuildContext context) {
    final totalSalaires = _employes.where((e) => e.statut == 'actif').fold(0.0, (s, e) => s + e.salaire);
    return Scaffold(
      backgroundColor: LoudeyaTheme.bg,
      appBar: AppBar(title: const Text('Paie & Employés'), backgroundColor: LoudeyaTheme.surface),
      body: Column(children: [
        Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: LoudeyaTheme.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.accent.withOpacity(0.2))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('MASSE SALARIALE / MOIS', style: TextStyle(color: LoudeyaTheme.muted, letterSpacing: 1.5, fontSize: 10)),
              Text(fmtGNF(totalSalaires), style: const TextStyle(color: LoudeyaTheme.accent, fontWeight: FontWeight.w800, fontSize: 20)),
            ]),
            Text('${_employes.where((e) => e.statut == "actif").length} actifs',
              style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 13)),
          ]),
        ),
        Expanded(child: RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
          child: _employes.isEmpty
            ? const EmptyState(message: 'Aucun employé', icon: Icons.badge_outlined)
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _employes.length,
              itemBuilder: (_, i) {
                final e = _employes[i];
                return Padding(padding: const EdgeInsets.only(bottom: 10),
                  child: Slidable(
                    endActionPane: ActionPane(motion: const DrawerMotion(), children: [
                      SlidableAction(onPressed: (_) async { await _db.deleteEmploye(e.id); _load(); },
                        backgroundColor: LoudeyaTheme.danger, icon: Icons.delete_rounded, label: 'Suppr.'),
                    ]),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: LoudeyaTheme.border)),
                      child: Row(children: [
                        CircleAvatar(backgroundColor: LoudeyaTheme.accent.withOpacity(0.12),
                          child: Text(e.nom[0].toUpperCase(), style: const TextStyle(color: LoudeyaTheme.accent, fontWeight: FontWeight.w700))),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(e.nom, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                          Text(e.poste, style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                        ])),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(fmtGNF(e.salaire), style: const TextStyle(color: LoudeyaTheme.accent, fontWeight: FontWeight.w700)),
                          StatutChip(statut: e.statut),
                        ]),
                      ]),
                    ),
                  ),
                );
              },
            ),
        )),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(), icon: const Icon(Icons.person_add_rounded), label: const Text('Employé'),
      ),
    );
  }

  void _showForm() {
    final nomC = TextEditingController(); final posteC = TextEditingController();
    final telC = TextEditingController(); final salaireC = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: LoudeyaTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Nouvel employé', style: TextStyle(color: LoudeyaTheme.text, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          LField(label: 'Nom', controller: nomC, required: true),
          const SizedBox(height: 12),
          LField(label: 'Poste', controller: posteC),
          const SizedBox(height: 12),
          LField(label: 'Téléphone', controller: telC, keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          LField(label: 'Salaire (GNF)', controller: salaireC, keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () async {
              await _db.saveEmploye(Employe(id: _db.newId, nom: nomC.text, poste: posteC.text, telephone: telC.text, statut: 'actif', salaire: double.tryParse(salaireC.text) ?? 0, dateEmbauche: DateTime.now().toIso8601String().split('T')[0], createdAt: DateTime.now().toIso8601String()));
              if (mounted) { Navigator.pop(context); _load(); }
            }, child: const Text('Enregistrer'),
          )),
          const SizedBox(height: 8),
        ])),
      ),
    );
  }
}

// ─────────────────── ALERTES ───────────────────
class AlertesScreen extends StatefulWidget {
  const AlertesScreen({super.key});
  @override State<AlertesScreen> createState() => _AlertesState();
}
class _AlertesState extends State<AlertesScreen> {
  final _db = DatabaseService();
  List<Produit> _alertes = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final p = await _db.getProduits();
    if (mounted) setState(() => _alertes = p.where((p) => p.stock <= p.stockMin).toList());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(title: const Text('Alertes Stock'), backgroundColor: LoudeyaTheme.surface),
    body: RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
      child: _alertes.isEmpty
        ? const EmptyState(message: 'Aucune alerte — tout est OK !', icon: Icons.check_circle_outline_rounded)
        : ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _alertes.length,
          itemBuilder: (_, i) {
            final p = _alertes[i];
            final critique = p.stock == 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: (critique ? LoudeyaTheme.danger : LoudeyaTheme.warning).withOpacity(0.5)),
              ),
              child: Row(children: [
                Icon(critique ? Icons.error_rounded : Icons.warning_rounded,
                  color: critique ? LoudeyaTheme.danger : LoudeyaTheme.warning, size: 32),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.nom, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                  Text(p.categorie, style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${p.stock}', style: TextStyle(color: critique ? LoudeyaTheme.danger : LoudeyaTheme.warning, fontSize: 22, fontWeight: FontWeight.w800)),
                  Text('min: ${p.stockMin}', style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 11)),
                ]),
              ]),
            );
          },
        ),
    ),
  );
}

// ─────────────────── RAPPORTS ───────────────────
class RapportsScreen extends StatefulWidget {
  const RapportsScreen({super.key});
  @override State<RapportsScreen> createState() => _RapportsState();
}
class _RapportsState extends State<RapportsScreen> {
  final _db = DatabaseService();
  Map<String, dynamic>? _stats;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final s = await _db.getDashStats(); if (mounted) setState(() => _stats = s); }

  @override
  Widget build(BuildContext context) {
    final s = _stats;
    return Scaffold(
      backgroundColor: LoudeyaTheme.bg,
      appBar: AppBar(title: const Text('Rapports'), backgroundColor: LoudeyaTheme.surface),
      body: s == null
        ? const Center(child: CircularProgressIndicator(color: LoudeyaTheme.accent))
        : RefreshIndicator(onRefresh: _load, color: LoudeyaTheme.accent,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            // Résumé financier
            const SectionHeader(title: '💰 Résumé financier'),
            const SizedBox(height: 12),
            GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
              children: [
                KpiCard(label: "CA AUJOURD'HUI", value: fmtGNF(s['caJour']), color: LoudeyaTheme.blue, icon: Icons.today_rounded),
                KpiCard(label: 'CA CE MOIS', value: fmtGNF(s['caMois']), color: LoudeyaTheme.accent2, icon: Icons.calendar_month_rounded),
                KpiCard(label: 'CA TOTAL', value: fmtGNF(s['caTotal']), color: LoudeyaTheme.warning, icon: Icons.trending_up_rounded),
                KpiCard(label: 'ALERTES', value: '${s['alertes']}', color: LoudeyaTheme.danger, icon: Icons.warning_rounded),
              ],
            ),
            const SizedBox(height: 24),
            // Graphique 30 jours
            const SectionHeader(title: '📊 CA — 30 derniers jours'),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: LoudeyaTheme.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                BarChart30(data: s['ca30'] as Map<String, double>),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text((s['ca30'] as Map<String, double>).keys.first,
                    style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 9)),
                  const Text("Aujourd'hui", style: TextStyle(color: LoudeyaTheme.muted, fontSize: 9)),
                ]),
              ]),
            ),
            const SizedBox(height: 80),
          ]),
        ),
    );
  }
}
