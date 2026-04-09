import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/financial_widgets.dart';

class JurosScreen extends StatefulWidget {
  const JurosScreen({super.key});

  @override
  State<JurosScreen> createState() => _JurosScreenState();
}

class _JurosScreenState extends State<JurosScreen> {
  static const Color _color = Color(0xFF1565C0);

  final _principalCtrl = TextEditingController();
  final _taxaCtrl = TextEditingController();
  final _periodoCtrl = TextEditingController();
  final _cdiRateCtrl = TextEditingController(text: '13,65');

  bool _compostos = false;
  bool _taxaAnual = false;
  bool _periodoAnos = false;
  bool _useCdi = false;
  double _cdiPct = 100.0;

  double? _montante;
  double? _juros;
  double? _taxaEfetivaAnual;
  double? _principal;
  String? _overflowMsg;

  @override
  void dispose() {
    _principalCtrl.dispose();
    _taxaCtrl.dispose();
    _periodoCtrl.dispose();
    _cdiRateCtrl.dispose();
    super.dispose();
  }

  double _monthlyRate() {
    if (_useCdi) {
      final cdi =
          (double.tryParse(_cdiRateCtrl.text.replaceAll(',', '.')) ?? 13.65) *
              _cdiPct /
              100;
      return pow(1 + cdi / 100, 1 / 12).toDouble() - 1;
    } else {
      final raw =
          double.tryParse(_taxaCtrl.text.replaceAll(',', '.')) ?? 0;
      final r = raw / 100;
      return _taxaAnual ? pow(1 + r, 1 / 12).toDouble() - 1 : r;
    }
  }

  void _calcular() {
    final p = double.tryParse(_principalCtrl.text.replaceAll(',', '.'));
    final t = double.tryParse(_periodoCtrl.text.replaceAll(',', '.'));

    final rateOk = _useCdi
        ? (double.tryParse(_cdiRateCtrl.text.replaceAll(',', '.')) ?? 0) > 0
        : (double.tryParse(_taxaCtrl.text.replaceAll(',', '.')) ?? 0) > 0;

    if (p == null || t == null || p <= 0 || t <= 0 || !rateOk) {
      setState(() => _montante = null);
      return;
    }

    // Overflow protection
    if (p > 1e15 || t > 1200) {
      setState(() {
        _montante = null;
        _overflowMsg = 'Valor ou período muito grande. Reduza para calcular.';
      });
      return;
    } else {
      _overflowMsg = null;
    }

    final r = _monthlyRate();
    final double n = _periodoAnos ? t * 12 : t;

    final double montante = _compostos
        ? p * pow(1 + r, n).toDouble()
        : p * (1 + r * n);

    if (montante.isInfinite || montante.isNaN) {
      setState(() => _montante = null);
      return;
    }

    final double taxaEfetiva = _compostos
        ? (pow(1 + r, 12).toDouble() - 1) * 100
        : r * 12 * 100;

    setState(() {
      _principal = p;
      _montante = montante;
      _juros = montante - p;
      _taxaEfetivaAnual = taxaEfetiva;
    });
  }

  void _setQuickAmount(double v) {
    _principalCtrl.text =
        v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
    HapticFeedback.selectionClick();
    _calcular();
  }

  void _setQuickPeriod(int months) {
    setState(() {
      if (months % 12 == 0 && months >= 12) {
        _periodoAnos = true;
        _periodoCtrl.text = (months ~/ 12).toString();
      } else {
        _periodoAnos = false;
        _periodoCtrl.text = months.toString();
      }
    });
    HapticFeedback.selectionClick();
    _calcular();
  }

  // CDI effective rate display
  double get _cdiEffective {
    final cdi =
        (double.tryParse(_cdiRateCtrl.text.replaceAll(',', '.')) ?? 13.65);
    return cdi * _cdiPct / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: _color,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💸', style: TextStyle(fontSize: 17)),
            SizedBox(width: 8),
            Text('Calculadora de Juros',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Simples / Compostos ──────────────────────
                  CalcToggleCard(
                    leftLabel: 'Juros Simples',
                    rightLabel: 'Juros Compostos',
                    isRight: _compostos,
                    color: _color,
                    onChanged: (v) {
                      setState(() => _compostos = v);
                      _calcular();
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Capital ──────────────────────────────────
                  _Card(children: [
                    const _Label('CAPITAL INICIAL'),
                    const SizedBox(height: 8),
                    _BigNumField(
                      ctrl: _principalCtrl,
                      hint: '0',
                      prefix: 'R\$',
                      onChanged: (_) => _calcular(),
                    ),
                    const SizedBox(height: 12),
                    _QuickRow(
                      chips: const ['R\$ 1K', 'R\$ 5K', 'R\$ 10K', 'R\$ 50K'],
                      color: _color,
                      onTap: (i) =>
                          _setQuickAmount([1000, 5000, 10000, 50000][i].toDouble()),
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // ── Taxa ─────────────────────────────────────
                  _Card(children: [
                    const _Label('TAXA DE JUROS'),
                    const SizedBox(height: 10),
                    _SegToggle(
                      left: 'Taxa Manual',
                      right: '% do CDI',
                      isRight: _useCdi,
                      color: _color,
                      onChanged: (v) {
                        setState(() => _useCdi = v);
                        _calcular();
                      },
                    ),
                    const SizedBox(height: 16),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 220),
                      crossFadeState: _useCdi
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: _TaxaManualSection(
                        ctrl: _taxaCtrl,
                        taxaAnual: _taxaAnual,
                        color: _color,
                        onChanged: (_) => _calcular(),
                        onToggle: (v) {
                          setState(() => _taxaAnual = v);
                          _calcular();
                        },
                      ),
                      secondChild: _CdiSection(
                        cdiRateCtrl: _cdiRateCtrl,
                        cdiPct: _cdiPct,
                        cdiEffective: _cdiEffective,
                        color: _color,
                        onCdiRateChanged: (_) => _calcular(),
                        onSliderChanged: (v) {
                          setState(() => _cdiPct = v);
                          _calcular();
                        },
                        onPresetTap: (pct) {
                          setState(() => _cdiPct = pct.toDouble());
                          HapticFeedback.selectionClick();
                          _calcular();
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // ── Período ──────────────────────────────────
                  _Card(children: [
                    const _Label('PERÍODO'),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _BigNumField(
                            ctrl: _periodoCtrl,
                            hint: '12',
                            onChanged: (_) => _calcular(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        CalcSmallToggle(
                          left: 'meses',
                          right: 'anos',
                          isRight: _periodoAnos,
                          color: _color,
                          onChanged: (v) {
                            setState(() => _periodoAnos = v);
                            _calcular();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _QuickRow(
                      chips: const ['6M', '1 ano', '2 anos', '5 anos'],
                      color: _color,
                      onTap: (i) => _setQuickPeriod([6, 12, 24, 60][i]),
                    ),
                  ]),

                  // ── Resultado ────────────────────────────────
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: _montante != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: _ResultPanel(
                              principal: _principal!,
                              montante: _montante!,
                              juros: _juros!,
                              taxaEfetiva: _taxaEfetivaAnual!,
                              color: _color,
                            ),
                          )
                        : _overflowMsg != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.red.shade200, width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded,
                                          color: Colors.red[700], size: 20),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _overflowMsg!,
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 14),
                  const CalcInfoChip(
                    icon: Icons.lightbulb_outline_rounded,
                    text:
                        'CDBs geralmente rendem 100–110% do CDI. '
                        'LCI/LCA costumam render 80–92% do CDI com isenção de IR para PF.',
                    color: Color(0xFF1565C0),
                  ),
                  const SizedBox(height: 10),
                  const CalcDisclaimer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Seção taxa manual
// ─────────────────────────────────────────────────────────────────
class _TaxaManualSection extends StatelessWidget {
  final TextEditingController ctrl;
  final bool taxaAnual;
  final Color color;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> onToggle;

  const _TaxaManualSection({
    required this.ctrl,
    required this.taxaAnual,
    required this.color,
    required this.onChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _BigNumField(
            ctrl: ctrl,
            hint: '1,0',
            suffix: '%',
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12),
        CalcSmallToggle(
          left: 'a.m.',
          right: 'a.a.',
          isRight: taxaAnual,
          color: color,
          onChanged: onToggle,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Seção CDI
// ─────────────────────────────────────────────────────────────────
class _CdiSection extends StatelessWidget {
  final TextEditingController cdiRateCtrl;
  final double cdiPct;
  final double cdiEffective;
  final Color color;
  final ValueChanged<String> onCdiRateChanged;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<int> onPresetTap;

  const _CdiSection({
    required this.cdiRateCtrl,
    required this.cdiPct,
    required this.cdiEffective,
    required this.color,
    required this.onCdiRateChanged,
    required this.onSliderChanged,
    required this.onPresetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CDI current rate
        Row(
          children: [
            const Text('CDI atual:',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            SizedBox(
              width: 65,
              child: TextField(
                controller: cdiRateCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                ],
                onChanged: onCdiRateChanged,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E)),
                decoration: const InputDecoration(
                  suffixText: '%',
                  suffixStyle: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const Text('a.a.',
                style:
                    TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
          ],
        ),
        const SizedBox(height: 14),

        // Big display: X% do CDI = Y% a.a.
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${cdiPct.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'do CDI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9E9E9E),
              ),
            ),
            const Spacer(),
            Text(
              '≈ ${cdiEffective.toStringAsFixed(2)}% a.a.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),

        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.12),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.10),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            value: cdiPct,
            min: 50,
            max: 150,
            divisions: 200,
            onChanged: onSliderChanged,
          ),
        ),

        // Preset chips
        Row(
          children: [
            for (final pct in [80, 100, 110, 120])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onPresetTap(pct),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: cdiPct.round() == pct
                          ? color
                          : color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$pct%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: cdiPct.round() == pct
                            ? Colors.white
                            : color,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Taxa CDI: valor de referência. Edite para a taxa vigente.',
          style: TextStyle(fontSize: 10, color: Color(0xFFBDBDBD)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Painel de resultado
// ─────────────────────────────────────────────────────────────────
class _ResultPanel extends StatelessWidget {
  final double principal;
  final double montante;
  final double juros;
  final double taxaEfetiva;
  final Color color;

  const _ResultPanel({
    required this.principal,
    required this.montante,
    required this.juros,
    required this.taxaEfetiva,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final capitalPct = (principal / montante).clamp(0.0, 1.0);
    final jurosPct = (1 - capitalPct);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Montante destaque
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Montante final',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFADADB5),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 4),
                  Text(
                    fmtBrl(montante),
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: color,
                        letterSpacing: -0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+${(juros / principal * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar: capital vs juros
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Flexible(
                    flex: (capitalPct * 1000).round(),
                    child: Container(color: color),
                  ),
                  Flexible(
                    flex: (jurosPct * 1000).round(),
                    child: Container(color: color.withValues(alpha: 0.28)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Legend(color: color, label: 'Capital  ${(capitalPct * 100).toStringAsFixed(0)}%'),
              const SizedBox(width: 14),
              _Legend(
                  color: color.withValues(alpha: 0.28),
                  label: 'Juros  ${(jurosPct * 100).toStringAsFixed(0)}%'),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFF0F2F5)),
          ),

          // Detail rows
          _DetailRow(label: 'Juros ganhos', value: fmtBrl(juros)),
          const SizedBox(height: 10),
          _DetailRow(
            label: 'Taxa efetiva anual',
            value: '${taxaEfetiva.toStringAsFixed(2)}% a.a.',
          ),
          const SizedBox(height: 10),
          _DetailRow(
            label: 'Capital investido',
            value: fmtBrl(principal),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9E9E9E),
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

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
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E))),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Local reusable widgets
// ─────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFFADADB5),
            letterSpacing: 1.2));
  }
}

class _BigNumField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final String? prefix;
  final String? suffix;
  final ValueChanged<String> onChanged;

  const _BigNumField({
    required this.ctrl,
    required this.hint,
    this.prefix,
    this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
      ],
      onChanged: onChanged,
      style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
          letterSpacing: -0.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFFE8E8E8),
            letterSpacing: -0.5),
        prefixText: prefix != null ? '$prefix ' : null,
        suffixText: suffix,
        prefixStyle: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFFBDBDBD),
            letterSpacing: -0.5),
        suffixStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9E9E9E)),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
    );
  }
}

class _QuickRow extends StatelessWidget {
  final List<String> chips;
  final Color color;
  final ValueChanged<int> onTap;

  const _QuickRow(
      {required this.chips, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: List.generate(
        chips.length,
        (i) => GestureDetector(
          onTap: () => onTap(i),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              chips[i],
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _SegToggle extends StatelessWidget {
  final String left;
  final String right;
  final bool isRight;
  final Color color;
  final ValueChanged<bool> onChanged;

  const _SegToggle({
    required this.left,
    required this.right,
    required this.isRight,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _SegBtn(
              label: left,
              selected: !isRight,
              color: color,
              onTap: () {
                if (isRight) onChanged(false);
              }),
          _SegBtn(
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

class _SegBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _SegBtn({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color:
                  selected ? Colors.white : const Color(0xFF8A8FA8),
            ),
          ),
        ),
      ),
    );
  }
}
