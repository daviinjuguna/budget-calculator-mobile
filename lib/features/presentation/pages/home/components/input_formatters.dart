import 'package:flutter/services.dart';

class CustomRangeTextInputFormatter extends TextInputFormatter {
  final double maxValue;

  CustomRangeTextInputFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') return TextEditingValue(text: "0.0");
    if (double.parse(newValue.text) < 0.0)
      return TextEditingValue().copyWith(text: '0.0');

    return double.parse(newValue.text) > maxValue
        ? TextEditingValue().copyWith(text: maxValue.toString())
        : newValue;
  }
}
