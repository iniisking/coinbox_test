// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:coinbox_test/core/constants/colors.dart';
import 'package:coinbox_test/core/widgets/text.dart';
import 'package:coinbox_test/core/widgets/textfield.dart';
import 'package:coinbox_test/core/widgets/currency_dropdown.dart';
import 'package:coinbox_test/gen/assets.gen.dart';

import '../viewmodels/ currency_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController fromAmountController = TextEditingController();
  final TextEditingController toAmountController = TextEditingController();
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Give Riverpod a moment to initialize
      await Future.delayed(const Duration(milliseconds: 100));

      final viewModel = ref.read(currencyViewModelProvider.notifier);
      await viewModel.fetchExchangeRates('SGD');

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _errorMessage = null;
        });
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize app: $e';
        });
      }

      // Retry after a delay if there's an error
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _initializeApp();
      }
    }
  }

  @override
  void dispose() {
    fromAmountController.dispose();
    toAmountController.dispose();
    super.dispose();
  }

  String getFlagAsset(String currencyCode) {
    switch (currencyCode) {
      case 'SGD':
        return 'sgd';
      case 'USD':
        return 'usd';
      case 'EUR':
        return 'eur';
      case 'GBP':
        return 'gbp';
      case 'JPY':
        return 'jpy';
      case 'AUD':
        return 'aud';
      case 'CAD':
        return 'cad';
      default:
        return 'usd';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error screen if initialization failed
    if (_errorMessage != null) {
      return _buildErrorScreen(_errorMessage!);
    }

    // Show loading screen if not initialized
    if (!_isInitialized) {
      return _buildLoadingScreen();
    }

    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(currencyViewModelProvider);
        final viewModel = ref.read(currencyViewModelProvider.notifier);

        // Sync controllers with state
        if (fromAmountController.text != state.amountFrom) {
          fromAmountController.text = state.amountFrom;
        }
        if (toAmountController.text != state.amountTo) {
          toAmountController.text = state.amountTo;
        }

        return _buildMainScreen(state, viewModel);
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [AppColor.backgroundColor1, AppColor.backgroundColor2],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 20.spMin),
              Text(
                'Loading currency data...',
                style: TextStyle(color: Colors.white, fontSize: 16.spMin),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [AppColor.backgroundColor1, AppColor.backgroundColor2],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.spMin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50.spMin, color: Colors.white),
                SizedBox(height: 20.spMin),
                Text(
                  'Initialization Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.spMin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.spMin),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white, fontSize: 14.spMin),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.spMin),
                ElevatedButton(onPressed: _initializeApp, child: Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainScreen(CurrencyState state, CurrencyViewModel viewModel) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient that fills the entire screen
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [AppColor.backgroundColor1, AppColor.backgroundColor2],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.spMin),
                child: Column(
                  children: [
                    //Header text
                    CustomTextWidget(
                      text: 'Currency Converter',
                      fontSize: 25.spMin,
                      color: AppColor.headerTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 10.spMin),

                    //Description
                    CustomTextWidget(
                      text:
                          'Check live rates, set rate alerts, receive\nnotifications and more.',
                      fontSize: 16.spMin,
                      color: AppColor.regularTextColor,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 41.spMin),
                    Container(
                      padding: EdgeInsets.all(20.spMin),
                      height: 273.spMin,
                      width: 380.spMin,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(20.spMin),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                text: 'Amount',
                                fontSize: 15.spMin,
                                color: AppColor.regularTextColor2,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          SizedBox(height: 14.spMin),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildCurrencyImage(state.fromCurrency),
                                  SizedBox(width: 13.spMin),
                                  CurrencyDropdown(
                                    value: state.fromCurrency,
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        viewModel.setFromCurrency(newValue);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 160,
                                child: AuthTextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: fromAmountController,
                                  primaryBorderColor: Colors.transparent,
                                  errorBorderColor: Colors.red,
                                  onChanged: (value) {
                                    viewModel.setAmountFrom(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.spMin),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: AppColor.dividerColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  viewModel.swapCurrencies();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.27.spMin,
                                    vertical: 12.spMin,
                                  ),
                                  height: 44.spMin,
                                  width: 44.spMin,
                                  decoration: BoxDecoration(
                                    color: AppColor.buttonColor,
                                    borderRadius: BorderRadius.circular(
                                      22.spMin,
                                    ),
                                  ),
                                  child: Assets.svg.convert.svg(),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: AppColor.dividerColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                text: 'Converted Amount',
                                fontSize: 15.spMin,
                                color: AppColor.regularTextColor2,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          SizedBox(height: 14.spMin),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildCurrencyImage(state.toCurrency),
                                  SizedBox(width: 13.spMin),
                                  CurrencyDropdown(
                                    value: state.toCurrency,
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        viewModel.setToCurrency(newValue);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 160,
                                child: AuthTextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: toAmountController,
                                  primaryBorderColor: Colors.transparent,
                                  errorBorderColor: Colors.red,
                                  onChanged: (value) {
                                    viewModel.setAmountTo(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.spMin),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: 'Indicative Exchange Rate',
                          fontSize: 16.spMin,
                          color: AppColor.regularTextColor3,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 13.spMin),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (state.isLoading)
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.spMin),
                                color: Colors.white,
                              ),
                              width: 180.spMin,
                              height: 21.spMin,
                            ),
                          )
                        else if (state.currencyRate != null)
                          CustomTextWidget(
                            text:
                                '1 ${state.fromCurrency} = ${state.currencyRate!.rates[state.toCurrency]?.toStringAsFixed(4) ?? '0.0000'} ${state.toCurrency}',
                            fontSize: 18.spMin,
                            color: AppColor.regularTextColor4,
                            fontWeight: FontWeight.w500,
                          )
                        else
                          CustomTextWidget(
                            text:
                                '1 ${state.fromCurrency} = 0.0000 ${state.toCurrency}',
                            fontSize: 18.spMin,
                            color: AppColor.regularTextColor4,
                            fontWeight: FontWeight.w500,
                          ),
                      ],
                    ),
                    SizedBox(height: 30.spMin),
                    if (state.error != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.spMin),
                        child: Text(
                          state.error!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.spMin,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyImage(String currencyCode) {
    final assetName = getFlagAsset(currencyCode);
    return Image.asset(
      'assets/images/$assetName.png',
      height: 45.spMin,
      width: 45.spMin,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 45.spMin,
          width: 45.spMin,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(22.5.spMin),
          ),
          child: Icon(
            Icons.currency_exchange,
            size: 24.spMin,
            color: Colors.grey[600],
          ),
        );
      },
    );
  }
}
