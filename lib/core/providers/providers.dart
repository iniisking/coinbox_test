import 'package:coinbox_test/data/repositories/currency_repository.dart';
import 'package:coinbox_test/domain/usecases/%20get_exchange_rates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:coinbox_test/data/datasources/currency_remote_data_source.dart';
import 'package:coinbox_test/data/repositories/currency_repository_impl.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final currencyRemoteDataSourceProvider = Provider<CurrencyRemoteDataSource>((
  ref,
) {
  final client = ref.watch(httpClientProvider);
  return CurrencyRemoteDataSourceImpl(client: client);
});

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  final remoteDataSource = ref.watch(currencyRemoteDataSourceProvider);
  return CurrencyRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getExchangeRatesProvider = Provider<GetExchangeRates>((ref) {
  final repository = ref.watch(currencyRepositoryProvider);
  return GetExchangeRates(repository);
});
