import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:note_arkadasim/services/onboarding_service.dart';
import '../../components/NA_selection_pageviewmodel/NA_selection_pageviewmodel.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Set<String> selectedOptions = {};

  void _onDone() async {
    await OnboardingService().setOnboardingSeen();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {

    PageViewModel selectionPage = buildSelectionPageViewModel(
      selected: selectedOptions,
      onOptionTapped: (option) {
        setState(() {
          if (selectedOptions.contains(option)) selectedOptions.remove(option);
          else selectedOptions.add(option);
        });
      },
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0], // renkler yumuşak geçiş yapar
        ),
      ),
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            decoration: PageDecoration(
              titleTextStyle: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 32),
              bodyTextStyle: TextStyle(color: Colors.white , fontSize: 24)
            ),
            title: "Hoş Geldiniz",
            body: "Not almaya başlayın ve daha fazlasını keşfedin.",
            image: Center(
              child: Image.asset(
                'assets/images/logo_bg.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                color: Colors.white,          // resme renk uygular
                colorBlendMode: BlendMode.modulate, // kontrast artırır
              ),
            ),
          ),
          PageViewModel(
            title: "Profil Oluşturun",
            body: "Profilinizi özelleştirin , not alma deneyiminizi zenginleştirin.",
            image: Center(child: Icon(Icons.person, color: Colors.white , size: 150)),
            decoration: const PageDecoration(
              pageColor: Colors.transparent,
                titleTextStyle: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 32),
                bodyTextStyle: TextStyle(color: Colors.white , fontSize: 24)
            ),
          ),
          selectionPage,
        ],
        onDone: _onDone,
        next: const Icon(Icons.arrow_circle_right , size: 60, color: Colors.white),
        done: const Text("Başla", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        dotsDecorator: const DotsDecorator(
          activeColor: Colors.white,
          color: Colors.white54,
        ),
        globalBackgroundColor: Colors.transparent, // gradient görünmesi için
      ),
    );
  }
}
