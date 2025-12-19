import 'dart:async'; // Timer ve Stream için
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_arkadasim/services/user_service.dart';
import '../../components/build_home_tour_cards/build_home_tour_cards.dart';
import '../../components/build_note_track_card/build_note_track_card.dart';
import '../../components/build_quotas_text/build_quotas_text.dart';
import '../../components/build_stat_card/build_state_card.dart';
import '../../components/liquid_button/liquid_button.dart';
import '../gemma_page/gemma_page.dart';

// --- ANA SAYFA ---

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }


  Future<void> _loadUsername() async {
    // Burada hata almamak için try-catch bloğu veya mock veri kullanabilirsiniz
    // Eğer UserService hazırsa bu kısmı olduğu gibi bırakın.
    try {
      final username = await UserService().getUsername();
      if (mounted) {
        setState(() {
          _username = username;
        });
      }
    } catch (e) {
      debugPrint("Kullanıcı adı çekilemedi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue], // Uyumlu gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _username != null ? 'Hoşgeldin, $_username' : 'Hoşgeldiniz',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Not arkadaşım uygulamasında ders notlarınızı ve haberlerinizi takip edin',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- BURASI GÜNCELLENDİ ---
                  // Eski ElevatedButton yerine yeni Liquid butonumuz
                  SizedBox(
                    width: double.infinity,
                    height: 50, // Buton yüksekliğini buradan ayarlayabilirsin
                    child: LiquidSensorButton(
                      text: 'Not Ekle',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GemmaPage()),
                        );
                      },
                    ),
                  ),
                  // ---------------------------
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Stats Section
            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    icon: Icons.notes,
                    title: 'Toplam Not',
                    value: '24',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStatCard(
                    icon: Icons.newspaper,
                    title: 'Toplam Haber',
                    value: '12',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            buildQuotaText("NotArkadasim" , "Notlarını paylas ve oku"),

            buildHomeTourCards(),

            const SizedBox(height: 25),

            const NoteTrackCard(),

          ],
        ),
      ),
    );
  }


}
