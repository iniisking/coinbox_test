// currency_repository.dart
import 'package:coinbox_test/core/errors/exceptions.dart';
import 'package:coinbox_test/domain/entities/currency_rate.dart';
import 'package:dartz/dartz.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, CurrencyRate>> getExchangeRates(String baseCurrency);
}
