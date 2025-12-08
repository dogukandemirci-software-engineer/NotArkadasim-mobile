import 'dart:async'; // Timer ve Stream için
import 'dart:ui' as ui; // Shader için
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart'; // Sensör paketi
import 'package:note_arkadasim/services/user_service.dart';
import 'package:note_arkadasim/themes/theme.dart';

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
                  child: _buildStatCard(
                    icon: Icons.notes,
                    title: 'Toplam Not',
                    value: '24',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.newspaper,
                    title: 'Toplam Haber',
                    value: '12',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Recent Notes Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Son Notlarınız',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: headingColor,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Tümü',
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildRecentNoteCard(
              title: 'Flutter ile UI Tasarımı',
              subject: 'Mobil Programlama',
              date: '15 Nisan, 2025',
              type: 'PDF',
            ),

            const SizedBox(height: 12),

            _buildRecentNoteCard(
              title: 'Veri Tabanı Modelleri',
              subject: 'Veri Tabanı',
              date: '14 Nisan, 2025',
              type: 'Görsel',
            ),

            const SizedBox(height: 20),

            // Recent News Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Son Haberler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: headingColor,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Tümü',
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildRecentNewsCard(
              title: 'Yeni Dönem Başvuruları Başladı',
              summary: '2025-2026 bahar dönemine ait ders seçimi başvuruları...',
              date: '16 Nisan, 2025',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.purple,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: bodyTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: headingColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNoteCard({
    required String title,
    required String subject,
    required String date,
    required String type,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: headingColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 12,
                      color: bodyTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: bodyTextColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {},
              iconSize: 16,
              color: bodyTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentNewsCard({
    required String title,
    required String summary,
    required String date,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: headingColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              summary,
              style: const TextStyle(
                fontSize: 14,
                color: bodyTextColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: bodyTextColor,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Devamını Oku',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- SHADER VE SENSÖR BUTON BİLEŞENLERİ ---
// Bu kısmı dosyanın en altına ekledik.

class LiquidSensorButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const LiquidSensorButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  State<LiquidSensorButton> createState() => _LiquidSensorButtonState();
}

class _LiquidSensorButtonState extends State<LiquidSensorButton> with SingleTickerProviderStateMixin {
  ui.FragmentProgram? _program;
  late AnimationController _timeController;
  StreamSubscription<AccelerometerEvent>? _sensorSubscription;
  double _tiltX = 0.0;

  @override
  void initState() {
    super.initState();
    _initShader();

    // Sürekli akan zaman animasyonu
    _timeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initSensors();
  }

  void _initShader() async {
    try {
      // Shader dosyasının pubspec.yaml'da tanımlı olduğundan ve
      // shaders/liquid_button.frag yolunda olduğundan emin olun.
      final program = await ui.FragmentProgram.fromAsset('shaders/liquid_button.frag');
      if (mounted) {
        setState(() {
          _program = program;
        });
      }
    } catch (e) {
      debugPrint("Shader yükleme hatası: $e");
    }
  }

  void _initSensors() {
    // Sensör verisini dinle ve yumuşatarak tilt değerine çevir
    _sensorSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!mounted) return;

      // Telefonun X eksenindeki hareketi (-10 ~ 10 arası)
      // Bunu -1.0 ile 1.0 arasına sıkıştırıyoruz.
      // -event.x yaparak hareketi doğal (su gibi) hale getiriyoruz.
      double rawX = -event.x;
      if (rawX > 9.0) rawX = 9.0;
      if (rawX < -9.0) rawX = -9.0;

      double normalizedTilt = rawX / 9.0;

      // Değeri yumuşat (Linear Interpolation)
      setState(() {
        _tiltX = _tiltX + (normalizedTilt - _tiltX) * 0.1;
      });
    });
  }

  @override
  void dispose() {
    _timeController.dispose();
    _sensorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Shader yüklenene kadar basit bir buton göster
    if (_program == null) {
      return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(widget.text),
      );
    }

    return GestureDetector(
      onTap: widget.onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Arka plan: Shader
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _timeController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: LiquidShaderPainter(
                      shaderProgram: _program!,
                      time: _timeController.value,
                      tilt: _tiltX,
                    ),
                  );
                },
              ),
            ),

            // Ön plan: Yazı
            Center(
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2.0,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),

            // Tıklama efekti (Ripple)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiquidShaderPainter extends CustomPainter {
  final ui.FragmentProgram shaderProgram;
  final double time;
  final double tilt;

  LiquidShaderPainter({
    required this.shaderProgram,
    required this.time,
    required this.tilt,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shader = shaderProgram.fragmentShader();

    // Uniformları ata:
    // 0: uSize (width, height)
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    // 1: uTime
    shader.setFloat(2, time * 6.28); // 0..2PI arası döngü

    // 2: uTilt
    shader.setFloat(3, tilt);

    final paint = Paint()..shader = shader;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant LiquidShaderPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.tilt != tilt;
  }
}