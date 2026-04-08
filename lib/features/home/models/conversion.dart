import 'package:flutter/material.dart';

enum MeasurementCategory {
  // Medidas
  comprimento, peso, volume, temperatura,
  area, velocidade, dados, tempo,
  // Financeiro
  moedas, cripto,
}

extension MeasurementCategoryExtension on MeasurementCategory {
  String get label {
    switch (this) {
      case MeasurementCategory.comprimento: return 'Comprimento';
      case MeasurementCategory.peso:        return 'Peso';
      case MeasurementCategory.volume:      return 'Volume';
      case MeasurementCategory.temperatura: return 'Temperatura';
      case MeasurementCategory.area:        return 'Área';
      case MeasurementCategory.velocidade:  return 'Velocidade';
      case MeasurementCategory.dados:       return 'Dados Digitais';
      case MeasurementCategory.tempo:       return 'Tempo';
      case MeasurementCategory.moedas:      return 'Moedas';
      case MeasurementCategory.cripto:      return 'Criptomoedas';
    }
  }

  String get emoji {
    switch (this) {
      case MeasurementCategory.comprimento: return '📏';
      case MeasurementCategory.peso:        return '⚖️';
      case MeasurementCategory.volume:      return '🫙';
      case MeasurementCategory.temperatura: return '🌡️';
      case MeasurementCategory.area:        return '📐';
      case MeasurementCategory.velocidade:  return '💨';
      case MeasurementCategory.dados:       return '💾';
      case MeasurementCategory.tempo:       return '⏱️';
      case MeasurementCategory.moedas:      return '💵';
      case MeasurementCategory.cripto:      return '₿';
    }
  }

  String get unitSamples {
    switch (this) {
      case MeasurementCategory.comprimento: return 'm · cm · pé · pol · milha';
      case MeasurementCategory.peso:        return 'kg · g · lb · oz · arroba';
      case MeasurementCategory.volume:      return 'L · mL · gal · fl oz · xícara';
      case MeasurementCategory.temperatura: return '°C · °F · K';
      case MeasurementCategory.area:        return 'm² · ft² · hectare · acre';
      case MeasurementCategory.velocidade:  return 'km/h · mph · m/s · nós';
      case MeasurementCategory.dados:       return 'KB · MB · GB · TB';
      case MeasurementCategory.tempo:       return 'seg · min · h · dias';
      case MeasurementCategory.moedas:      return 'BRL · USD · EUR · GBP';
      case MeasurementCategory.cripto:      return 'BTC · ETH · BNB · SOL';
    }
  }

  IconData get icon {
    switch (this) {
      case MeasurementCategory.comprimento: return Icons.straighten_rounded;
      case MeasurementCategory.peso:        return Icons.monitor_weight_rounded;
      case MeasurementCategory.volume:      return Icons.water_drop_rounded;
      case MeasurementCategory.temperatura: return Icons.thermostat_rounded;
      case MeasurementCategory.area:        return Icons.crop_square_rounded;
      case MeasurementCategory.velocidade:  return Icons.speed_rounded;
      case MeasurementCategory.dados:       return Icons.storage_rounded;
      case MeasurementCategory.tempo:       return Icons.schedule_rounded;
      case MeasurementCategory.moedas:      return Icons.currency_exchange_rounded;
      case MeasurementCategory.cripto:      return Icons.currency_bitcoin_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MeasurementCategory.comprimento: return const Color(0xFF1565C0);
      case MeasurementCategory.peso:        return const Color(0xFF2E7D32);
      case MeasurementCategory.volume:      return const Color(0xFF0277BD);
      case MeasurementCategory.temperatura: return const Color(0xFFBF360C);
      case MeasurementCategory.area:        return const Color(0xFF6A1B9A);
      case MeasurementCategory.velocidade:  return const Color(0xFF00695C);
      case MeasurementCategory.dados:       return const Color(0xFF283593);
      case MeasurementCategory.tempo:       return const Color(0xFF37474F);
      case MeasurementCategory.moedas:      return const Color(0xFF1B5E20);
      case MeasurementCategory.cripto:      return const Color(0xFFE65100);
    }
  }

  Color get lightBackground {
    switch (this) {
      case MeasurementCategory.comprimento: return const Color(0xFFE8F0FE);
      case MeasurementCategory.peso:        return const Color(0xFFE8F5E9);
      case MeasurementCategory.volume:      return const Color(0xFFE1F5FE);
      case MeasurementCategory.temperatura: return const Color(0xFFFBE9E7);
      case MeasurementCategory.area:        return const Color(0xFFF3E5F5);
      case MeasurementCategory.velocidade:  return const Color(0xFFE0F2F1);
      case MeasurementCategory.dados:       return const Color(0xFFE8EAF6);
      case MeasurementCategory.tempo:       return const Color(0xFFECEFF1);
      case MeasurementCategory.moedas:      return const Color(0xFFE8F5E9);
      case MeasurementCategory.cripto:      return const Color(0xFFFBE9E7);
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case MeasurementCategory.comprimento: return [const Color(0xFF1565C0), const Color(0xFF42A5F5)];
      case MeasurementCategory.peso:        return [const Color(0xFF2E7D32), const Color(0xFF66BB6A)];
      case MeasurementCategory.volume:      return [const Color(0xFF0277BD), const Color(0xFF26C6DA)];
      case MeasurementCategory.temperatura: return [const Color(0xFFBF360C), const Color(0xFFFF7043)];
      case MeasurementCategory.area:        return [const Color(0xFF6A1B9A), const Color(0xFFBA68C8)];
      case MeasurementCategory.velocidade:  return [const Color(0xFF00695C), const Color(0xFF4DB6AC)];
      case MeasurementCategory.dados:       return [const Color(0xFF283593), const Color(0xFF5C6BC0)];
      case MeasurementCategory.tempo:       return [const Color(0xFF37474F), const Color(0xFF78909C)];
      case MeasurementCategory.moedas:      return [const Color(0xFF1B5E20), const Color(0xFF4CAF50)];
      case MeasurementCategory.cripto:      return [const Color(0xFFE65100), const Color(0xFFFF9800)];
    }
  }
}

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
