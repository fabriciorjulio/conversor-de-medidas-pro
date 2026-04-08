import '../../features/home/models/conversion.dart';

const Map<MeasurementCategory, Map<String, double>> kConversionFactors = {
  // base: metro
  MeasurementCategory.comprimento: {
    'metro': 1.0,
    'centímetro': 100.0,
    'milímetro': 1000.0,
    'quilômetro': 0.001,
    'polegada': 39.3701,
    'pé': 3.28084,
    'jarda': 1.09361,
    'milha': 0.000621371,
  },
  // base: quilograma
  MeasurementCategory.peso: {
    'quilograma': 1.0,
    'grama': 1000.0,
    'miligrama': 1000000.0,
    'tonelada': 0.001,
    'libra': 2.20462,
    'onça': 35.274,
    'arroba': 0.0666667,
  },
  // base: litro
  MeasurementCategory.volume: {
    'litro': 1.0,
    'mililitro': 1000.0,
    'metro cúbico': 0.001,
    'centímetro cúbico': 1000.0,
    'galão (US)': 0.264172,
    'onça líquida (fl oz)': 33.814,
    'xícara': 4.16667,
  },
  MeasurementCategory.temperatura: {
    'celsius': 1.0,
    'fahrenheit': 1.0,
    'kelvin': 1.0,
  },
  // base: metro quadrado
  MeasurementCategory.area: {
    'metro quadrado': 1.0,
    'centímetro quadrado': 10000.0,
    'quilômetro quadrado': 1e-6,
    'milímetro quadrado': 1000000.0,
    'pé quadrado': 10.7639,
    'polegada quadrada': 1550.0031,
    'hectare': 0.0001,
    'acre': 0.000247105,
  },
  // base: km/h
  MeasurementCategory.velocidade: {
    'quilômetro por hora': 1.0,
    'metro por segundo': 0.277778,
    'milha por hora': 0.621371,
    'nó': 0.539957,
  },
  // base: byte (SI — 1 KB = 1000 B)
  MeasurementCategory.dados: {
    'byte': 1.0,
    'bit': 8.0,
    'kilobyte': 0.001,
    'megabyte': 1e-6,
    'gigabyte': 1e-9,
    'terabyte': 1e-12,
    'petabyte': 1e-15,
  },
  // base: segundo
  MeasurementCategory.tempo: {
    'segundo': 1.0,
    'minuto': 0.016667,
    'hora': 0.000277778,
    'dia': 0.0000115741,
    'semana': 0.00000165344,
    'mês': 3.858e-7,
    'ano': 3.171e-8,
  },
  // base: mililitro
  MeasurementCategory.culinaria: {
    'mililitro': 1.0,
    'colher de chá': 0.2,
    'colher de sopa': 0.0666667,
    'colher de sobremesa': 0.1,
    'xícara': 0.00416667,
    'copo americano': 0.005,
    'copo (250 mL)': 0.004,
    'litro': 0.001,
    'pitada (0.5 mL)': 2.0,
  },
  // base: BRL — rates updated at runtime by CurrencyService
  MeasurementCategory.moedas: {
    'Real (BRL)': 1.0,
    'Dólar (USD)': 0.1961,
    'Euro (EUR)': 0.1786,
    'Libra (GBP)': 0.1538,
    'Iene (JPY)': 28.5714,
    'Franco Suíço (CHF)': 0.1786,
    'Dólar Canadense (CAD)': 0.2703,
    'Dólar Australiano (AUD)': 0.3125,
  },
  // base: BRL — rates updated at runtime by CurrencyService
  MeasurementCategory.cripto: {
    'Real (BRL)': 1.0,
    'USDT': 0.1961,
    'Bitcoin (BTC)': 1.9e-6,
    'Ethereum (ETH)': 3.33e-5,
    'BNB': 7.14e-4,
    'Solana (SOL)': 4.17e-3,
    'XRP': 0.4878,
  },
};

const Map<MeasurementCategory, List<String>> kCategoryDefaults = {
  MeasurementCategory.comprimento: ['metro', 'pé'],
  MeasurementCategory.peso: ['quilograma', 'libra'],
  MeasurementCategory.volume: ['litro', 'galão (US)'],
  MeasurementCategory.temperatura: ['celsius', 'fahrenheit'],
  MeasurementCategory.area: ['metro quadrado', 'pé quadrado'],
  MeasurementCategory.velocidade: ['quilômetro por hora', 'milha por hora'],
  MeasurementCategory.dados: ['gigabyte', 'megabyte'],
  MeasurementCategory.tempo: ['hora', 'minuto'],
  MeasurementCategory.culinaria: ['xícara', 'colher de sopa'],
  MeasurementCategory.moedas: ['Real (BRL)', 'Dólar (USD)'],
  MeasurementCategory.cripto: ['Real (BRL)', 'Bitcoin (BTC)'],
};
