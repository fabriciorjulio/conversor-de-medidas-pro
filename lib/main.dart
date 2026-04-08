import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/welcome_screen.dart';
import 'features/home/providers/converter_provider.dart';
import 'core/ads/ad_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/services/currency_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await MobileAds.instance.initialize();
  }

  // Check if welcome screen should show
  final prefs = await SharedPreferences.getInstance();
  final showWelcome = !(prefs.getBool('welcome_seen') ?? false);

  runApp(ConverteTudoApp(showWelcome: showWelcome));
}

void _fetchRates(ConverterProvider provider) {
  final svc = CurrencyService();
  svc.fetchMoedasRates().then((rates) {
    if (rates.isNotEmpty) provider.updateCurrencyRates(rates);
  });
  svc.fetchCryptoRates().then((rates) {
    if (rates.isNotEmpty) provider.updateCryptoRates(rates);
  });
}

class ConverteTudoApp extends StatelessWidget {
  final bool showWelcome;
  const ConverteTudoApp({super.key, required this.showWelcome});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) {
          final provider = ConverterProvider();
          _fetchRates(provider);
          return provider;
        }),
        Provider<AdManager>(create: (_) => AdManager()),
      ],
      child: MaterialApp(
        title: 'Converte Tudo',
        theme: AppTheme.lightTheme,
        home: showWelcome ? const WelcomeScreen() : const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
