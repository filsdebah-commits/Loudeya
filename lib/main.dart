import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/ventes/ventes_screen.dart';
import 'screens/produits/produits_screen.dart';
import 'screens/clients/clients_screen.dart';
import 'screens/secondary_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const LoudeyaApp());
}

class LoudeyaApp extends StatelessWidget {
  const LoudeyaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Loudeya',
    debugShowCheckedModeBanner: false,
    theme: LoudeyaTheme.dark,
    home: const MainShell(),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // Navigation principale (onglets bas)
  static const _mainScreens = [
    DashboardScreen(),
    VentesScreen(),
    ProduitsScreen(),
    ClientsScreen(),
    _MoreScreen(),
  ];

  static const _navItems = [
    NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
    NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale_rounded), label: 'Ventes'),
    NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2_rounded), label: 'Produits'),
    NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people_rounded), label: 'Clients'),
    NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'Plus'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _index, children: _mainScreens),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      destinations: _navItems,
      backgroundColor: LoudeyaTheme.surface,
      indicatorColor: LoudeyaTheme.accent.withOpacity(0.15),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}

// ── Écran "Plus" — accès aux modules secondaires ──
class _MoreScreen extends StatelessWidget {
  const _MoreScreen();

  static const _modules = [
    (Icons.description_rounded, 'Factures', LoudeyaTheme.blue, FacturesScreen()),
    (Icons.request_quote_rounded, 'Devis', LoudeyaTheme.accent2, DevisScreen()),
    (Icons.shopping_bag_rounded, 'Commandes', LoudeyaTheme.warning, CommandesScreen()),
    (Icons.local_shipping_rounded, 'Fournisseurs', LoudeyaTheme.warning, FournisseursScreen()),
    (Icons.money_off_rounded, 'Dettes', LoudeyaTheme.danger, DettesScreen()),
    (Icons.swap_vert_rounded, 'Mouvements', LoudeyaTheme.accent3, MouvementsScreen()),
    (Icons.badge_rounded, 'Paie', LoudeyaTheme.accent, PaieScreen()),
    (Icons.warning_rounded, 'Alertes', LoudeyaTheme.danger, AlertesScreen()),
    (Icons.bar_chart_rounded, 'Rapports', LoudeyaTheme.blue, RapportsScreen()),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LoudeyaTheme.bg,
    appBar: AppBar(
      backgroundColor: LoudeyaTheme.surface,
      title: RichText(text: const TextSpan(children: [
        TextSpan(text: 'Lou', style: TextStyle(color: LoudeyaTheme.text, fontSize: 20, fontWeight: FontWeight.w800)),
        TextSpan(text: 'deya', style: TextStyle(color: LoudeyaTheme.accent, fontSize: 20, fontWeight: FontWeight.w800)),
      ])),
    ),
    body: GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9,
      ),
      itemCount: _modules.length,
      itemBuilder: (_, i) {
        final (icon, label, color, screen) = _modules[i];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
          child: Container(
            decoration: BoxDecoration(
              color: LoudeyaTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: LoudeyaTheme.border),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(color: LoudeyaTheme.text, fontWeight: FontWeight.w600, fontSize: 13)),
            ]),
          ),
        );
      },
    ),
  );
}
