import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

PageViewModel buildSelectionPageViewModel({
  required Set<String> selected,
  required Function(String) onOptionTapped,
}) {
  final List<String> options = [
    '🧐 Meraklı',
    '🎨 Hayal perest',
    '🧠 Analitik',
    '🤝 Sosyalleşmeyi seven',
    '🎯 Hedef odaklı',
    '💭 Düşünceli',
    '⚡ Enerjik',
    '🌿 Sakin',
    '🏔️ Macera tutkunu',
    '🎶 Sanatsever',
    '🛠️ Problem çözücü',
    '☁️ Hayalperest',
  ];


  return PageViewModel(
    title: "Kendini ne olarak tanımlarsın",
    bodyWidget: Center(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shrinkWrap: true,
        itemCount: options.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 sütun
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5, // genişlik-yükseklik oranı
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selected.contains(option);

          return GestureDetector(
            onTap: () => onOptionTapped(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? Colors.purple.withOpacity(0.4)
                        : Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                option,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 32),
        bodyTextStyle: TextStyle(color: Colors.white , fontSize: 24),
    ),
  );
}
