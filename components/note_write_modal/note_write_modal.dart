import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../ai_services/ocr_service.dart';
import '../../ai_services/voice_service.dart';
import '../../utils/pdf_service.dart';

class NoteInputModal extends StatefulWidget {
  const NoteInputModal({super.key});

  @override
  State<NoteInputModal> createState() => _NoteInputModalState();
}

class _NoteInputModalState extends State<NoteInputModal> {
  final TextEditingController controller = TextEditingController();
  final OCRService ocrService = OCRService();
  final VoiceService voiceService = VoiceService();
  final PdfService pdfService = PdfService();

  final List<String> undoStack = [];
  final List<String> redoStack = [];
  bool micActive = false;

  void pushStack() {
    undoStack.add(controller.text);
    if (undoStack.length > 200) undoStack.removeAt(0);
  }

  void undo() {
    if (undoStack.isEmpty) return;
    redoStack.add(controller.text);
    controller.text = undoStack.removeLast();
    controller.selection = TextSelection.collapsed(offset: controller.text.length);
  }

  void redo() {
    if (redoStack.isEmpty) return;
    undoStack.add(controller.text);
    controller.text = redoStack.removeLast();
  }

  Future<void> scanImage() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    pushStack();
    final text = await ocrService.extractText(File(image.path));
    controller.text += "\n$text";
  }

  Future<void> toggleVoice() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return;  // İzin yoksa devam etme

    if (!micActive) {
      if (await voiceService.init()) {
        pushStack();
        voiceService.start((value) {
          setState(() => controller.text += " $value");
        });
        setState(() => micActive = true);
      }
    } else {
      voiceService.stop();
      setState(() => micActive = false);
    }
  }

  Future<void> savePdf() async {
    await pdfService.savePdf(controller.text, "notum");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            maxLines: 10,
            style: const TextStyle(
              fontFamily: "SegoeUI",
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              hintText: "Notunu yaz...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            onChanged: (_) => pushStack(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _button(Icons.undo, undo),
              _button(Icons.redo, redo),
              _button(Icons.camera_alt, scanImage),
              _micButton(),
              _button(Icons.picture_as_pdf, savePdf),
            ],
          ),
          SizedBox(height: 24,)
        ],
      ),
    );
  }

  Widget _button(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onTap,
    );
  }

  Widget _micButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
        boxShadow: micActive
            ? [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.7),
            blurRadius: 18,
            spreadRadius: 2,
          )
        ]
            : [],
      ),
      child: IconButton(
        icon: Icon(
          micActive ? Icons.mic : Icons.mic_none,
          color: Colors.white,
        ),
        onPressed: toggleVoice,
      ),
    );
  }
}
