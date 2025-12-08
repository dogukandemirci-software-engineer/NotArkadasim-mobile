import 'package:flutter/material.dart';
import 'package:note_arkadasim/themes/theme.dart'; // Bu import'un dosyada mevcut olduğunu varsayıyoruz

Widget buildNAText(BuildContext context, String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    ),
  );
}