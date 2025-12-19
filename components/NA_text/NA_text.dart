import 'package:flutter/material.dart';

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