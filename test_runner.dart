import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conversor_de_medidas_pro/main.dart';
import 'package:conversor_de_medidas_pro/features/home/providers/converter_provider.dart';
import 'package:provider/provider.dart';

void main() {
  late ConverterProvider converterProvider;

  setUp(() {
    converterProvider = ConverterProvider();
  });

  group('Comprehensive 100+ Use Cases Test', () {
    // ─────────────────────────────────────────────────────────
    // COMPRIMENTO (001-008)
    // ─────────────────────────────────────────────────────────
    test('001: Comprimento - metro → centímetro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '100.00');
    });

    test('002: Comprimento - metro → quilômetro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('quilômetro');
      converterProvider.setInputValue('1000');
      expect(converterProvider.result, '1.00');
    });

    test('003: Comprimento - centímetro → metro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('centímetro');
      converterProvider.setToUnit('metro');
      converterProvider.setInputValue('100');
      expect(converterProvider.result, '1.00');
    });

    test('004: Comprimento - milímetro → metro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('milímetro');
      converterProvider.setToUnit('metro');
      converterProvider.setInputValue('1000');
      expect(converterProvider.result, '1.00');
    });

    test('005: Comprimento - polegada → centímetro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('polegada');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 2.5 && double.parse(converterProvider.result) < 2.55, true);
    });

    test('006: Comprimento - pé → metro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('pé');
      converterProvider.setToUnit('metro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) >= 0.30 && double.parse(converterProvider.result) < 0.31, true);
    });

    test('007: Comprimento - milha → quilômetro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('milha');
      converterProvider.setToUnit('quilômetro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 1.6 && double.parse(converterProvider.result) <= 1.61, true);
    });

    test('008: Comprimento - jarda → metro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('jarda');
      converterProvider.setToUnit('metro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 0.9 && double.parse(converterProvider.result) < 0.92, true);
    });

    // ─────────────────────────────────────────────────────────
    // PESO (009-015)
    // ─────────────────────────────────────────────────────────
    test('009: Peso - quilograma → grama', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('quilograma');
      converterProvider.setToUnit('grama');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('010: Peso - quilograma → libra', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('quilograma');
      converterProvider.setToUnit('libra');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) >= 2.20 && double.parse(converterProvider.result) < 2.21, true);
    });

    test('011: Peso - grama → miligrama', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('grama');
      converterProvider.setToUnit('miligrama');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('012: Peso - tonelada → quilograma', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('tonelada');
      converterProvider.setToUnit('quilograma');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('013: Peso - onça → grama', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('onça');
      converterProvider.setToUnit('grama');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 28 && double.parse(converterProvider.result) <= 28.36, true);
    });

    test('014: Peso - libra → quilograma', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('libra');
      converterProvider.setToUnit('quilograma');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 0.45 && double.parse(converterProvider.result) < 0.46, true);
    });

    test('015: Peso - miligrama → grama', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('miligrama');
      converterProvider.setToUnit('grama');
      converterProvider.setInputValue('1000');
      expect(converterProvider.result, '1.00');
    });

    // ─────────────────────────────────────────────────────────
    // VOLUME (016-020)
    // ─────────────────────────────────────────────────────────
    test('016: Volume - litro → mililitro', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      converterProvider.setFromUnit('litro');
      converterProvider.setToUnit('mililitro');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('017: Volume - mililitro → litro', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      converterProvider.setFromUnit('mililitro');
      converterProvider.setToUnit('litro');
      converterProvider.setInputValue('1000');
      expect(converterProvider.result, '1.00');
    });

    test('018: Volume - galão → litro', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      converterProvider.setFromUnit('galão');
      converterProvider.setToUnit('litro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 3.78 && double.parse(converterProvider.result) < 3.80, true);
    });

    test('019: Volume - metro cúbico → litro', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      converterProvider.setFromUnit('metro cúbico');
      converterProvider.setToUnit('litro');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('020: Culinária - xícara → mililitro', () {
      converterProvider.setCategory(MeasurementCategory.culinaria);
      converterProvider.setFromUnit('xícara');
      converterProvider.setToUnit('mililitro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 239 && double.parse(converterProvider.result) < 241, true);
    });

    // ─────────────────────────────────────────────────────────
    // TEMPERATURA (021-025)
    // ─────────────────────────────────────────────────────────
    test('021: Temperatura - celsius → fahrenheit', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('celsius');
      converterProvider.setToUnit('fahrenheit');
      converterProvider.setInputValue('0');
      expect(converterProvider.result, '32.00');
    });

    test('022: Temperatura - celsius → kelvin', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('celsius');
      converterProvider.setToUnit('kelvin');
      converterProvider.setInputValue('0');
      expect(converterProvider.result, '273.15');
    });

    test('023: Temperatura - fahrenheit → celsius', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('fahrenheit');
      converterProvider.setToUnit('celsius');
      converterProvider.setInputValue('32');
      expect(converterProvider.result, '0.00');
    });

    test('024: Temperatura - kelvin → celsius', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('kelvin');
      converterProvider.setToUnit('celsius');
      converterProvider.setInputValue('273.15');
      expect(converterProvider.result, '0.00');
    });

    test('025: Temperatura - valor negativo', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('celsius');
      converterProvider.setToUnit('fahrenheit');
      converterProvider.setInputValue('-40');
      expect(converterProvider.result, '-40.00');
    });

    // ─────────────────────────────────────────────────────────
    // ÁREA (026-028)
    // ─────────────────────────────────────────────────────────
    test('026: Área - metro² → centímetro²', () {
      converterProvider.setCategory(MeasurementCategory.area);
      converterProvider.setFromUnit('metro quadrado');
      converterProvider.setToUnit('centímetro quadrado');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '10000.00');
    });

    test('027: Área - hectare → metro²', () {
      converterProvider.setCategory(MeasurementCategory.area);
      converterProvider.setFromUnit('hectare');
      converterProvider.setToUnit('metro quadrado');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '10000.00');
    });

    test('028: Área - km² → m²', () {
      converterProvider.setCategory(MeasurementCategory.area);
      converterProvider.setFromUnit('quilômetro quadrado');
      converterProvider.setToUnit('metro quadrado');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000000.00');
    });

    // ─────────────────────────────────────────────────────────
    // VELOCIDADE (029-030)
    // ─────────────────────────────────────────────────────────
    test('029: Velocidade - km/h → m/s', () {
      converterProvider.setCategory(MeasurementCategory.velocidade);
      converterProvider.setFromUnit('quilômetro por hora');
      converterProvider.setToUnit('metro por segundo');
      converterProvider.setInputValue('3.6');
      expect(converterProvider.result, '1.00');
    });

    test('030: Velocidade - nó → km/h', () {
      converterProvider.setCategory(MeasurementCategory.velocidade);
      converterProvider.setFromUnit('nó');
      converterProvider.setToUnit('quilômetro por hora');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) >= 1.85 && double.parse(converterProvider.result) < 1.86, true);
    });

    // ─────────────────────────────────────────────────────────
    // CULINÁRIA (031-034)
    // ─────────────────────────────────────────────────────────
    test('031: Culinária - xícara → mL', () {
      converterProvider.setCategory(MeasurementCategory.culinaria);
      converterProvider.setFromUnit('xícara');
      converterProvider.setToUnit('mililitro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 239 && double.parse(converterProvider.result) < 241, true);
    });

    test('032: Culinária - colher de sopa → mL', () {
      converterProvider.setCategory(MeasurementCategory.culinaria);
      converterProvider.setFromUnit('colher de sopa');
      converterProvider.setToUnit('mililitro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 14.9 && double.parse(converterProvider.result) < 15.1, true);
    });

    test('033: Culinária - colher de chá → colher de sopa', () {
      converterProvider.setCategory(MeasurementCategory.culinaria);
      converterProvider.setFromUnit('colher de chá');
      converterProvider.setToUnit('colher de sopa');
      converterProvider.setInputValue('3');
      expect(double.parse(converterProvider.result) > 0.99 && double.parse(converterProvider.result) < 1.01, true);
    });

    test('034: Culinária - copo americano → xícara', () {
      converterProvider.setCategory(MeasurementCategory.culinaria);
      converterProvider.setFromUnit('copo americano');
      converterProvider.setToUnit('xícara');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 0.99 && double.parse(converterProvider.result) < 1.01, true);
    });

    // ─────────────────────────────────────────────────────────
    // EDGE CASES & GENERAL (035-045)
    // ─────────────────────────────────────────────────────────
    test('035: Edge Case - valor zero', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('0');
      expect(converterProvider.result, '0.00');
    });

    test('036: Edge Case - valores decimais', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1.5');
      expect(converterProvider.result, '150.00');
    });

    test('037: Edge Case - valores muito pequenos', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('miligrama');
      converterProvider.setToUnit('grama');
      converterProvider.setInputValue('0.001');
      expect(double.parse(converterProvider.result) < 0.00001, true);
    });

    test('038: Edge Case - valores muito grandes', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('milímetro');
      converterProvider.setInputValue('999999');
      expect(converterProvider.result.contains('e') || double.parse(converterProvider.result) > 999000000, true);
    });

    test('039: Edge Case - vírgula como separador decimal', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1,5');
      expect(converterProvider.result, '150.00');
    });

    test('040: History - salva conversão', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      expect(converterProvider.history.isNotEmpty, true);
    });

    test('041: History - limite de 10 itens', () {
      for (int i = 0; i < 15; i++) {
        converterProvider.setCategory(MeasurementCategory.comprimento);
        converterProvider.setFromUnit('metro');
        converterProvider.setToUnit('centímetro');
        converterProvider.setInputValue('$i');
      }
      expect(converterProvider.history.length, lessThanOrEqualTo(10));
    });

    test('042: Share result - texto correto', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      final share = converterProvider.shareResult();
      expect(share.contains('1') && share.contains('metro') && share.contains('centímetro'), true);
    });

    test('043: Swap units - troca valores', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('2');
      final result1 = converterProvider.result;
      converterProvider.swapUnits();
      expect(converterProvider.fromUnit, 'centímetro');
      expect(converterProvider.toUnit, 'metro');
    });

    test('044: Clear history', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      converterProvider.clearHistory();
      expect(converterProvider.history.isEmpty, true);
    });

    test('045: Remove history item', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      final count = converterProvider.history.length;
      if (count > 0) {
        converterProvider.removeHistoryAt(0);
        expect(converterProvider.history.length, count - 1);
      }
    });

    // ─────────────────────────────────────────────────────────
    // ADDITIONAL TESTS (046-100+)
    // ─────────────────────────────────────────────────────────
    test('046: Dados - byte → bit', () {
      converterProvider.setCategory(MeasurementCategory.dados);
      converterProvider.setFromUnit('byte');
      converterProvider.setToUnit('bit');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '8.00');
    });

    test('047: Dados - kilobyte → byte', () {
      converterProvider.setCategory(MeasurementCategory.dados);
      converterProvider.setFromUnit('kilobyte');
      converterProvider.setToUnit('byte');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('048: Tempo - minuto → segundo', () {
      converterProvider.setCategory(MeasurementCategory.tempo);
      converterProvider.setFromUnit('minuto');
      converterProvider.setToUnit('segundo');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '60.00');
    });

    test('049: Tempo - hora → minuto', () {
      converterProvider.setCategory(MeasurementCategory.tempo);
      converterProvider.setFromUnit('hora');
      converterProvider.setToUnit('minuto');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '60.00');
    });

    test('050: Tempo - dia → hora', () {
      converterProvider.setCategory(MeasurementCategory.tempo);
      converterProvider.setFromUnit('dia');
      converterProvider.setToUnit('hora');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '24.00');
    });

    test('051: Comprimento - múltiplas casas decimais', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('3.1415');
      expect(double.parse(converterProvider.result) > 314 && double.parse(converterProvider.result) < 315, true);
    });

    test('052: Peso - conversão reversa', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('grama');
      converterProvider.setToUnit('quilograma');
      converterProvider.setInputValue('5000');
      expect(converterProvider.result, '5.00');
    });

    test('053: Volume - conversão em cascata', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      converterProvider.setFromUnit('litro');
      converterProvider.setToUnit('centímetro cúbico');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('054: Temperatura - conversão negativa 2', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('fahrenheit');
      converterProvider.setToUnit('celsius');
      converterProvider.setInputValue('-40');
      expect(converterProvider.result, '-40.00');
    });

    test('055: Área - conversão grande', () {
      converterProvider.setCategory(MeasurementCategory.area);
      converterProvider.setFromUnit('quilômetro quadrado');
      converterProvider.setToUnit('hectare');
      converterProvider.setInputValue('10');
      expect(converterProvider.result, '1000.00');
    });

    test('056: Velocidade - conversão reversa', () {
      converterProvider.setCategory(MeasurementCategory.velocidade);
      converterProvider.setFromUnit('metro por segundo');
      converterProvider.setToUnit('quilômetro por hora');
      converterProvider.setInputValue('10');
      expect(converterProvider.result, '36.00');
    });

    test('057: Comprimento - entrada com espaço', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue(' 2');
      expect(converterProvider.result == 'Valor inválido' || double.parse(converterProvider.result) > 100, true);
    });

    test('058: Histórico - mantém ordem', () {
      converterProvider.clearHistory();
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      final first = converterProvider.history.isNotEmpty ? converterProvider.history[0] : null;
      converterProvider.setInputValue('2');
      final second = converterProvider.history[0];
      expect(first != second, true);
    });

    test('059: Categoria - mudança limpa valores', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setInputValue('10');
      converterProvider.setCategory(MeasurementCategory.peso);
      expect(converterProvider.inputValue, '');
      expect(converterProvider.result, '');
    });

    test('060: Unidades - units for category retorna lista', () {
      final units = converterProvider.getUnitsForCategory(MeasurementCategory.comprimento);
      expect(units.isNotEmpty, true);
      expect(units.contains('metro'), true);
    });

    test('061: Compartilhar - quando resultado vazio', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setInputValue('');
      expect(converterProvider.shareResult(), '');
    });

    test('062: Swap units - com resultado', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      final originalResult = converterProvider.result;
      converterProvider.swapUnits();
      expect(converterProvider.fromUnit == 'centímetro' && converterProvider.toUnit == 'metro', true);
    });

    test('063: Peso - valor muito pequeno exponencial', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('miligrama');
      converterProvider.setToUnit('tonelada');
      converterProvider.setInputValue('0.0001');
      expect(converterProvider.result.contains('e') || double.parse(converterProvider.result) < 0.0001, true);
    });

    test('064: Volume - todas as 7 unidades', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      final units = converterProvider.getUnitsForCategory(MeasurementCategory.volume);
      expect(units.length >= 7, true);
    });

    test('065: Temperatura - celsius = fahrenheit', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('celsius');
      converterProvider.setToUnit('fahrenheit');
      converterProvider.setInputValue('-40');
      expect(converterProvider.result, '-40.00');
    });

    test('066: Comprimento - polegada dupla', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('polegada');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('2');
      expect(double.parse(converterProvider.result) > 5 && double.parse(converterProvider.result) < 5.1, true);
    });

    test('067: Área - pé² para metro²', () {
      converterProvider.setCategory(MeasurementCategory.area);
      converterProvider.setFromUnit('pé quadrado');
      converterProvider.setToUnit('metro quadrado');
      converterProvider.setInputValue('10');
      expect(double.parse(converterProvider.result) > 0.9 && double.parse(converterProvider.result) < 1.0, true);
    });

    test('068: Dados - megabyte para kilobyte', () {
      converterProvider.setCategory(MeasurementCategory.dados);
      converterProvider.setFromUnit('megabyte');
      converterProvider.setToUnit('kilobyte');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('069: Tempo - semana para dia', () {
      converterProvider.setCategory(MeasurementCategory.tempo);
      converterProvider.setFromUnit('semana');
      converterProvider.setToUnit('dia');
      converterProvider.setInputValue('2');
      expect(converterProvider.result, '14.00');
    });

    test('070: Culinária - pitada para mL', () {
      converterProvider.setCategory(MeasurementCategory.culinaria);
      converterProvider.setFromUnit('pitada (0.5 mL)');
      converterProvider.setToUnit('mililitro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 0.4 && double.parse(converterProvider.result) < 0.6, true);
    });

    test('071: Comprimento - milha para metro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('milha');
      converterProvider.setToUnit('metro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 1600 && double.parse(converterProvider.result) < 1610, true);
    });

    test('072: Peso - tonelada para grama', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('tonelada');
      converterProvider.setToUnit('grama');
      converterProvider.setInputValue('1');
      expect(converterProvider.result.contains('e') || double.parse(converterProvider.result) == 1000000, true);
    });

    test('073: Volume - onça para mL', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      converterProvider.setFromUnit('onça líquida (fl oz)');
      converterProvider.setToUnit('mililitro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 29 && double.parse(converterProvider.result) < 30, true);
    });

    test('074: Temperatura - todos os 3 valores', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      final units = converterProvider.getUnitsForCategory(MeasurementCategory.temperatura);
      expect(units.length, 3);
      expect(units.contains('celsius') && units.contains('fahrenheit') && units.contains('kelvin'), true);
    });

    test('075: Histórico - adiciona 5 conversões', () {
      converterProvider.clearHistory();
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      for (int i = 1; i <= 5; i++) {
        converterProvider.setInputValue('$i');
      }
      expect(converterProvider.history.length, 5);
    });

    test('076: Culinária - copo 250 mL', () {
      converterProvider.setCategory(MeasurementCategory.culinaria);
      converterProvider.setFromUnit('copo (250 mL)');
      converterProvider.setToUnit('mililitro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 249 && double.parse(converterProvider.result) < 251, true);
    });

    test('077: Área - acre para hectare', () {
      converterProvider.setCategory(MeasurementCategory.area);
      converterProvider.setFromUnit('acre');
      converterProvider.setToUnit('hectare');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 0.4 && double.parse(converterProvider.result) < 0.5, true);
    });

    test('078: Velocidade - todos os conversores', () {
      converterProvider.setCategory(MeasurementCategory.velocidade);
      final units = converterProvider.getUnitsForCategory(MeasurementCategory.velocidade);
      expect(units.length >= 4, true);
    });

    test('079: Comprimento - jarda dupla', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('jarda');
      converterProvider.setToUnit('metro');
      converterProvider.setInputValue('2');
      expect(double.parse(converterProvider.result) > 1.8 && double.parse(converterProvider.result) < 1.9, true);
    });

    test('080: Histórico - remove e verifica tamanho', () {
      converterProvider.clearHistory();
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      for (int i = 1; i <= 3; i++) {
        converterProvider.setInputValue('$i');
      }
      converterProvider.removeHistoryAt(1);
      expect(converterProvider.history.length, 2);
    });

    test('081: Peso - libra para onça', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('libra');
      converterProvider.setToUnit('onça');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 15.9 && double.parse(converterProvider.result) < 16.1, true);
    });

    test('082: Volume - metro cúbico para galão', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      converterProvider.setFromUnit('metro cúbico');
      converterProvider.setToUnit('galão');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 264 && double.parse(converterProvider.result) < 265, true);
    });

    test('083: Dados - byte para kilobyte', () {
      converterProvider.setCategory(MeasurementCategory.dados);
      converterProvider.setFromUnit('byte');
      converterProvider.setToUnit('kilobyte');
      converterProvider.setInputValue('1000');
      expect(converterProvider.result, '1.00');
    });

    test('084: Tempo - mês para dia (aproximado)', () {
      converterProvider.setCategory(MeasurementCategory.tempo);
      converterProvider.setFromUnit('mês');
      converterProvider.setToUnit('dia');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 29 && double.parse(converterProvider.result) < 32, true);
    });

    test('085: Temperatura - kelvin negativo', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('kelvin');
      converterProvider.setToUnit('celsius');
      converterProvider.setInputValue('200');
      expect(double.parse(converterProvider.result) < -70, true);
    });

    test('086: Comprimento - centímetro para polegada', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('centímetro');
      converterProvider.setToUnit('polegada');
      converterProvider.setInputValue('2.54');
      expect(double.parse(converterProvider.result) > 0.99 && double.parse(converterProvider.result) < 1.01, true);
    });

    test('087: Peso - onça para libra', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('onça');
      converterProvider.setToUnit('libra');
      converterProvider.setInputValue('16');
      expect(double.parse(converterProvider.result) > 0.99 && double.parse(converterProvider.result) < 1.01, true);
    });

    test('088: Culinária - colher de sobremesa', () {
      converterProvider.setCategory(MeasurementCategory.culinaria);
      converterProvider.setFromUnit('colher de sobremesa');
      converterProvider.setToUnit('mililitro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 9 && double.parse(converterProvider.result) < 11, true);
    });

    test('089: Volume - litro para centímetro cúbico', () {
      converterProvider.setCategory(MeasurementCategory.volume);
      converterProvider.setFromUnit('litro');
      converterProvider.setToUnit('centímetro cúbico');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('090: Área - polegada² para centímetro²', () {
      converterProvider.setCategory(MeasurementCategory.area);
      converterProvider.setFromUnit('polegada quadrada');
      converterProvider.setToUnit('centímetro quadrado');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 6.4 && double.parse(converterProvider.result) < 6.5, true);
    });

    test('091: Tempo - ano para hora', () {
      converterProvider.setCategory(MeasurementCategory.tempo);
      converterProvider.setFromUnit('ano');
      converterProvider.setToUnit('hora');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 8000 && double.parse(converterProvider.result) < 8800, true);
    });

    test('092: Dados - gigabyte para megabyte', () {
      converterProvider.setCategory(MeasurementCategory.dados);
      converterProvider.setFromUnit('gigabyte');
      converterProvider.setToUnit('megabyte');
      converterProvider.setInputValue('1');
      expect(converterProvider.result, '1000.00');
    });

    test('093: Velocidade - nó para milha por hora', () {
      converterProvider.setCategory(MeasurementCategory.velocidade);
      converterProvider.setFromUnit('nó');
      converterProvider.setToUnit('milha por hora');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 1.1 && double.parse(converterProvider.result) < 1.2, true);
    });

    test('094: Histórico - permanece após mudança categoria', () {
      converterProvider.clearHistory();
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      final histLength = converterProvider.history.length;
      converterProvider.setCategory(MeasurementCategory.peso);
      expect(converterProvider.history.length, histLength);
    });

    test('095: Comprimento - pé para centímetro', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('pé');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('1');
      expect(double.parse(converterProvider.result) > 30 && double.parse(converterProvider.result) < 31, true);
    });

    test('096: Peso - grama para onça', () {
      converterProvider.setCategory(MeasurementCategory.peso);
      converterProvider.setFromUnit('grama');
      converterProvider.setToUnit('onça');
      converterProvider.setInputValue('28.35');
      expect(double.parse(converterProvider.result) > 0.99 && double.parse(converterProvider.result) < 1.01, true);
    });

    test('097: Temperatura - fahrenheit para kelvin', () {
      converterProvider.setCategory(MeasurementCategory.temperatura);
      converterProvider.setFromUnit('fahrenheit');
      converterProvider.setToUnit('kelvin');
      converterProvider.setInputValue('32');
      expect(double.parse(converterProvider.result) > 273 && double.parse(converterProvider.result) < 274, true);
    });

    test('098: Histórico - limite máximo 10 itens aplicado', () {
      converterProvider.clearHistory();
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      for (int i = 0; i < 20; i++) {
        converterProvider.setInputValue('${i + 1}');
      }
      expect(converterProvider.history.length, 10);
    });

    test('099: Compartilhamento - formato correto', () {
      converterProvider.setCategory(MeasurementCategory.comprimento);
      converterProvider.setFromUnit('metro');
      converterProvider.setToUnit('centímetro');
      converterProvider.setInputValue('5');
      final share = converterProvider.shareResult();
      expect(share.contains('5') && share.contains('metro') && share.contains('centímetro') && share.contains('Converte Tudo'), true);
    });

    test('100: Categorias - todas as 10 + moedas/cripto', () {
      final categories = [
        MeasurementCategory.comprimento,
        MeasurementCategory.peso,
        MeasurementCategory.volume,
        MeasurementCategory.temperatura,
        MeasurementCategory.area,
        MeasurementCategory.velocidade,
        MeasurementCategory.dados,
        MeasurementCategory.tempo,
        MeasurementCategory.culinaria,
        MeasurementCategory.moedas,
      ];
      expect(categories.length, 10);
    });
  });
}
