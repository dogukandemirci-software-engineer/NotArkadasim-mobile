import 'package:flutter/material.dart';
import 'package:note_arkadasim/pages/auth/change_password/change_password_page.dart';
import 'package:note_arkadasim/pages/auth/login/login_page.dart';
import '../pages/auth/email/email_page.dart';
import '../pages/auth/register/register_page.dart';
import '../pages/home/home_page.dart';

class AppRoutes {
  // Route isimleri sabit olarak burada tanımlanır
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String email = '/email';
  static const String changePassword = '/change-password';

  // Route haritası
  static Map<String, WidgetBuilder> get routes => {
     register: (context) => const RegisterPage(),
     home: (context) => const HomePage(),
     login: (context) => const LoginPage(),
     email: (context) => const EmailPage(),
     changePassword: (context) => const ChangePasswordPage(),
  };


}
