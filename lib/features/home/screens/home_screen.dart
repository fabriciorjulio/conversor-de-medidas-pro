import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/converter_provider.dart';
import '../../converter/screens/converter_screen.dart';
import '../../history/screens/history_screen.dart';
import '../../financial/screens/juros_screen.dart';
import '../../financial/screens/poupanca_screen.dart';
import '../../financial/screens/fgts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: CustomScrollView(
        slivers: [
          // ── Header compacto ─────────────────────────────────
          SliverToBoxAdapter(child: _Header()),

          // ── Última conversão (se existir) ───────────────────
          SliverToBoxAdapter(
            child: Consumer<ConverterProvider>(
              builder: (_, p, __) {
                if (p.history.isEmpty) return const SizedBox.shrink();
                return _LastConversionCard(item: p.history.first);
              },
            ),
          ),

          // ── Seção MEDIDAS ────────────────────────────────────
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'MEDIDAS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A8FA8),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: _CategoriesList(categories: [
                MeasurementCategory.comprimento,
                MeasurementCategory.peso,
                MeasurementCategory.volume,
                MeasurementCategory.temperatura,
                MeasurementCategory.area,
                MeasurementCategory.velocidade,
                MeasurementCategory.dados,
                MeasurementCategory.tempo,
              ]),
            ),
          ),

          // ── Seção FINANCEIRO ────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const Text(
                    'FINANCEIRO 🇧🇷',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8A8FA8),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE65100),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'NOVO',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: _FinanceiroList()),
          ),

          // ── Histórico ───────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
            sliver: SliverToBoxAdapter(
              child: _HistoryTile(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Header compacto
// ─────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Converte Tudo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tudo offline, sem anúncios invasivos',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off_rounded,
                        color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text('Offline',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Última conversão — acesso rápido
// ─────────────────────────────────────────────────────────────────
class _LastConversionCard extends StatelessWidget {
  final ConversionResult item;
  const _LastConversionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.category.color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: () {
          context.read<ConverterProvider>().setCategory(item.category);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ConverterScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: color.withValues(alpha: 0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.category.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(item.category.emoji,
                      style: const TextStyle(fontSize: 17)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.fromValue} ${item.fromUnit}  →  ${item.toValue} ${item.toUnit}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Última conversão · ${item.category.label}',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9E9E9E)),
                    ),
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
// Lista de categorias — estilo iOS grouped list
// ─────────────────────────────────────────────────────────────────
class _CategoriesList extends StatelessWidget {
  final List<MeasurementCategory> categories;
  const _CategoriesList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: List.generate(categories.length, (i) {
            final cat = categories[i];
            final isLast = i == categories.length - 1;
            return _CategoryRow(category: cat, isLast: isLast);
          }),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final MeasurementCategory category;
  final bool isLast;
  const _CategoryRow({required this.category, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = category.color;

    return Column(
      children: [
        InkWell(
          onTap: () {
            context.read<ConverterProvider>().setCategory(category);
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 250),
                pageBuilder: (_, __, ___) => const ConverterScreen(),
                transitionsBuilder: (_, anim, __, child) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                  child: child,
                ),
              ),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                // Ícone circular pequeno
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: category.lightBackground,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Text(category.emoji,
                        style: const TextStyle(fontSize: 19)),
                  ),
                ),
                const SizedBox(width: 14),
                // Texto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category.unitSamples,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron
                Icon(Icons.chevron_right_rounded,
                    color: color.withValues(alpha: 0.5), size: 20),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 70,
            endIndent: 0,
            color: Color(0xFFF0F2F5),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Lista financeiro: moedas + cripto + calculadoras
// ─────────────────────────────────────────────────────────────────
class _FinanceiroList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const conversorCategories = [
      MeasurementCategory.moedas,
      MeasurementCategory.cripto,
    ];

    const calculadoras = [
      _CalcItem(
        emoji: '💸',
        label: 'Calculadora de Juros',
        subtitle: 'Simples e compostos',
        color: Color(0xFF1565C0),
        bg: Color(0xFFE8F0FE),
      ),
      _CalcItem(
        emoji: '🐷',
        label: 'Rendimento Poupança',
        subtitle: 'Simulação com SELIC',
        color: Color(0xFF2E7D32),
        bg: Color(0xFFE8F5E9),
      ),
      _CalcItem(
        emoji: '🏦',
        label: 'Calculadora de FGTS',
        subtitle: 'Saldo e multa rescisória',
        color: Color(0xFF37474F),
        bg: Color(0xFFECEFF1),
      ),
    ];

    final totalItems = conversorCategories.length + calculadoras.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Conversor rows (moedas, cripto)
            ...List.generate(conversorCategories.length, (i) {
              final cat = conversorCategories[i];
              final isLast = i == totalItems - 1;
              return _CategoryRow(category: cat, isLast: isLast);
            }),
            // Calculator rows
            ...List.generate(calculadoras.length, (i) {
              final item = calculadoras[i];
              final isLast =
                  (conversorCategories.length + i) == totalItems - 1;
              return _CalculadoraRow(item: item, isLast: isLast);
            }),
          ],
        ),
      ),
    );
  }
}

class _CalcItem {
  final String emoji;
  final String label;
  final String subtitle;
  final Color color;
  final Color bg;

  const _CalcItem({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.bg,
  });
}

class _CalculadoraRow extends StatelessWidget {
  final _CalcItem item;
  final bool isLast;
  const _CalculadoraRow({required this.item, required this.isLast});

  Widget _screenFor(BuildContext context) {
    switch (item.label) {
      case 'Calculadora de Juros':
        return const JurosScreen();
      case 'Rendimento Poupança':
        return const PoupancaScreen();
      default:
        return const FgtsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 250),
              pageBuilder: (_, __, ___) => _screenFor(context),
              transitionsBuilder: (_, anim, __, child) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                child: child,
              ),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.bg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Text(item.emoji,
                        style: const TextStyle(fontSize: 19)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF9E9E9E)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: item.color.withValues(alpha: 0.5), size: 20),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1,
              indent: 70,
              endIndent: 0,
              color: Color(0xFFF0F2F5)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Botão histórico
// ─────────────────────────────────────────────────────────────────
class _HistoryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConverterProvider>(
      builder: (context, p, _) {
        final count = p.history.length;
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HistoryScreen()),
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.history_rounded,
                      color: Color(0xFF0D47A1), size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Histórico',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      Text(
                        count == 0
                            ? 'Nenhuma conversão ainda'
                            : '$count conversão${count == 1 ? '' : 'ões'} recente${count == 1 ? '' : 's'}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF9E9E9E)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFFBDBDBD), size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
