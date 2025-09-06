// currency_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coinbox_test/core/errors/exceptions.dart';

abstract class CurrencyRemoteDataSource {
  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency);
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String apiKey = '54ca4274b22a9d03e0995a72';

  CurrencyRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$apiKey/latest/$baseCurrency'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException('Failed to load exchange rates');
    }
  }
}
