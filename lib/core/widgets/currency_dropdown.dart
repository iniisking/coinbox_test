import 'package:coinbox_test/core/constants/currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coinbox_test/core/constants/colors.dart';
import 'package:coinbox_test/core/widgets/text.dart';

class CurrencyDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final bool isEnabled;

  const CurrencyDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: Icon(
        Icons.keyboard_arrow_down,
        size: 24.spMin,
        color: AppColor.iconColor,
      ),
      elevation: 16,
      style: TextStyle(
        fontSize: 20.spMin,
        fontWeight: FontWeight.w500,
        color: AppColor.headerTextColor2,
      ),
      underline: Container(),
      onChanged: isEnabled ? onChanged : null,
      items: currencies.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: CustomTextWidget(
            text: value,
            fontSize: 20.spMin,
            color: AppColor.headerTextColor2,
            fontWeight: FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }
}
