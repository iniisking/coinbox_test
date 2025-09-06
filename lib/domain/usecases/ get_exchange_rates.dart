// ignore_for_file: file_names

import 'package:coinbox_test/core/errors/exceptions.dart';
import 'package:coinbox_test/data/repositories/currency_repository.dart';
import 'package:coinbox_test/domain/entities/currency_rate.dart';
import 'package:dartz/dartz.dart';

class GetExchangeRates {
  final CurrencyRepository repository;

  GetExchangeRates(this.repository);

  Future<Either<Failure, CurrencyRate>> call(String baseCurrency) async {
    return await repository.getExchangeRates(baseCurrency);
  }
}
