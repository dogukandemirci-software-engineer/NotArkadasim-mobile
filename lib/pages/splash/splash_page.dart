import 'package:flutter/material.dart';
import 'package:note_arkadasim/pages/auth/login/login_page.dart';
import 'package:note_arkadasim/pages/home/home_page.dart';
import 'package:note_arkadasim/pages/on_board/onboard_page.dart';
import 'package:note_arkadasim/services/api_services/note_api/note_upsert_service.dart';
import 'package:note_arkadasim/services/onboarding_service.dart';
import 'package:note_arkadasim/services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Kısa bir gecikme ekleyerek splash screen'in görünmesini sağla
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final hasSeenOnboarding = await OnboardingService().hasSeenOnboarding();
    final isLoggedIn = await UserService().isLoggedIn();

    if (isLoggedIn) {
      // Oturum varsa, not ekleme verilerini arka planda çekmeye başla
      // Bu işlemi beklemiyoruz (fire-and-forget) ki splash screen takılmasın
      NoteUpsertService().getNoteUpsertData();
    }

    Widget page;
    if (isLoggedIn) {
      page = const HomePage();
    } else if (hasSeenOnboarding) {
      page = const LoginPage();
    } else {
      page = const OnboardingPage();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_bg.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
