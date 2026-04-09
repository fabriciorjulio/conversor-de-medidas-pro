import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'features/home/screens/splash_screen.dart';
import 'features/home/providers/converter_provider.dart';
import 'core/ads/ad_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/services/currency_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await MobileAds.instance.initialize();
  }

  runApp(const ConverteTudoApp());
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
  const ConverteTudoApp({super.key});

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
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
