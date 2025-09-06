// currency_rate.dart
import 'package:equatable/equatable.dart';

class CurrencyRate extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime lastUpdated;

  const CurrencyRate({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      baseCurrency: json['base_code'] ?? 'USD',
      rates: Map<String, double>.from(
        json['conversion_rates']?.map(
              (key, value) => MapEntry(key, value.toDouble()),
            ) ??
            {},
      ),
      lastUpdated: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [baseCurrency, rates, lastUpdated];
}
