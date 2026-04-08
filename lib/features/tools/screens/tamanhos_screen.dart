import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TamanhosScreen extends StatefulWidget {
  const TamanhosScreen({super.key});

  @override
  State<TamanhosScreen> createState() => _TamanhosScreenState();
}

class _TamanhosScreenState extends State<TamanhosScreen> with SingleTickerProviderStateMixin {
  static const _color = Color(0xFF00695C);

  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // Roupa Masculina: BR → US → EU
  static const _roupaMasc = [
    ['PP', 'XS', '44'],
    ['P', 'S', '46'],
    ['M', 'M', '48-50'],
    ['G', 'L', '52-54'],
    ['GG', 'XL', '56'],
    ['XGG', 'XXL', '58-60'],
    ['XXGG', '3XL', '62'],
  ];

  // Roupa Feminina: BR → US → EU
  static const _roupaFem = [
    ['PP', 'XS', '34'],
    ['P', 'S', '36'],
    ['M', 'M', '38-40'],
    ['G', 'L', '42-44'],
    ['GG', 'XL', '46'],
    ['XGG', 'XXL', '48-50'],
  ];

  // Calçado Masculino: BR → US → EU
  static const _calcadoMasc = [
    ['37', '5.5', '38'],
    ['38', '6', '39'],
    ['39', '7', '40'],
    ['40', '7.5', '41'],
    ['41', '8.5', '42'],
    ['42', '9', '43'],
    ['43', '10', '44'],
    ['44', '11', '45'],
    ['45', '12', '46'],
  ];

  // Calçado Feminino: BR → US → EU
  static const _calcadoFem = [
    ['33', '4', '34'],
    ['34', '5', '35'],
    ['35', '6', '36'],
    ['36', '6.5', '37'],
    ['37', '7', '38'],
    ['38', '8', '39'],
    ['39', '8.5', '40'],
    ['40', '9.5', '41'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: Text('Tamanhos BR / US / EU', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        backgroundColor: _color,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.person_rounded, size: 18), text: 'Roupa'),
            Tab(icon: Icon(Icons.man_rounded, size: 18), text: 'Calçado M'),
            Tab(icon: Icon(Icons.woman_rounded, size: 18), text: 'Calçado F'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _RoupasTab(),
          _SizeTable(title: 'Calçado Masculino', data: _calcadoMasc, headers: const ['BR', 'US', 'EU']),
          _SizeTable(title: 'Calçado Feminino', data: _calcadoFem, headers: const ['BR', 'US', 'EU']),
        ],
      ),
    );
  }
}

class _RoupasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _SizeTable(title: 'Roupa Masculina', data: _TamanhosScreenState._roupaMasc, headers: const ['BR', 'US', 'EU']),
          const SizedBox(height: 20),
          _SizeTable(title: 'Roupa Feminina', data: _TamanhosScreenState._roupaFem, headers: const ['BR', 'US', 'EU']),
        ],
      ),
    );
  }
}

class _SizeTable extends StatelessWidget {
  final String title;
  final List<List<String>> data;
  final List<String> headers;
  const _SizeTable({required this.title, required this.data, required this.headers});

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
          const SizedBox(height: 8),
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF00695C).withValues(alpha:0.08),
            ),
            child: Row(
              children: headers.map((h) => Expanded(
                child: Text(h, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF00695C)),
                    textAlign: TextAlign.center),
              )).toList(),
            ),
          ),
          // Rows
          ...data.asMap().entries.map((e) {
            final idx = e.key;
            final row = e.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: idx.isEven ? Colors.white : Colors.grey[50],
                border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
              ),
              child: Row(
                children: row.asMap().entries.map((cell) => Expanded(
                  child: Text(
                    cell.value,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: cell.key == 0 ? FontWeight.w700 : FontWeight.w500,
                      color: cell.key == 0 ? const Color(0xFF00695C) : Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                )).toList(),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );

    // If used inside TabBarView (calçados), wrap in scroll
    if (title.startsWith('Calçado')) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: content,
      );
    }
    return content;
  }
}
