import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<bool> init() async {
    return await _speech.initialize();
  }

  void start(Function(String) onText) {
    _speech.listen(onResult: (res) => onText(res.recognizedWords));
  }

  void stop() {
    _speech.stop();
  }

  bool get isListening => _speech.isListening;
}
