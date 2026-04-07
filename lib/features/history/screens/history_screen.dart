import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/providers/converter_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const Color _primary = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            actions: [
              Consumer<ConverterProvider>(
                builder: (context, provider, _) {
                  if (provider.history.isEmpty) return const SizedBox();
                  return TextButton.icon(
                    onPressed: () => _confirmClear(context, provider),
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white70, size: 18),
                    label: const Text(
                      'Limpar',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Histórico',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primary, Color(0xFF1565C0), Color(0xFF42A5F5)],
                  ),
                ),
              ),
            ),
          ),
          Consumer<ConverterProvider>(
            builder: (context, provider, _) {
              if (provider.history.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = provider.history[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Dismissible(
                          key: Key(
                              item.timestamp.millisecondsSinceEpoch.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => provider.removeHistoryAt(index),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB00020),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.white, size: 22),
                          ),
                          child: _HistoryItem(item: item),
                        ),
                      );
                    },
                    childCount: provider.history.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context, ConverterProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Limpar histórico?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Todas as conversões serão removidas permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB00020),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final ConversionResult item;

  const _HistoryItem({required this.item});

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    if (diff.inDays == 1) return 'ontem';
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    final catColor = item.category.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F0FE), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.category.icon, color: catColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF212121),
                    ),
                    children: [
                      TextSpan(
                        text: '${item.fromValue} ${item.fromUnit}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(
                        text: '  →  ',
                        style: TextStyle(color: Color(0xFF9E9E9E)),
                      ),
                      TextSpan(
                        text: '${item.toValue} ${item.toUnit}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: catColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(item.timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: Color(0xFFBDBDBD), size: 18),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 44,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nenhuma conversão ainda.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comece agora!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
