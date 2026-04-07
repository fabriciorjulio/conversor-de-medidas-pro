import '../../features/home/models/conversion.dart';

const Map<MeasurementCategory, Map<String, double>> kConversionFactors = {
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
    'miligrama': 1000000.0,
    'tonelada': 0.001,
    'libra': 2.20462,
  },
  MeasurementCategory.volume: {
    'litro': 1.0,
    'mililitro': 1000.0,
    'metro cúbico': 0.001,
    'centímetro cúbico': 1000.0,
    'galão (US)': 0.264172,
  },
  MeasurementCategory.temperatura: {
    'celsius': 1.0,
    'fahrenheit': 1.0,
    'kelvin': 1.0,
  },
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
  MeasurementCategory.comprimento: ['metro', 'centímetro'],
  MeasurementCategory.peso: ['quilograma', 'grama'],
  MeasurementCategory.volume: ['litro', 'mililitro'],
  MeasurementCategory.temperatura: ['celsius', 'fahrenheit'],
  MeasurementCategory.area: ['metro quadrado', 'centímetro quadrado'],
  MeasurementCategory.velocidade: ['quilômetro por hora', 'metro por segundo'],
  MeasurementCategory.dados: ['gigabyte', 'megabyte'],
  MeasurementCategory.tempo: ['hora', 'minuto'],
  MeasurementCategory.moedas: ['Real (BRL)', 'Dólar (USD)'],
  MeasurementCategory.cripto: ['Real (BRL)', 'Bitcoin (BTC)'],
};
