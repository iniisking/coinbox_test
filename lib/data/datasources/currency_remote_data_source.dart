// lib/data/datasources/currency_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import
import 'package:coinbox_test/core/constants/env_constants.dart'; // Add this import
import 'package:coinbox_test/core/errors/exceptions.dart';

abstract class CurrencyRemoteDataSource {
  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency);
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';
  late final String apiKey; // Change to late final

  CurrencyRemoteDataSourceImpl({required this.client}) {
    // Initialize API key from environment variables
    apiKey = dotenv.env[EnvConstants.exchangeRateApiKey] ?? '';

    if (apiKey.isEmpty) {
      throw Exception('API key not found in environment variables');
    }
  }

  @override
  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$apiKey/latest/$baseCurrency'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException(
        'Failed to load exchange rates. Status code: ${response.statusCode}',
      );
    }
  }
}
