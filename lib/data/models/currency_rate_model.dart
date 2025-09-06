// currency_rate_model.dart
import 'package:equatable/equatable.dart';

class CurrencyRateModel extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime lastUpdated;

  const CurrencyRateModel({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRateModel(
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
