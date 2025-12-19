import 'package:flutter/material.dart';
import 'package:note_arkadasim/themes/theme.dart';

Widget buildPasswordTextField({
  required TextEditingController controller,
  required String label,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  IconData? prefixIcon,
}) {
  final obscureNotifier = ValueNotifier<bool>(true); // gizli başla

  return ValueListenableBuilder<bool>(
    valueListenable: obscureNotifier,
    builder: (context, obscureText, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: headingColor,
              fontFamily: primaryFontFamily,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: const TextStyle(
              fontSize: 16,
              color: headingColor,
              fontFamily: primaryFontFamily,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: bodyTextColor, size: 22)
                  : null,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: bodyTextColor,
                ),
                onPressed: () {
                  obscureNotifier.value = !obscureNotifier.value;
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE6E3F1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE6E3F1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: primaryColor, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: errorColor, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: errorColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
          ),
        ],
      );
    },
  );
}
