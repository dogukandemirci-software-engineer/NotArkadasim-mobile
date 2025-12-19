import 'package:flutter/material.dart';
import 'package:note_arkadasim/themes/theme.dart'; // Bu import'un dosyada mevcut olduğunu varsayıyoruz

Widget buildDropdownField({
  required String label,
  required String? value,
  required List<String> items,
  required void Function(String?) onChanged,
  required IconData icon,
  bool initialDataLoading = true
}) {
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
      DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: surfaceColor,
          prefixIcon: Icon(icon, color: bodyTextColor, size: 22),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        hint: Text(
          initialDataLoading ? 'Yükleniyor...' : 'Seçiniz',
          style: TextStyle(
            color: bodyTextColor.withOpacity(0.6),
            fontSize: 16,
            fontFamily: primaryFontFamily,
          ),
        ),
        style: const TextStyle(
          color: headingColor,
          fontSize: 16,
          fontFamily: primaryFontFamily,
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: bodyTextColor),
        dropdownColor: surfaceColor,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: primaryFontFamily,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    ],
  );
}
