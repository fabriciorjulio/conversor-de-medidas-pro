import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Format a double as BRL currency string (e.g. "R$ 1.234,56").
String fmtBrl(double v) {
  final abs = v.abs();
  final raw = abs.toStringAsFixed(2);
  // Insert thousand separators
  final parts = raw.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]}.',
  );
  final formatted = '$intPart,${parts[1]}';
  return v < 0 ? '-R\$ $formatted' : 'R\$ $formatted';
}

// ─────────────────────────────────────────────────────────────────
// Shared widgets for financial calculator screens
// ─────────────────────────────────────────────────────────────────

class CalcInputCard extends StatelessWidget {
  final List<Widget> children;

  const CalcInputCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class CalcInputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final String? prefix;
  final String? suffix;
  final ValueChanged<String> onChanged;

  const CalcInputField({
    super.key,
    required this.ctrl,
    required this.label,
    required this.hint,
    this.prefix,
    this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFFADADB5),
              letterSpacing: 1.0),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
          ],
          onChanged: onChanged,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE0E0E0)),
            prefixText: prefix != null ? '$prefix ' : null,
            suffixText: suffix,
            prefixStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9E9E9E)),
            suffixStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9E9E9E)),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
      ],
    );
  }
}

class CalcResultCard extends StatelessWidget {
  final Color color;
  final List<CalcResultRow> rows;

  const CalcResultCard({super.key, required this.color, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          return Column(
            children: [
              rows[i],
              if (i < rows.length - 1)
                const Divider(height: 20, color: Color(0xFFF0F2F5)),
            ],
          );
        }),
      ),
    );
  }
}

class CalcResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final Color color;

  const CalcResultRow({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF757575),
                fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontSize: highlight ? 20 : 15,
            fontWeight: FontWeight.w800,
            color: highlight ? color : const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class CalcDisclaimer extends StatelessWidget {
  const CalcDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082), width: 1),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 15, color: Color(0xFFF9A825)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Valores simulados para fins educacionais. '
              'Não constitui recomendação de investimento. '
              'Consulte um profissional antes de investir.',
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF795548),
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class CalcInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const CalcInfoChip(
      {super.key, required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color.withValues(alpha: 0.7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  color: color.withValues(alpha: 0.8),
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class CalcToggleCard extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool isRight;
  final Color color;
  final ValueChanged<bool> onChanged;

  const CalcToggleCard({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.isRight,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          _ToggleBtn(
            label: leftLabel,
            selected: !isRight,
            color: color,
            isLeft: true,
            onTap: () {
              if (isRight) onChanged(false);
            },
          ),
          _ToggleBtn(
            label: rightLabel,
            selected: isRight,
            color: color,
            isLeft: false,
            onTap: () {
              if (!isRight) onChanged(true);
            },
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final bool isLeft;
  final VoidCallback onTap;

  const _ToggleBtn({
    required this.label,
    required this.selected,
    required this.color,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            borderRadius: BorderRadius.horizontal(
              left: isLeft ? const Radius.circular(12) : Radius.zero,
              right: !isLeft ? const Radius.circular(12) : Radius.zero,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF8A8FA8),
            ),
          ),
        ),
      ),
    );
  }
}

class CalcSmallToggle extends StatelessWidget {
  final String left;
  final String right;
  final bool isRight;
  final Color color;
  final ValueChanged<bool> onChanged;

  const CalcSmallToggle({
    super.key,
    required this.left,
    required this.right,
    required this.isRight,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SmallBtn(
              label: left,
              selected: !isRight,
              color: color,
              onTap: () {
                if (isRight) onChanged(false);
              }),
          _SmallBtn(
              label: right,
              selected: isRight,
              color: color,
              onTap: () {
                if (!isRight) onChanged(true);
              }),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _SmallBtn({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF8A8FA8),
          ),
        ),
      ),
    );
  }
}
