import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(
    BuildContext context,
    String title, {
      bool noLeading = false,
    }) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60), // sabit yükseklik
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 60, // sabit yükseklik
          alignment: Alignment.center,
          child: Row(
            children: [
              // Leading (isteğe bağlı)
              if (!noLeading)
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => Navigator.of(context).maybePop(),
                  splashRadius: 24,
                  tooltip: 'Geri',
                )
              else
                const SizedBox(width: 48), // yer tutucu, simetriyi korur

              // Title
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Sağ boşluk, sol taraftaki ikonla simetri sağlar
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    ),
  );
}
