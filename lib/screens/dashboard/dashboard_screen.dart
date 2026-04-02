import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _db = DatabaseService();
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await _db.getDashStats();
    if (mounted) setState(() => _stats = s);
  }

  @override
  Widget build(BuildContext context) {
    final s = _stats;
    return Scaffold(
      backgroundColor: LoudeyaTheme.bg,
      body: RefreshIndicator(
        onRefresh: _load,
        color: LoudeyaTheme.accent,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: LoudeyaTheme.bg,
            flexibleSpace: FlexibleSpaceBar(
              title: RichText(text: const TextSpan(
                children: [
                  TextSpan(text: 'Lou', style: TextStyle(color: LoudeyaTheme.text, fontSize: 22, fontWeight: FontWeight.w800)),
                  TextSpan(text: 'deya', style: TextStyle(color: LoudeyaTheme.accent, fontSize: 22, fontWeight: FontWeight.w800)),
                ],
              )),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _load,
                color: LoudeyaTheme.muted,
              ),
            ],
          ),
          if (s == null)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: LoudeyaTheme.accent)),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(delegate: SliverChildListDelegate([

                // ── KPIs ──
                GridView.count(
                  crossAxisCount: 2, shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12, mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    KpiCard(label: 'PRODUITS', value: '${s['nbProduits']}',
                      sub: 'références', color: LoudeyaTheme.accent, icon: Icons.inventory_2_rounded),
                    KpiCard(label: 'CLIENTS', value: '${s['nbClients']}',
                      sub: 'enregistrés', color: LoudeyaTheme.accent3, icon: Icons.people_rounded),
                    KpiCard(label: "CA AUJOURD'HUI", value: fmtGNF(s['caJour']),
                      color: LoudeyaTheme.blue, icon: Icons.today_rounded),
                    KpiCard(label: 'CA CE MOIS', value: fmtGNF(s['caMois']),
                      color: LoudeyaTheme.accent2, icon: Icons.calendar_month_rounded),
                    KpiCard(label: 'CUMUL GÉNÉRAL', value: fmtGNF(s['caTotal']),
                      color: LoudeyaTheme.warning, icon: Icons.trending_up_rounded),
                    KpiCard(label: 'ALERTES STOCK', value: '${s['alertes']}',
                      sub: 'produits critiques', color: LoudeyaTheme.danger, icon: Icons.warning_rounded),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Graphique CA 30 jours ──
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: LoudeyaTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: LoudeyaTheme.border),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('CA — 30 DERNIERS JOURS',
                        style: TextStyle(color: LoudeyaTheme.muted, fontSize: 11, letterSpacing: 1.5)),
                      Text(fmtGNF((s['ca30'] as Map<String, double>).values.fold(0.0, (a, b) => a + b)),
                        style: const TextStyle(color: LoudeyaTheme.blue, fontSize: 14, fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 14),
                    BarChart30(data: s['ca30'] as Map<String, double>),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        (s['ca30'] as Map<String, double>).keys.first,
                        style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 9),
                      ),
                      const Text("Aujourd'hui",
                        style: TextStyle(color: LoudeyaTheme.muted, fontSize: 9)),
                    ]),
                  ]),
                ),

                const SizedBox(height: 80),
              ])),
            ),
        ]),
      ),
    );
  }
}
