import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

Widget buildQuotaText(String title, String content) {
  return SizedBox(
    width: double.infinity,
    height: 80,
    child: DefaultTextStyle(
      style: const TextStyle(
        fontSize: 30,
        color: Colors.purple, // kritik
        fontWeight: FontWeight.w500,
      ),
      child: AnimatedTextKit(
        repeatForever: true,
        pause: const Duration(milliseconds: 800),
        animatedTexts: [
          WavyAnimatedText(title),
          WavyAnimatedText(content),
        ],
      ),
    ),
  );
}
