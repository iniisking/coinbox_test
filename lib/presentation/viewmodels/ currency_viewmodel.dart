// presentation/viewmodels/currency_viewmodel.dart
import 'package:coinbox_test/core/providers/providers.dart';
import 'package:coinbox_test/domain/usecases/%20get_exchange_rates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coinbox_test/domain/entities/currency_rate.dart';

final currencyViewModelProvider =
    StateNotifierProvider<CurrencyViewModel, CurrencyState>((ref) {
      final getExchangeRates = ref.watch(getExchangeRatesProvider);
      return CurrencyViewModel(getExchangeRates);
    });

class CurrencyViewModel extends StateNotifier<CurrencyState> {
  final GetExchangeRates getExchangeRates;

  CurrencyViewModel(this.getExchangeRates) : super(CurrencyState.initial());

  Future<void> fetchExchangeRates(String baseCurrency) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getExchangeRates(baseCurrency);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (rates) {
        state = state.copyWith(
          isLoading: false,
          currencyRate: rates,
          error: null,
        );
      },
    );
  }

  double convertCurrency(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) {
    if (state.currencyRate == null) return 0.0;

    final rates = state.currencyRate!.rates;
    if (!rates.containsKey(fromCurrency) || !rates.containsKey(toCurrency)) {
      return 0.0;
    }

    // Convert to base currency first, then to target currency
    final fromRate = rates[fromCurrency]!;
    final toRate = rates[toCurrency]!;

    return amount * (toRate / fromRate);
  }

  void setFromCurrency(String currency) {
    state = state.copyWith(fromCurrency: currency);
    if (state.amountFrom.isNotEmpty) {
      final amount = double.tryParse(state.amountFrom) ?? 0;
      final converted = convertCurrency(amount, currency, state.toCurrency);
      state = state.copyWith(amountTo: converted.toStringAsFixed(2));
    }
    fetchExchangeRates(currency);
  }

  void setToCurrency(String currency) {
    state = state.copyWith(toCurrency: currency);
    if (state.amountFrom.isNotEmpty) {
      final amount = double.tryParse(state.amountFrom) ?? 0;
      final converted = convertCurrency(amount, state.fromCurrency, currency);
      state = state.copyWith(amountTo: converted.toStringAsFixed(2));
    }
  }

  void setAmountFrom(String amount) {
    state = state.copyWith(amountFrom: amount);
    if (amount.isNotEmpty) {
      final amountValue = double.tryParse(amount) ?? 0;
      final converted = convertCurrency(
        amountValue,
        state.fromCurrency,
        state.toCurrency,
      );
      state = state.copyWith(amountTo: converted.toStringAsFixed(2));
    } else {
      state = state.copyWith(amountTo: '');
    }
  }

  void setAmountTo(String amount) {
    state = state.copyWith(amountTo: amount);
    if (amount.isNotEmpty) {
      final amountValue = double.tryParse(amount) ?? 0;
      final converted = convertCurrency(
        amountValue,
        state.toCurrency,
        state.fromCurrency,
      );
      state = state.copyWith(amountFrom: converted.toStringAsFixed(2));
    } else {
      state = state.copyWith(amountFrom: '');
    }
  }

  void swapCurrencies() {
    final from = state.fromCurrency;
    final to = state.toCurrency;
    final tempAmount = state.amountFrom;

    state = state.copyWith(
      fromCurrency: to,
      toCurrency: from,
      amountFrom: state.amountTo,
      amountTo: tempAmount,
    );

    fetchExchangeRates(to);
  }
}

class CurrencyState {
  final bool isLoading;
  final String? error;
  final CurrencyRate? currencyRate;
  final String fromCurrency;
  final String toCurrency;
  final String amountFrom;
  final String amountTo;

  CurrencyState({
    required this.isLoading,
    required this.error,
    required this.currencyRate,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amountFrom,
    required this.amountTo,
  });

  factory CurrencyState.initial() {
    return CurrencyState(
      isLoading: false,
      error: null,
      currencyRate: null,
      fromCurrency: 'SGD',
      toCurrency: 'USD',
      amountFrom: '',
      amountTo: '',
    );
  }

  CurrencyState copyWith({
    bool? isLoading,
    String? error,
    CurrencyRate? currencyRate,
    String? fromCurrency,
    String? toCurrency,
    String? amountFrom,
    String? amountTo,
  }) {
    return CurrencyState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currencyRate: currencyRate ?? this.currencyRate,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amountFrom: amountFrom ?? this.amountFrom,
      amountTo: amountTo ?? this.amountTo,
    );
  }
}
