import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

final _nf = NumberFormat('#,###', 'fr_FR');

String fmtGNF(double v) => '${_nf.format(v.round())} GNF';

// ── KPI Card ──
class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final Color color;
  final IconData icon;

  const KpiCard({
    super.key, required this.label, required this.value,
    this.sub, required this.color, required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: LoudeyaTheme.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border(top: BorderSide(color: color, width: 3)),
      boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: LoudeyaTheme.muted, fontSize: 11, letterSpacing: 1.5)),
      ]),
      const SizedBox(height: 10),
      Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
      if (sub != null) ...[
        const SizedBox(height: 4),
        Text(sub!, style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 11)),
      ],
    ]),
  );
}

// ── Section Header ──
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  const SectionHeader({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(
        color: LoudeyaTheme.text, fontSize: 16, fontWeight: FontWeight.w700,
      )),
      if (action != null) action!,
    ],
  );
}

// ── Chip statut ──
class StatutChip extends StatelessWidget {
  final String statut;
  const StatutChip({super.key, required this.statut});

  Color get _color => switch (statut) {
    'payee' || 'livre' || 'valide' => LoudeyaTheme.accent,
    'en_attente' || 'en_cours' => LoudeyaTheme.warning,
    'annule' => LoudeyaTheme.danger,
    _ => LoudeyaTheme.muted,
  };

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: _color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _color.withOpacity(0.3)),
    ),
    child: Text(statut.replaceAll('_', ' '),
      style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w700)),
  );
}

// ── Champ formulaire ──
class LField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool required;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const LField({
    super.key, required this.label, this.hint, this.controller,
    this.keyboardType, this.required = false, this.maxLines = 1,
    this.validator, this.onChanged,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    style: const TextStyle(color: LoudeyaTheme.text),
    validator: validator ?? (required ? (v) => (v == null || v.isEmpty) ? 'Requis' : null : null),
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label + (required ? ' *' : ''),
      hintText: hint,
    ),
  );
}

// ── Empty state ──
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  const EmptyState({super.key, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 64, color: LoudeyaTheme.muted.withOpacity(0.4)),
      const SizedBox(height: 16),
      Text(message, style: const TextStyle(color: LoudeyaTheme.muted, fontSize: 15)),
    ]),
  );
}

// ── Bar chart 30 jours ──
class BarChart30 extends StatelessWidget {
  final Map<String, double> data;
  const BarChart30({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final vals = data.values.toList();
    final maxVal = vals.fold(0.0, (a, b) => b > a ? b : a);
    final today = DateTime.now().toIso8601String().split('T')[0];

    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.entries.map((e) {
          final isToday = e.key == today;
          final h = maxVal > 0 ? (e.value / maxVal) : 0.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Tooltip(
                message: '${e.key}: ${fmtGNF(e.value)}',
                child: FractionallySizedBox(
                  heightFactor: h < 0.02 ? 0.02 : h,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday
                          ? LoudeyaTheme.blue
                          : e.value > 0
                              ? LoudeyaTheme.blue.withOpacity(0.55)
                              : LoudeyaTheme.surface3,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
