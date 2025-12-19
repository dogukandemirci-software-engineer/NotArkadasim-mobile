import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_text/NA_text.dart';
import 'package:note_arkadasim/themes/theme.dart'; // Bu import'un dosyada mevcut olduğunu varsayıyoruz

Widget buildNAClassicHeader(BuildContext context, ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildNAText(context, "Hesap Oluştur"),
      const SizedBox(height: 8),
      Text(
        'Notlarınızızı paylaşmaya başlamak için kayıt olun',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: bodyTextColor,
        ),
      ),
    ],
  );
}