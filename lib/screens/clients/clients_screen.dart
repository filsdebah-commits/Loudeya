import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/models.dart';
import '../../services/database_service.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});
  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final _db = DatabaseService();
  List<Client> _clients = [];
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final c = await _db.getClients();
    if (mounted) setState(() => _clients = c);
  }

  List<Client> get _filtered => _clients.where((c) =>
    c.nom.toLowerCase().contains(_search.toLowerCase()) ||
    c.telephone.contains(_search)
  ).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(title: const Text('Clients'), backgroundColor: LoudeyaTheme.surface,
      bottom: PreferredSize(preferredHeight: 60, child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: TextField(
          onChanged: (v) => setState(() => _search = v),
          style: const TextStyle(color: LoudeyaTheme.text),
          decoration: const InputDecoration(hintText: 'Rechercher…',
            prefixIcon: Icon(Icons.search, color: LoudeyaTheme.muted)),
        ),
      )),
    ),
    body: RefreshIndicator(
      onRefresh: _load, color: LoudeyaTheme.accent,
      child: _filtered.isEmpty
        ? const EmptyState(message: 'Aucun client', icon: Icons.people_outline)
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _filtered.length,
          itemBuilder: (_, i) {
            final c = _filtered[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Slidable(
                endActionPane: ActionPane(motion: const DrawerMotion(), children: [
                  SlidableAction(onPressed: (_) => _showForm(c),
                    backgroundColor: LoudeyaTheme.blue, icon: Icons.edit_rounded, label: 'Modifier'),
                  SlidableAction(onPressed: (_) async { await _db.deleteClient(c.id); _load(); },
                    backgroundColor: LoudeyaTheme.danger, icon: Icons.delete_rounded, label: 'Suppr.'),
                ]),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: LoudeyaTheme.surface, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: LoudeyaTheme.border),
                  ),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundColor: LoudeyaTheme.accent3.withOpacity(0.15),
                      child: Text(c.nom[0].toUpperCase(),
                        style: const TextStyle(color: LoudeyaTheme.accent3, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.nom, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w700)),
                      if (c.telephone.isNotEmpty)
                        Text(c.telephone, style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 12)),
                    ])),
                    const Icon(Icons.chevron_right_rounded, color: LoudeyaTheme.muted),
                  ]),
                ),
              ),
            );
          },
        ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => _showForm(null),
      icon: const Icon(Icons.person_add_rounded), label: const Text('Nouveau'),
    ),
  );

  void _showForm(Client? c) {
    final nomC = TextEditingController(text: c?.nom);
    final telC = TextEditingController(text: c?.telephone);
    final emailC = TextEditingController(text: c?.email);
    final adrC = TextEditingController(text: c?.adresse);
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
            Text(c == null ? 'Nouveau client' : 'Modifier client',
              style: const TextStyle(color: LoudeyaTheme.text, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            LField(label: 'Nom', controller: nomC, required: true),
            const SizedBox(height: 12),
            LField(label: 'Téléphone', controller: telC, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            LField(label: 'Email', controller: emailC, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            LField(label: 'Adresse', controller: adrC),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () async {
                if (!key.currentState!.validate()) return;
                await _db.saveClient(Client(
                  id: c?.id ?? _db.newId, nom: nomC.text,
                  telephone: telC.text, email: emailC.text, adresse: adrC.text,
                  createdAt: c?.createdAt ?? DateTime.now().toIso8601String(),
                ));
                if (mounted) { Navigator.pop(context); _load(); }
              },
              child: Text(c == null ? 'Enregistrer' : 'Modifier'),
            )),
            const SizedBox(height: 8),
          ])),
        ),
      ),
    );
  }
}
