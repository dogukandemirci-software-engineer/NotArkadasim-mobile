import 'package:flutter/material.dart';
import 'package:note_arkadasim/pages/add_news/add_news_page.dart';
import 'package:note_arkadasim/pages/add_note/add_note_page.dart';
import 'package:note_arkadasim/pages/home/home_page.dart';
import 'package:note_arkadasim/routes/routes.dart';
import 'package:note_arkadasim/services/navigation_service/navigation_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.instance.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      routes: AppRoutes.routes,
    );
  }
}
