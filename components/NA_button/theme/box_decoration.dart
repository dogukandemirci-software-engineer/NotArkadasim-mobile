import 'package:flutter/material.dart';
import '../../../themes/theme.dart';

final naBoxDecoration = BoxDecoration(
  gradient: const LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  borderRadius: BorderRadius.circular(6),
  boxShadow: [
    BoxShadow(
      color: primaryColor.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ],
);