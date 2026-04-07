import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bottom sheet para selecionar unidade — inspirado no padrão Google/iOS.
class UnitPickerSheet extends StatelessWidget {
  final String title;
  final List<String> units;
  final String selected;
  final Color accentColor;
  final void Function(String) onSelected;

  const UnitPickerSheet({
    super.key,
    required this.title,
    required this.units,
    required this.selected,
    required this.accentColor,
    required this.onSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<String> units,
    required String selected,
    required Color accentColor,
    required void Function(String) onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UnitPickerSheet(
        title: title,
        units: units,
        selected: selected,
        accentColor: accentColor,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Units list ──────────────────────────────────────
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: units.length,
              itemBuilder: (ctx, i) {
                final unit = units[i];
                final isSelected = unit == selected;
                return _UnitTile(
                  unit: unit,
                  isSelected: isSelected,
                  accentColor: accentColor,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelected(unit);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  final String unit;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _UnitTile({
    required this.unit,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        color: isSelected
            ? accentColor.withValues(alpha: 0.06)
            : Colors.transparent,
        child: Row(
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.12)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected ? Icons.check_rounded : Icons.straighten_rounded,
                size: 18,
                color: isSelected ? accentColor : const Color(0xFFBDBDBD),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? accentColor : const Color(0xFF1A1A2E),
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Ativo',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
