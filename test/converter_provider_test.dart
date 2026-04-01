import 'package:flutter_test/flutter_test.dart';
import 'package:conversor_de_medidas_pro/features/home/providers/converter_provider.dart';

void main() {
  group('ConverterProvider', () {
    late ConverterProvider provider;

    setUp(() {
      provider = ConverterProvider();
    });

    test('deve inicializar com categoria comprimento', () {
      expect(provider.currentCategory, MeasurementCategory.comprimento);
      expect(provider.fromUnit, 'metro');
      expect(provider.toUnit, 'centímetro');
    });

    test('deve converter metros para centímetros corretamente', () {
      provider.setInputValue('1');
      expect(provider.result, '100.00');
    });

    test('deve converter centímetros para metros corretamente', () {
      provider.setFromUnit('centímetro');
      provider.setToUnit('metro');
      provider.setInputValue('100');
      expect(provider.result, '1.00');
    });

    test('deve converter temperatura Celsius para Fahrenheit', () {
      provider.setCategory(MeasurementCategory.temperatura);
      provider.setFromUnit('celsius');
      provider.setToUnit('fahrenheit');
      provider.setInputValue('0');
      expect(provider.result, '32.00');
    });

    test('deve converter temperatura Fahrenheit para Celsius', () {
      provider.setCategory(MeasurementCategory.temperatura);
      provider.setFromUnit('fahrenheit');
      provider.setToUnit('celsius');
      provider.setInputValue('32');
      expect(provider.result, '0.00');
    });

    test('deve retornar erro para valor inválido', () {
      provider.setInputValue('abc');
      expect(provider.result, 'Valor inválido');
    });

    test('deve limpar resultado quando input está vazio', () {
      provider.setInputValue('10');
      expect(provider.result, isNot(isEmpty));
      
      provider.setInputValue('');
      expect(provider.result, isEmpty);
    });

    test('deve salvar conversão no histórico', () {
      provider.setInputValue('1');
      expect(provider.history.length, 1);
      expect(provider.history.first.fromValue, '1');
      expect(provider.history.first.fromUnit, 'metro');
      expect(provider.history.first.toValue, '100.00');
      expect(provider.history.first.toUnit, 'centímetro');
    });

    test('deve limitar histórico a 10 itens', () {
      for (int i = 1; i <= 15; i++) {
        provider.setInputValue(i.toString());
      }
      expect(provider.history.length, 10);
    });

    test('deve incrementar contador de interações', () {
      expect(provider.shouldShowInterstitial, false);
      
      for (int i = 0; i < 5; i++) {
        provider.setInputValue(i.toString());
      }
      
      expect(provider.shouldShowInterstitial, true);
    });

    test('deve resetar contador de interações', () {
      for (int i = 0; i < 5; i++) {
        provider.setInputValue(i.toString());
      }
      
      expect(provider.shouldShowInterstitial, true);
      
      provider.resetInteractionCount();
      expect(provider.shouldShowInterstitial, false);
    });

    test('deve retornar unidades corretas para cada categoria', () {
      final comprimentoUnits = provider.getUnitsForCategory(MeasurementCategory.comprimento);
      expect(comprimentoUnits, contains('metro'));
      expect(comprimentoUnits, contains('centímetro'));
      expect(comprimentoUnits, contains('quilômetro'));
      
      final pesoUnits = provider.getUnitsForCategory(MeasurementCategory.peso);
      expect(pesoUnits, contains('quilograma'));
      expect(pesoUnits, contains('grama'));
      
      final volumeUnits = provider.getUnitsForCategory(MeasurementCategory.volume);
      expect(volumeUnits, contains('litro'));
      expect(volumeUnits, contains('mililitro'));
      
      final temperaturaUnits = provider.getUnitsForCategory(MeasurementCategory.temperatura);
      expect(temperaturaUnits, contains('celsius'));
      expect(temperaturaUnits, contains('fahrenheit'));
      expect(temperaturaUnits, contains('kelvin'));
    });
  });
}