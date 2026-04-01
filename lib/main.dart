import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/providers/converter_provider.dart';
import 'core/ads/ad_manager.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const ConversorDeMedidasApp());
}

class ConversorDeMedidasApp extends StatelessWidget {
  const ConversorDeMedidasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConverterProvider()),
        Provider<AdManager>(create: (_) => AdManager()),
      ],
      child: MaterialApp(
        title: 'Conversor de Medidas Pro',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}