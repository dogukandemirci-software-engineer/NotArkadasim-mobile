import 'package:flutter/cupertino.dart';
import 'package:note_arkadasim/themes/theme.dart'; // Bu import'un dosyada mevcut olduğunu varsayıyoruz

Widget buildNAText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..shader = const LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
    ),
  );
}