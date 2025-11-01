import 'package:flutter/material.dart';

class AppCheckboxTheme {
  AppCheckboxTheme._();

  /// -- Light Theme
  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white; // Color of the check mark
      } else {
        return Colors.black; // Default color when not selected
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue; // Color of the checkbox when selected
      } else {
        return Colors.transparent; // Default color when not selected
      }
    }),
  );

  /// -- Dark Theme
  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white; // Color of the check mark
      } else {
        return Colors.grey; // Default color when not selected
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue; // Color of the checkbox when selected
      } else {
        return Colors.transparent; // Default color when not selected
      }
    }),
  );
}
