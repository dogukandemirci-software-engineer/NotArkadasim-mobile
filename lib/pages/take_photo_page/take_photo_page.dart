import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isCameraReady = false;
  int cameraIndex = 0;
  FlashMode flashMode = FlashMode.off;

  late AnimationController flashAnimController;

  @override
  void initState() {
    super.initState();
    flashAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Kamera izni gerekli")));
      }
      return;
    }

    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) return;

    controller = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();
    await controller!.setFlashMode(flashMode);

    if (mounted) {
      setState(() => isCameraReady = true);
    }
  }

  Future<void> _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) return;
    if (controller!.value.isTakingPicture) return;

    try {
      await flashAnimController.forward();
      await flashAnimController.reverse();

      final XFile file = await controller!.takePicture();
      final dir = await getApplicationDocumentsDirectory();
      final String path = join(
        dir.path,
        'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await file.saveTo(path);
      context.read<PhotoProvider>().setPhoto(path);

      // 📸 Kullanıcıya sor
      if (!mounted) return;
      final saveToGallery = await _showSaveDialog(context);

      if (saveToGallery == true) {
        await _saveToGallery(path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fotoğraf galeriye kaydedildi ✅")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fotoğraf yalnızca uygulamada saklandı 📁")),
          );
        }
      }
    } catch (e) {
      debugPrint("Fotoğraf çekme hatası: $e");
    }
  }

  Future<void> _saveToGallery(String path) async {
  }

  Future<bool?> _showSaveDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kaydetme Seçeneği"),
        content: const Text("Fotoğrafı galeriye de kaydetmek ister misin?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hayır"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Evet"),
          ),
        ],
      ),
    );
  }

  Future<void> _switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;
    cameraIndex = (cameraIndex + 1) % cameras!.length;
    await controller?.dispose();
    controller = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller!.initialize();
    await controller!.setFlashMode(flashMode);
    setState(() {});
  }

  void _cycleFlash() async {
    if (flashMode == FlashMode.off) {
      flashMode = FlashMode.auto;
    } else if (flashMode == FlashMode.auto) {
      flashMode = FlashMode.always;
    } else {
      flashMode = FlashMode.off;
    }
    await controller?.setFlashMode(flashMode);
    setState(() {});
  }

  IconData _flashIcon() {
    switch (flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      default:
        return Icons.flash_off;
    }
  }

  @override
  void dispose() {
    flashAnimController.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: !isCameraReady
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller!.value.previewSize!.height,
                height: controller!.value.previewSize!.width,
                child: CameraPreview(controller!),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Fotoğraf Çek",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _cycleFlash,
                    icon: Icon(_flashIcon(), color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _switchCamera,
                  icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 32),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _takePicture,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF7B2FF7), Color(0xFF2F80ED)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt, size: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
