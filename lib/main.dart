import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_arkadasim/pages/auth/login/login_page.dart';
import 'package:note_arkadasim/pages/auth/register/register_page.dart';
import 'package:note_arkadasim/routes/routes.dart';
import 'package:note_arkadasim/services/api_services/get_initial_api/get_initial_upsert_service.dart';
import 'package:note_arkadasim/services/navigation_service/navigation_service.dart';

void main() async {
  // Flutter binding’i başlat
  WidgetsFlutterBinding.ensureInitialized();

  // İlk uygulama açılışında API’den veri çek ve SharedPreferences’a kaydet
  await GetInitialUpsertService.instance.getInitialUpsert();

  print(GetInitialUpsertService.instance.getColleges());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          const TextTheme(
            displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
            displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
            displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
            headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
            bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black87),
            bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
            labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
            bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black54),
            labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black54),
          ),

        ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
      routes: AppRoutes.routes,
    );
  }
}
