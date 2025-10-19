import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_bottom_navigationbar/NA_bottom_navigationbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
