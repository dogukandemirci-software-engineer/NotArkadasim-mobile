import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_text/NA_text.dart';
import 'package:note_arkadasim/themes/theme.dart'; // Bu import'un dosyada mevcut olduğunu varsayıyoruz

Widget buildNAClassicHeader(ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildNAText("Hesap Oluştur"),
      const SizedBox(height: 8),
      Text(
        'Notlarınızı paylaşmaya başlamak için kayıt olun',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: bodyTextColor,
        ),
      ),
    ],
  );
}