import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../home/providers/converter_provider.dart';
import '../../../shared/widgets/banner_ad_widget.dart';
import '../../../shared/widgets/unit_picker_sheet.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swapCtrl;
  late final Animation<double> _swapTurns;
  final TextEditingController _inputCtrl = TextEditingController();
  final FocusNode _inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _swapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _swapTurns = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _swapCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _swapCtrl.dispose();
    _inputCtrl.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  void _swap(ConverterProvider p) {
    HapticFeedback.lightImpact();
    _swapCtrl.forward(from: 0);
    p.swapUnits();
    _inputCtrl.value = TextEditingValue(
      text: p.inputValue,
      selection: TextSelection.collapsed(offset: p.inputValue.length),
    );
  }

  void _pickUnit({required bool isFrom, required ConverterProvider p}) {
    UnitPickerSheet.show(
      context: context,
      title: isFrom ? 'Converter de' : 'Converter para',
      units: p.getUnitsForCategory(p.currentCategory),
      selected: isFrom ? p.fromUnit : p.toUnit,
      accentColor: p.currentCategory.color,
      onSelected: isFrom ? p.setFromUnit : p.setToUnit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConverterProvider>(
      builder: (context, p, _) {
        final color = p.currentCategory.color;
        final bg = p.currentCategory.lightBackground;
        final grad = p.currentCategory.gradientColors;
        final hasResult =
            p.result.isNotEmpty && p.result != 'Valor inválido';
        final isError = p.result == 'Valor inválido';

        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F7),
          appBar: AppBar(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(p.currentCategory.emoji,
                    style: const TextStyle(fontSize: 17)),
                const SizedBox(width: 8),
                Text(
                  p.currentCategory.label,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Gradient stripe
              Container(
                height: 3,
                decoration:
                    BoxDecoration(gradient: LinearGradient(colors: grad)),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Column(
                    children: [
                      // ── Card principal ──────────────────────
                      _ConversionCard(
                        p: p,
                        color: color,
                        bg: bg,
                        swapTurns: _swapTurns,
                        inputCtrl: _inputCtrl,
                        inputFocus: _inputFocus,
                        isError: isError,
                        onSwap: () => _swap(p),
                        onFromTap: () => _pickUnit(isFrom: true, p: p),
                        onToTap: () => _pickUnit(isFrom: false, p: p),
                      ),

                      // ── Compartilhar ────────────────────────
                      if (hasResult) ...[
                        const SizedBox(height: 14),
                        _ShareButton(
                          color: color,
                          onTap: () => Share.share(p.shareResult()),
                        ),
                      ],

                      // ── Dica de uso ─────────────────────────
                      const SizedBox(height: 14),
                      _HintRow(color: color),
                    ],
                  ),
                ),
              ),

              const BannerAdWidget(),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Card único com DE + divisor + PARA
// ─────────────────────────────────────────────────────────────────
class _ConversionCard extends StatelessWidget {
  final ConverterProvider p;
  final Color color;
  final Color bg;
  final Animation<double> swapTurns;
  final TextEditingController inputCtrl;
  final FocusNode inputFocus;
  final bool isError;
  final VoidCallback onSwap;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;

  const _ConversionCard({
    required this.p,
    required this.color,
    required this.bg,
    required this.swapTurns,
    required this.inputCtrl,
    required this.inputFocus,
    required this.isError,
    required this.onSwap,
    required this.onFromTap,
    required this.onToTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── DE ──────────────────────────────────────────────
          _FieldSection(
            label: 'DE',
            color: color,
            onUnitTap: onFromTap,
            unitLabel: p.fromUnit,
            child: TextField(
              controller: inputCtrl,
              focusNode: inputFocus,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.5,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade200,
                  letterSpacing: -0.5,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: p.setInputValue,
            ),
          ),

          // ── Divisor + swap ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child:
                      Container(height: 1, color: const Color(0xFFF0F2F5)),
                ),
                const SizedBox(width: 12),
                Semantics(
                  label: 'Inverter unidades',
                  button: true,
                  child: GestureDetector(
                  onTap: onSwap,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: color.withValues(alpha: 0.25), width: 1.5),
                    ),
                    child: RotationTransition(
                      turns: swapTurns,
                      child: Icon(Icons.swap_vert_rounded,
                          color: color, size: 19),
                    ),
                  ),
                )),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      Container(height: 1, color: const Color(0xFFF0F2F5)),
                ),
              ],
            ),
          ),

          // ── PARA ─────────────────────────────────────────────
          _FieldSection(
            label: 'PARA',
            color: color,
            onUnitTap: onToTap,
            unitLabel: p.toUnit,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.15),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: anim, curve: Curves.easeOut)),
                  child: child,
                ),
              ),
              child: isError
                  ? const _ErrorRow(key: ValueKey('err'))
                  : Text(
                      key: ValueKey(p.result),
                      p.result.isEmpty ? '—' : p.result,
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: p.result.isEmpty
                            ? const Color(0xFFE0E0E0)
                            : color,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Seção de campo (DE / PARA)
// ─────────────────────────────────────────────────────────────────
class _FieldSection extends StatelessWidget {
  final String label;
  final Color color;
  final String unitLabel;
  final VoidCallback onUnitTap;
  final Widget child;

  const _FieldSection({
    required this.label,
    required this.color,
    required this.unitLabel,
    required this.onUnitTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFADADB5),
                  letterSpacing: 1.2,
                ),
              ),
              _UnitButton(
                  unit: unitLabel, color: color, onTap: onUnitTap),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Botão de unidade
// ─────────────────────────────────────────────────────────────────
class _UnitButton extends StatelessWidget {
  final String unit;
  final Color color;
  final VoidCallback onTap;

  const _UnitButton(
      {required this.unit, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Selecionar unidade: $unit',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(minHeight: 44),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(Icons.expand_more_rounded,
                  color: Colors.white, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Linha de erro
// ─────────────────────────────────────────────────────────────────
class _ErrorRow extends StatelessWidget {
  const _ErrorRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.error_outline_rounded,
            color: Color(0xFFB00020), size: 20),
        SizedBox(width: 8),
        Text(
          'Valor inválido',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFFB00020),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Botão compartilhar
// ─────────────────────────────────────────────────────────────────
class _ShareButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  const _ShareButton({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.ios_share_rounded, size: 17),
        label: const Text('Compartilhar resultado'),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Dica de uso
// ─────────────────────────────────────────────────────────────────
class _HintRow extends StatelessWidget {
  final Color color;
  const _HintRow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.touch_app_rounded,
            size: 14, color: color.withValues(alpha: 0.5)),
        const SizedBox(width: 5),
        const Text(
          'Toque na unidade para trocar',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFFADADB5),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
