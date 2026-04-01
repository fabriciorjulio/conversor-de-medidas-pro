import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum MeasurementCategory { comprimento, peso, volume, temperatura }

class ConversionResult {
  final String fromValue;
  final String fromUnit;
  final String toValue;
  final String toUnit;
  final MeasurementCategory category;
  final DateTime timestamp;

  const ConversionResult({
    required this.fromValue,
    required this.fromUnit,
    required this.toValue,
    required this.toUnit,
    required this.category,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'fromValue': fromValue,
        'fromUnit': fromUnit,
        'toValue': toValue,
        'toUnit': toUnit,
        'category': category.index,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory ConversionResult.fromJson(Map<String, dynamic> json) =>
      ConversionResult(
        fromValue: json['fromValue'],
        fromUnit: json['fromUnit'],
        toValue: json['toValue'],
        toUnit: json['toUnit'],
        category: MeasurementCategory.values[json['category']],
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      );
}

class ConverterProvider extends ChangeNotifier {
  MeasurementCategory _currentCategory = MeasurementCategory.comprimento;
  String _fromUnit = 'metro';
  String _toUnit = 'centímetro';
  String _inputValue = '';
  String _result = '';
  List<ConversionResult> _history = [];
  int _interactionCount = 0;

  static const int _interstitialTriggerCount = 5;
  static const String _historyKey = 'conversion_history';

  MeasurementCategory get currentCategory => _currentCategory;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  String get inputValue => _inputValue;
  String get result => _result;
  List<ConversionResult> get history => List.unmodifiable(_history);
  bool get shouldShowInterstitial => _interactionCount >= _interstitialTriggerCount;

  final Map<MeasurementCategory, Map<String, double>> _conversionFactors = {
    MeasurementCategory.comprimento: {
      'metro': 1.0,
      'centímetro': 100.0,
      'milímetro': 1000.0,
      'quilômetro': 0.001,
      'polegada': 39.3701,
      'pé': 3.28084,
    },
    MeasurementCategory.peso: {
      'quilograma': 1.0,
      'grama': 1000.0,
      'tonelada': 0.001,
      'libra': 2.20462,
      'onça': 35.274,
    },
    MeasurementCategory.volume: {
      'litro': 1.0,
      'mililitro': 1000.0,
      'metro cúbico': 0.001,
      'galão': 0.264172,
      'pinta': 2.11338,
    },
    MeasurementCategory.temperatura: {
      'celsius': 1.0,
      'fahrenheit': 1.0,
      'kelvin': 1.0,
    },
  };

  ConverterProvider() {
    _loadHistory();
  }

  List<String> getUnitsForCategory(MeasurementCategory category) {
    return _conversionFactors[category]?.keys.toList() ?? [];
  }

  void setCategory(MeasurementCategory category) {
    _currentCategory = category;
    final units = getUnitsForCategory(category);
    if (units.isNotEmpty) {
      _fromUnit = units.first;
      _toUnit = units.length > 1 ? units[1] : units.first;
    }
    _inputValue = '';
    _result = '';
    notifyListeners();
  }

  void setFromUnit(String unit) {
    _fromUnit = unit;
    _performConversion();
    notifyListeners();
  }

  void setToUnit(String unit) {
    _toUnit = unit;
    _performConversion();
    notifyListeners();
  }

  void setInputValue(String value) {
    _inputValue = value;
    _performConversion();
    _incrementInteractionCount();
    notifyListeners();
  }

  void _performConversion() {
    if (_inputValue.isEmpty) {
      _result = '';
      return;
    }

    final inputDouble = double.tryParse(_inputValue);
    if (inputDouble == null) {
      _result = 'Valor inválido';
      return;
    }

    if (_currentCategory == MeasurementCategory.temperatura) {
      _result = _convertTemperature(inputDouble, _fromUnit, _toUnit).toStringAsFixed(2);
    } else {
      final factors = _conversionFactors[_currentCategory]!;
      final fromFactor = factors[_fromUnit]!;
      final toFactor = factors[_toUnit]!;
      final baseValue = inputDouble / fromFactor;
      final convertedValue = baseValue * toFactor;
      _result = convertedValue.toStringAsFixed(2);
    }

    _saveConversion();
  }

  double _convertTemperature(double value, String from, String to) {
    if (from == to) return value;

    double celsius = value;
    if (from == 'fahrenheit') {
      celsius = (value - 32) * 5 / 9;
    } else if (from == 'kelvin') {
      celsius = value - 273.15;
    }

    if (to == 'fahrenheit') {
      return celsius * 9 / 5 + 32;
    } else if (to == 'kelvin') {
      return celsius + 273.15;
    }
    return celsius;
  }

  void _saveConversion() {
    if (_result.isEmpty || _result == 'Valor inválido') return;

    final conversion = ConversionResult(
      fromValue: _inputValue,
      fromUnit: _fromUnit,
      toValue: _result,
      toUnit: _toUnit,
      category: _currentCategory,
      timestamp: DateTime.now(),
    );

    _history.insert(0, conversion);
    if (_history.length > 10) {
      _history = _history.take(10).toList();
    }

    _persistHistory();
  }

  void _incrementInteractionCount() {
    _interactionCount++;
  }

  void resetInteractionCount() {
    _interactionCount = 0;
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);
      if (historyJson != null) {
        final List<dynamic> historyList = json.decode(historyJson);
        _history = historyList
            .map((item) => ConversionResult.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Erro ao carregar histórico: $e');
    }
  }

  Future<void> _persistHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(_history.map((e) => e.toJson()).toList());
      await prefs.setString(_historyKey, historyJson);
    } catch (e) {
      debugPrint('Erro ao salvar histórico: $e');
    }
  }

  void clearHistory() {
    _history.clear();
    _persistHistory();
    notifyListeners();
  }
}