import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_bottom_navigationbar/NA_bottom_navigationbar.dart';
import 'package:note_arkadasim/pages/add_news/add_news_page.dart';
import 'package:note_arkadasim/pages/add_note/add_note_page.dart';
import 'package:note_arkadasim/pages/home/home_page_content.dart';
import 'package:note_arkadasim/pages/news/news_page.dart';
import 'package:note_arkadasim/pages/profile_menu/profile_menu_page/profile_menu_page.dart';

import '../notes/notes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(), // Ana sayfa içeriği
    const NotesPage(),
    const NewsPage(),
    const AddNewsPage(),
    const AddNotePage(),
    const ProfileMenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.zero, // Boyut sıfır
      child: SizedBox.shrink(), // Boş widget
      ),
      body: _pages[_currentIndex], // Burada seçili sayfa gösteriliyor
      bottomNavigationBar: buildNaNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
