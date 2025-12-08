import 'dart:async';             // Stream (Sensör) ve Timer (Animasyon) yönetimi için
import 'dart:ui' as ui;          // Shader (FragmentProgram) ve düşük seviye çizim için
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Parti Paket
import 'package:sensors_plus/sensors_plus.dart'; // Pubspec'e eklediğin sensör paketi

// Kendi Proje Dosyaların
import 'package:note_arkadasim/services/user_service.dart';
import 'package:note_arkadasim/themes/theme.dart';

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

  // Tilt değerini saklayan değişken
  double _currentTilt = 0.0;

  @override
  void initState() {
    super.initState();
    _initShader();

    // Animasyon döngüsü (Sıvının dalgalanması için)
    _timeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Döngü biraz daha hızlı olsun
    )..repeat();

    _initSensors();
  }

  void _initShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset('shaders/liquid_button.frag');
      if (mounted) {
        setState(() {
          _program = program;
        });
      }
    } catch (e) {
      debugPrint("Shader hatası: $e");
    }
  }

  void _initSensors() {
    // DİKKAT: Emülatörde sensör çalışmaz. Gerçek cihazda test edin.
    _sensorSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!mounted) return;

      // X ekseni: Telefonu sağa yatırırsanız (sol taraf yukarı), x negatiftir (genellikle).
      // Sağa tam yatış yaklaşık -9.8, Sola tam yatış +9.8 civarıdır.

      // Değeri -1.0 ile 1.0 arasına sıkıştıralım (Clamp)
      // Hassasiyeti artırmak için 9.8 yerine 7.0'a bölüyorum.
      double rawTilt = -event.x / 7.0;

      if (rawTilt > 1.0) rawTilt = 1.0;
      if (rawTilt < -1.0) rawTilt = -1.0;

      // "Lerp" (Yumuşak geçiş) - Çok titremesin ama hızlı tepki versin (0.2 iyi bir oran)
      double smoothedTilt = _currentTilt + (rawTilt - _currentTilt) * 0.2;

      setState(() {
        _currentTilt = smoothedTilt;
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
    if (_program == null) {
      // Yüklenirken standart görünüm
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple),
        ),
        child: const Center(child: Text("Yükleniyor...")),
      );
    }

    return GestureDetector(
      onTap: widget.onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Arka plan: Shader Çizimi
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _timeController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: LiquidShaderPainter(
                      shaderProgram: _program!,
                      time: _timeController.value,
                      tilt: _currentTilt, // Güncel eğim değerini gönderiyoruz
                    ),
                  );
                },
              ),
            ),

            // Ön plan: Yazı ve Efektler
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [
                      Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, 0))
                    ],
                  ),
                ),
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

    // Uniform indexleri GLSL dosyasındaki sıraya göredir:
    // uniform vec2 uSize; (Index 0)
    // uniform float uTime; (Index 1 - DİKKAT: vec2 float, float sayıldığı için index kayabilir mi?
    // Hayır, Flutter API'sinde:
    // setFloat(0) -> uSize.x
    // setFloat(1) -> uSize.y
    // setFloat(2) -> uTime
    // setFloat(3) -> uTilt

    shader.setFloat(0, size.width);  // uSize.x
    shader.setFloat(1, size.height); // uSize.y
    shader.setFloat(2, time * 3.14159 * 2); // uTime (Tam tur)
    shader.setFloat(3, tilt);        // uTilt

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