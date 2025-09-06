import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextFormField extends StatefulWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? maxLines;
  final Color primaryBorderColor;
  final Color errorBorderColor;
  final ValueChanged<String>? onChanged;

  const AuthTextFormField({
    super.key,

    required this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    required this.primaryBorderColor,
    required this.errorBorderColor,
    this.onChanged,
  });

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      cursorColor: Color(0xFF3C3C3C),
      style: TextStyle(
        fontSize: 20.spMin,
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis,
        color: Color(0xFF3C3C3C),
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        focusedBorder: _buildBorder(widget.primaryBorderColor),
        focusedErrorBorder: _buildBorder(widget.errorBorderColor),
        enabledBorder: _buildBorder(widget.primaryBorderColor),
        errorBorder: _buildBorder(widget.errorBorderColor),

        filled: true,
        fillColor: const Color(0xFFEFEFEF),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.spMin),
      borderSide: BorderSide(color: color),
    );
  }
}
