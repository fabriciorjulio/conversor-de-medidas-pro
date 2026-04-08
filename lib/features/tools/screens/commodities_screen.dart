import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommoditiesScreen extends StatefulWidget {
  const CommoditiesScreen({super.key});

  @override
  State<CommoditiesScreen> createState() => _CommoditiesScreenState();
}

class _CommoditiesScreenState extends State<CommoditiesScreen> {
  static const _color = Color(0xFF2E7D32);
  static final _brl = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  // commodity → {sacaKg, refPrice per saca in BRL}
  static final _commodities = [
    _Commodity(name: 'Soja', emoji: '🫘', sacaKg: 60, refPrice: 128.0),
    _Commodity(name: 'Milho', emoji: '🌽', sacaKg: 60, refPrice: 58.0),
    _Commodity(name: 'Trigo', emoji: '🌾', sacaKg: 60, refPrice: 72.0),
    _Commodity(name: 'Café Arábica', emoji: '☕', sacaKg: 60, refPrice: 1350.0),
    _Commodity(name: 'Arroz', emoji: '🍚', sacaKg: 50, refPrice: 105.0),
    _Commodity(name: 'Algodão', emoji: '🧶', sacaKg: 15, refPrice: 128.0), // arroba
    _Commodity(name: 'Açúcar', emoji: '🍬', sacaKg: 50, refPrice: 155.0),
    _Commodity(name: 'Feijão', emoji: '🫘', sacaKg: 60, refPrice: 220.0),
  ];

  int _selectedIdx = 0;
  final _qtyCtrl = TextEditingController(text: '1');
  String _unit = 'saca';

  _Commodity get _sel => _commodities[_selectedIdx];

  double get _totalKg {
    final qty = double.tryParse(_qtyCtrl.text.replaceAll(',', '.')) ?? 0;
    switch (_unit) {
      case 'saca':
        return qty * _sel.sacaKg;
      case 'kg':
        return qty;
      case 'ton':
        return qty * 1000;
      default:
        return qty;
    }
  }

  double get _totalSacas => _totalKg / _sel.sacaKg;
  double get _totalTon => _totalKg / 1000;
  double get _totalValue => _totalSacas * _sel.refPrice;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: Text('Commodities', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        backgroundColor: _color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Commodity selector
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _commodities.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final c = _commodities[i];
                  final sel = i == _selectedIdx;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIdx = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      decoration: BoxDecoration(
                        color: sel ? _color : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: sel ? _color : Colors.grey[300]!),
                        boxShadow: sel
                            ? [BoxShadow(color: _color.withValues(alpha:0.3), blurRadius: 8, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(c.emoji, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(c.name, style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : Colors.grey[700],
                          ), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Price info
            _Card(child: Row(
              children: [
                Text(_sel.emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_sel.name, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
                    Text('1 saca = ${_sel.sacaKg} kg', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
                  ],
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_brl.format(_sel.refPrice), style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18, color: _color)),
                    Text('por saca', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
              ],
            )),
            const SizedBox(height: 16),
            // Input
            _Card(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantidade', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _qtyCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
                        onChanged: (_) => setState(() {}),
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: _color, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<String>(
                          value: _unit,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                          items: const [
                            DropdownMenuItem(value: 'saca', child: Text('Sacas')),
                            DropdownMenuItem(value: 'kg', child: Text('Kg')),
                            DropdownMenuItem(value: 'ton', child: Text('Ton')),
                          ],
                          onChanged: (v) => setState(() => _unit = v!),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
            const SizedBox(height: 20),
            // Results
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: _color.withValues(alpha:0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Text('Valor estimado', style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(_brl.format(_totalValue), style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 32, color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ResultPill(label: 'Sacas', value: _totalSacas.toStringAsFixed(2)),
                      _ResultPill(label: 'Kg', value: _totalKg.toStringAsFixed(1)),
                      _ResultPill(label: 'Ton', value: _totalTon.toStringAsFixed(3)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'R\$ ${(_sel.refPrice / _sel.sacaKg).toStringAsFixed(2)}/kg',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }
}

class _ResultPill extends StatelessWidget {
  final String label;
  final String value;
  const _ResultPill({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _Commodity {
  final String name;
  final String emoji;
  final double sacaKg;
  final double refPrice;
  const _Commodity({required this.name, required this.emoji, required this.sacaKg, required this.refPrice});
}
