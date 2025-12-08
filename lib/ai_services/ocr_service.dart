import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  final _textRecognizer = TextRecognizer();

  Future<String> extractText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final result = await _textRecognizer.processImage(inputImage);
    return result.text;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
