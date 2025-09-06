import 'package:coinbox_test/core/errors/exceptions.dart';
import 'package:coinbox_test/data/datasources/currency_remote_data_source.dart';
import 'package:coinbox_test/data/repositories/currency_repository.dart';
import 'package:coinbox_test/domain/entities/currency_rate.dart';
import 'package:dartz/dartz.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CurrencyRate>> getExchangeRates(
    String baseCurrency,
  ) async {
    try {
      final response = await remoteDataSource.getExchangeRates(baseCurrency);
      return Right(CurrencyRate.fromJson(response));
    } on ServerException {
      return Left(ServerFailure('Failed to fetch exchange rates'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
