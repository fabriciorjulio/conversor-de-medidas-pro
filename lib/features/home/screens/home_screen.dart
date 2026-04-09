import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/converter_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../converter/screens/converter_screen.dart';
import '../../history/screens/history_screen.dart';
import '../../financial/screens/juros_screen.dart';
import '../../financial/screens/poupanca_screen.dart';
import '../../financial/screens/fgts_screen.dart';
import '../../tools/screens/image_converter_screen.dart';
import '../../tools/screens/fipe_screen.dart';
import '../../tools/screens/commodities_screen.dart';
import '../../tools/screens/tamanhos_screen.dart';
import '../../tools/screens/pdf_converter_screen.dart';

// ─────────────────────────────────────────────────────────────────
// Unified search item model
// ─────────────────────────────────────────────────────────────────
class _SearchItem {
  final String emoji;
  final String label;
  final String subtitle;
  final Color color;
  final Color bg;
  final List<String> keywords;
  final Widget Function(BuildContext) onTap; // returns screen or calls provider

  const _SearchItem({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.bg,
    required this.keywords,
    required this.onTap,
  });

  bool matches(String q) {
    final lower = q.toLowerCase();
    return label.toLowerCase().contains(lower) ||
        subtitle.toLowerCase().contains(lower) ||
        keywords.any((k) => k.toLowerCase().contains(lower));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  // ── All measurement categories ──
  static const _medidas = [
    MeasurementCategory.comprimento,
    MeasurementCategory.peso,
    MeasurementCategory.volume,
    MeasurementCategory.temperatura,
    MeasurementCategory.area,
    MeasurementCategory.velocidade,
    MeasurementCategory.dados,
    MeasurementCategory.tempo,
    MeasurementCategory.culinaria,
  ];

  static const _financeiroCats = [
    MeasurementCategory.moedas,
    MeasurementCategory.cripto,
  ];

  // ── Tool items ──
  static final _tools = <_SearchItem>[
    _SearchItem(
      emoji: '🖼️', label: 'Conversor de Imagens', subtitle: 'JPG · PNG · WEBP · BMP · GIF',
      color: const Color(0xFF7B1FA2), bg: const Color(0xFFF3E5F5),
      keywords: ['imagem', 'foto', 'jpeg', 'png', 'webp', 'converter', 'image'],
      onTap: (_) => const ImageConverterScreen(),
    ),
    _SearchItem(
      emoji: '🚗', label: 'Tabela FIPE', subtitle: 'Valor de carros, motos, caminhões',
      color: const Color(0xFFE65100), bg: const Color(0xFFFBE9E7),
      keywords: ['fipe', 'carro', 'moto', 'veículo', 'preço', 'valor', 'automóvel', 'caminhão'],
      onTap: (_) => const FipeScreen(),
    ),
    _SearchItem(
      emoji: '🌾', label: 'Commodities', subtitle: 'Soja · Milho · Café · kg/saca',
      color: const Color(0xFF2E7D32), bg: const Color(0xFFE8F5E9),
      keywords: ['soja', 'milho', 'trigo', 'café', 'arroz', 'commodity', 'saca', 'grão', 'agrícola'],
      onTap: (_) => const CommoditiesScreen(),
    ),
    _SearchItem(
      emoji: '👕', label: 'Tamanhos', subtitle: 'Roupas e calçados BR · US · EU',
      color: const Color(0xFF00695C), bg: const Color(0xFFE0F2F1),
      keywords: ['roupa', 'calçado', 'sapato', 'tamanho', 'size', 'PP', 'GG', 'XL', 'número'],
      onTap: (_) => const TamanhosScreen(),
    ),
    _SearchItem(
      emoji: '📄', label: 'Conversor PDF', subtitle: 'Texto → PDF · Word → PDF · Imagem → PDF',
      color: const Color(0xFFC62828), bg: const Color(0xFFFFEBEE),
      keywords: ['pdf', 'word', 'docx', 'documento', 'texto', 'converter', 'arquivo'],
      onTap: (_) => const PdfConverterScreen(),
    ),
  ];

  static final _calculadoras = <_SearchItem>[
    _SearchItem(
      emoji: '💸', label: 'Calculadora de Juros', subtitle: 'Simples e compostos',
      color: const Color(0xFF1565C0), bg: const Color(0xFFE8F0FE),
      keywords: ['juros', 'simples', 'compostos', 'taxa', 'rendimento'],
      onTap: (_) => const JurosScreen(),
    ),
    _SearchItem(
      emoji: '🐷', label: 'Rendimento Poupança', subtitle: 'Simulação com SELIC',
      color: const Color(0xFF2E7D32), bg: const Color(0xFFE8F5E9),
      keywords: ['poupança', 'selic', 'rendimento', 'banco'],
      onTap: (_) => const PoupancaScreen(),
    ),
    _SearchItem(
      emoji: '🏦', label: 'Calculadora de FGTS', subtitle: 'Saldo e multa rescisória',
      color: const Color(0xFF37474F), bg: const Color(0xFFECEFF1),
      keywords: ['fgts', 'saldo', 'multa', 'rescisão', 'trabalhador'],
      onTap: (_) => const FgtsScreen(),
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _navigateTo(BuildContext ctx, Widget screen) {
    Navigator.push(ctx, PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    ));
  }

  void _openCategory(BuildContext ctx, MeasurementCategory cat) {
    ctx.read<ConverterProvider>().setCategory(cat);
    _navigateTo(ctx, const ConverterScreen());
  }

  // Filter helpers
  List<MeasurementCategory> get _filteredMedidas =>
      _query.isEmpty ? _medidas : _medidas.where((c) =>
          c.label.toLowerCase().contains(_query.toLowerCase()) ||
          c.unitSamples.toLowerCase().contains(_query.toLowerCase())
      ).toList();

  List<MeasurementCategory> get _filteredFinanceiro =>
      _query.isEmpty ? _financeiroCats : _financeiroCats.where((c) =>
          c.label.toLowerCase().contains(_query.toLowerCase()) ||
          c.unitSamples.toLowerCase().contains(_query.toLowerCase())
      ).toList();

  List<_SearchItem> get _filteredTools =>
      _query.isEmpty ? _tools : _tools.where((t) => t.matches(_query)).toList();

  List<_SearchItem> get _filteredCalcs =>
      _query.isEmpty ? _calculadoras : _calculadoras.where((t) => t.matches(_query)).toList();

  @override
  Widget build(BuildContext context) {
    final fMedidas = _filteredMedidas;
    final fFinanceiro = _filteredFinanceiro;
    final fTools = _filteredTools;
    final fCalcs = _filteredCalcs;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────
          SliverToBoxAdapter(child: _Header()),

          // ── Search bar ─────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(
              controller: _searchCtrl,
              onChanged: (q) => setState(() => _query = q),
            ),
          ),

          // ── Última conversão ───────────────────────────
          if (_query.isEmpty)
            SliverToBoxAdapter(
              child: Consumer<ConverterProvider>(
                builder: (_, p, __) {
                  if (p.history.isEmpty) return const SizedBox.shrink();
                  return _LastConversionCard(
                    item: p.history.first,
                    onTap: () => _openCategory(context, p.history.first.category),
                  );
                },
              ),
            ),

          // ── MEDIDAS ────────────────────────────────────
          if (fMedidas.isNotEmpty) ...[
            _SectionHeader(label: 'MEDIDAS', count: '${fMedidas.length}'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _GroupedList(
                  children: fMedidas.map((cat) => _CategoryRow(
                    category: cat,
                    onTap: () => _openCategory(context, cat),
                  )).toList(),
                ),
              ),
            ),
          ],

          // ── FINANCEIRO ─────────────────────────────────
          if (fFinanceiro.isNotEmpty || fCalcs.isNotEmpty) ...[
            _SectionHeader(label: 'FINANCEIRO', badge: '🇧🇷'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _GroupedList(
                  children: [
                    ...fFinanceiro.map((cat) => _CategoryRow(
                      category: cat,
                      onTap: () => _openCategory(context, cat),
                    )),
                    ...fCalcs.map((item) => _ToolRow(
                      item: item,
                      onTap: () => _navigateTo(context, item.onTap(context)),
                    )),
                  ],
                ),
              ),
            ),
          ],

          // ── FERRAMENTAS ────────────────────────────────
          if (fTools.isNotEmpty) ...[
            _SectionHeader(label: 'FERRAMENTAS'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _GroupedList(
                  children: fTools.map((item) => _ToolRow(
                    item: item,
                    onTap: () => _navigateTo(context, item.onTap(context)),
                  )).toList(),
                ),
              ),
            ),
          ],

          // ── Histórico ──────────────────────────────────
          if (_query.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
              sliver: SliverToBoxAdapter(child: _HistoryTile()),
            ),

          // Empty search state
          if (_query.isNotEmpty && fMedidas.isEmpty && fFinanceiro.isEmpty && fTools.isEmpty && fCalcs.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text('Nenhum resultado para "$_query"',
                        style: GoogleFonts.inter(fontSize: 15, color: Colors.grey[500])),
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
// Search bar persistent header delegate
// ─────────────────────────────────────────────────────────────────
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBarDelegate({required this.controller, required this.onChanged});

  @override
  double get minExtent => 68;
  @override
  double get maxExtent => 68;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF2F4F7),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.inter(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Buscar conversor, ferramenta...',
          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 15),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D47A1)),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () { controller.clear(); onChanged(''); },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final String? count;
  final String? badge;
  const _SectionHeader({required this.label, this.count, this.badge});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Text(label, style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: Color(0xFF8A8FA8), letterSpacing: 1.0,
            )),
            if (count != null) ...[
              const SizedBox(width: 6),
              Text(count!, style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFBDBDBD),
              )),
            ],
            if (badge != null) ...[
              const SizedBox(width: 8),
              if (badge == 'NOVO')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('NOVO', style: TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: 0.5,
                  )),
                )
              else
                Text(badge!, style: const TextStyle(fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Grouped list container (iOS-style)
// ─────────────────────────────────────────────────────────────────
class _GroupedList extends StatelessWidget {
  final List<Widget> children;
  const _GroupedList({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(
          color: Colors.black.withValues(alpha:0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        )],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: List.generate(children.length, (i) {
            return Column(
              children: [
                children[i],
                if (i < children.length - 1)
                  const Divider(height: 1, indent: 70, endIndent: 0, color: Color(0xFFF0F2F5)),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Category row (for measurement + financial categories)
// ─────────────────────────────────────────────────────────────────
class _CategoryRow extends StatelessWidget {
  final MeasurementCategory category;
  final VoidCallback onTap;
  const _CategoryRow({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: category.lightBackground,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(child: Text(category.emoji, style: const TextStyle(fontSize: 19))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.label, style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E),
                  )),
                  const SizedBox(height: 2),
                  Text(category.unitSamples, style: const TextStyle(
                    fontSize: 12, color: Color(0xFF9E9E9E),
                  )),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: category.color.withValues(alpha:0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Tool row (for tools + calculadoras)
// ─────────────────────────────────────────────────────────────────
class _ToolRow extends StatelessWidget {
  final _SearchItem item;
  final VoidCallback onTap;
  const _ToolRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: item.bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 19))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E),
                  )),
                  const SizedBox(height: 2),
                  Text(item.subtitle, style: const TextStyle(
                    fontSize: 12, color: Color(0xFF9E9E9E),
                  )),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: item.color.withValues(alpha:0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Header menu (theme toggle + logout)
// ─────────────────────────────────────────────────────────────────
class _HeaderMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 24),
      onSelected: (value) {
        if (value == 'theme') {
          context.read<ThemeProvider>().toggleTheme();
        } else if (value == 'exit') {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Sair do app?'),
              content: const Text('Tem certeza que deseja sair?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    SystemNavigator.pop();
                  },
                  child: const Text('Sair', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'theme',
          child: Row(
            children: [
              Icon(
                context.watch<ThemeProvider>().isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(context.watch<ThemeProvider>().isDarkMode ? 'Modo claro' : 'Modo escuro'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'exit',
          child: Row(
            children: const [
              Icon(Icons.logout_rounded, size: 20, color: Colors.red),
              SizedBox(width: 12),
              Text('Sair', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF0A3D91), Color(0xFF0D47A1), Color(0xFF1976D2)],
          stops: [0.0, 0.4, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text('⇄', style: TextStyle(fontSize: 20, color: Colors.white))),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Converte Tudo', style: TextStyle(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5,
                    )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.offline_bolt_rounded, color: Colors.white, size: 13),
                        SizedBox(width: 4),
                        Text('Offline', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _HeaderMenu(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatChip(icon: Icons.straighten_rounded, label: '20+ conversores'),
                  const SizedBox(width: 8),
                  _StatChip(icon: Icons.build_rounded, label: '5 ferramentas'),
                  const SizedBox(width: 8),
                  _StatChip(icon: Icons.account_balance_rounded, label: 'FGTS · CDI'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha:0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white.withValues(alpha:0.85), size: 14),
            const SizedBox(width: 5),
            Flexible(
              child: Text(label, style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha:0.85),
              ), overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Last conversion card
// ─────────────────────────────────────────────────────────────────
class _LastConversionCard extends StatelessWidget {
  final ConversionResult item;
  final VoidCallback onTap;
  const _LastConversionCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = item.category.color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha:0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: item.category.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text(item.category.emoji, style: const TextStyle(fontSize: 17))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.fromValue} ${item.fromUnit}  →  ${item.toValue} ${item.toUnit}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text('Última conversão · ${item.category.label}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.replay_rounded, color: color, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// History tile
// ─────────────────────────────────────────────────────────────────
class _HistoryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConverterProvider>(
      builder: (context, p, _) {
        final count = p.history.length;
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.history_rounded, color: Color(0xFF0D47A1), size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Histórico', style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E),
                      )),
                      Text(
                        count == 0 ? 'Nenhuma conversão ainda' : '$count conversão${count == 1 ? '' : 'ões'} recente${count == 1 ? '' : 's'}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFFBDBDBD), size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
