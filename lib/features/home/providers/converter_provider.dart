import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/conversion.dart';
import '../../../core/constants/units.dart';

// Re-export for backward compatibility (tests import from this file)
export '../models/conversion.dart';

class ConverterProvider extends ChangeNotifier {
  MeasurementCategory _currentCategory = MeasurementCategory.comprimento;
  String _fromUnit = 'metro';
  String _toUnit = 'centímetro';
  String _inputValue = '';
  String _result = '';
  List<ConversionResult> _history = [];
  int _interactionCount = 0;

  // Live rates: {displayName: factor (units per BRL)}
  Map<String, double> _currencyOverrides = {};
  Map<String, double> _cryptoOverrides = {};

  static const int _interstitialTriggerCount = 5;
  static const String _historyKey = 'conversion_history';

  MeasurementCategory get currentCategory => _currentCategory;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  String get inputValue => _inputValue;
  String get result => _result;
  List<ConversionResult> get history => List.unmodifiable(_history);
  bool get shouldShowInterstitial =>
      _interactionCount >= _interstitialTriggerCount;

  ConverterProvider() {
    _loadHistory();
  }

  void updateCurrencyRates(Map<String, double> rates) {
    _currencyOverrides = Map.from(rates);
    if (_currentCategory == MeasurementCategory.moedas) _performConversion();
    notifyListeners();
  }

  void updateCryptoRates(Map<String, double> rates) {
    _cryptoOverrides = Map.from(rates);
    if (_currentCategory == MeasurementCategory.cripto) _performConversion();
    notifyListeners();
  }

  Map<String, double> _getFactors(MeasurementCategory category) {
    if (category == MeasurementCategory.moedas &&
        _currencyOverrides.isNotEmpty) {
      return {...kConversionFactors[category]!, ..._currencyOverrides};
    }
    if (category == MeasurementCategory.cripto && _cryptoOverrides.isNotEmpty) {
      return {...kConversionFactors[category]!, ..._cryptoOverrides};
    }
    return kConversionFactors[category]!;
  }

  List<String> getUnitsForCategory(MeasurementCategory category) {
    return _getFactors(category).keys.toList();
  }

  void setCategory(MeasurementCategory category) {
    _currentCategory = category;
    final defaults = kCategoryDefaults[category]!;
    _fromUnit = defaults[0];
    _toUnit = defaults[1];
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
    // Accept comma as decimal separator (Brazilian standard)
    _inputValue = value.replaceAll(',', '.');
    _performConversion();
    _incrementInteractionCount();
    notifyListeners();
  }

  void swapUnits() {
    final tempUnit = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = tempUnit;

    // Swap values too: result becomes new input
    if (_result.isNotEmpty && _result != 'Valor inválido') {
      _inputValue = _result;
    }
    _performConversion();
    notifyListeners();
  }

  String shareResult() {
    if (_result.isEmpty || _result == 'Valor inválido') return '';
    return '$_inputValue $_fromUnit = $_result $_toUnit (Converte Tudo)';
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

    double convertedValue;
    if (_currentCategory == MeasurementCategory.temperatura) {
      convertedValue =
          _convertTemperature(inputDouble, _fromUnit, _toUnit);
    } else {
      final factors = _getFactors(_currentCategory);
      final fromFactor = factors[_fromUnit]!;
      final toFactor = factors[_toUnit]!;
      final baseValue = inputDouble / fromFactor;
      convertedValue = baseValue * toFactor;
    }

    // Format result with appropriate precision
    final abs = convertedValue.abs();
    if (abs > 1e12 || (abs < 1e-6 && abs > 0)) {
      _result = convertedValue.toStringAsExponential(4);
    } else if (abs < 0.01 && abs > 0) {
      _result = convertedValue.toStringAsFixed(8);
    } else if (abs < 1 && abs > 0) {
      _result = convertedValue.toStringAsFixed(4);
    } else {
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

  void removeHistoryAt(int index) {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      _persistHistory();
      notifyListeners();
    }
  }

  void clearHistory() {
    _history.clear();
    _persistHistory();
    notifyListeners();
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
        _history =
            historyList.map((item) => ConversionResult.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao carregar histórico: $e');
    }
  }

  Future<void> _persistHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson =
          json.encode(_history.map((e) => e.toJson()).toList());
      await prefs.setString(_historyKey, historyJson);
    } catch (e) {
      debugPrint('Erro ao salvar histórico: $e');
    }
  }
}
