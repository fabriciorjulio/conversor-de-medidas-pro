import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/converter_provider.dart';
import '../../converter/screens/converter_screen.dart';
import '../../history/screens/history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Medidas Pro'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecione uma categoria:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  CategoryCard(
                    title: 'Comprimento',
                    icon: Icons.straighten,
                    category: MeasurementCategory.comprimento,
                  ),
                  CategoryCard(
                    title: 'Peso',
                    icon: Icons.monitor_weight,
                    category: MeasurementCategory.peso,
                  ),
                  CategoryCard(
                    title: 'Volume',
                    icon: Icons.local_drink,
                    category: MeasurementCategory.volume,
                  ),
                  CategoryCard(
                    title: 'Temperatura',
                    icon: Icons.thermostat,
                    category: MeasurementCategory.temperatura,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
              icon: const Icon(Icons.history),
              label: const Text('Ver Histórico'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final MeasurementCategory category;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          context.read<ConverterProvider>().setCategory(category);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ConverterScreen()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}