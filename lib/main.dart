import 'package:flutter/material.dart';
import 'package:note_arkadasim/pages/auth/change_password/change_password_page.dart';
import 'package:note_arkadasim/pages/auth/email/email_page.dart';
import 'package:note_arkadasim/pages/auth/login/login_page.dart';
import 'package:note_arkadasim/pages/auth/register/register_page.dart';
import 'package:note_arkadasim/pages/home/home_page.dart';
import 'package:note_arkadasim/pages/on_board/onboard_page.dart';
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
      home: const LoginPage(),
      routes: AppRoutes.routes,
    );
  }
}
