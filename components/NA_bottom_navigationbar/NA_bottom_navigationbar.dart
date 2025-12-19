import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter

Widget buildNaNavigationBar({
  required int currentIndex,
  required Function(int) onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple.withOpacity(0.9), Colors.blue.withOpacity(0.9)], // Yarı saydam gradyan
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.purple.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, -2),
        ),
      ],
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent, // Arka plan şeffaf
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white, // Seçili ikon rengi
        unselectedItemColor: Colors.white.withOpacity(0.6), // Seçili olmayan ikon rengi
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_outlined),
            activeIcon: Icon(Icons.note),
            label: 'Notlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Haberler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Haber Ekle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add_outlined),
            activeIcon: Icon(Icons.note_add),
            label: 'Not Ekle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    ),
  );
}