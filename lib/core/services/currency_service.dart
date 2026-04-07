import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService {
  static const Duration _cacheTTL = Duration(hours: 6);

  static const String _moedaUrl =
      'https://economia.awesomeapi.com.br/json/last/'
      'USD-BRL,EUR-BRL,GBP-BRL,JPY-BRL,CHF-BRL,CAD-BRL,AUD-BRL';

  static const String _cryptoUrl =
      'https://economia.awesomeapi.com.br/json/last/'
      'BTC-BRL,ETH-BRL,BNB-BRL,SOL-BRL,XRP-BRL,USDT-BRL';

  // Maps API code → display name used in kConversionFactors
  static const Map<String, String> _moedaNames = {
    'USD': 'Dólar (USD)',
    'EUR': 'Euro (EUR)',
    'GBP': 'Libra (GBP)',
    'JPY': 'Iene (JPY)',
    'CHF': 'Franco Suíço (CHF)',
    'CAD': 'Dólar Canadense (CAD)',
    'AUD': 'Dólar Australiano (AUD)',
  };

  static const Map<String, String> _cryptoNames = {
    'BTC': 'Bitcoin (BTC)',
    'ETH': 'Ethereum (ETH)',
    'BNB': 'BNB',
    'SOL': 'Solana (SOL)',
    'XRP': 'XRP',
    'USDT': 'USDT',
  };

  /// Returns {displayName: factor} where factor = 1/bidPrice (units per BRL).
  Future<Map<String, double>> fetchMoedasRates() =>
      _fetchRates(_moedaUrl, 'moedas', _moedaNames);

  Future<Map<String, double>> fetchCryptoRates() =>
      _fetchRates(_cryptoUrl, 'cripto', _cryptoNames);

  Future<Map<String, double>> _fetchRates(
    String url,
    String cachePrefix,
    Map<String, String> codeToName,
  ) async {
    final cached = await _getCached(cachePrefix);
    if (cached != null) return cached;

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final rates = _parse(data, codeToName);
        if (rates.isNotEmpty) {
          await _setCache(cachePrefix, rates);
          return rates;
        }
      }
    } catch (e) {
      debugPrint('CurrencyService [$cachePrefix] error: $e');
    }
    return {};
  }

  Map<String, double> _parse(
    Map<String, dynamic> data,
    Map<String, String> codeToName,
  ) {
    final result = <String, double>{};
    for (final entry in data.values) {
      final code = entry['code'] as String? ?? '';
      final name = codeToName[code];
      if (name == null) { continue; }
      final bid = double.tryParse(entry['bid']?.toString() ?? '');
      if (bid != null && bid > 0) {
        result[name] = 1.0 / bid;
      }
    }
    return result;
  }

  Future<Map<String, double>?> _getCached(String prefix) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ts = prefs.getInt('${prefix}_ts');
      if (ts == null) return null;
      if (DateTime.now().millisecondsSinceEpoch - ts >
          _cacheTTL.inMilliseconds) { return null; }
      final raw = prefs.getString('${prefix}_rates');
      if (raw == null) return null;
      final map = json.decode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } catch (_) {
      return null;
    }
  }

  Future<void> _setCache(String prefix, Map<String, double> rates) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${prefix}_rates', json.encode(rates));
      await prefs.setInt(
          '${prefix}_ts', DateTime.now().millisecondsSinceEpoch);
    } catch (_) {}
  }
}
