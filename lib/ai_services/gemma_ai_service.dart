import 'package:flutter_gemma/flutter_gemma.dart';

class GemmaService {
  final String modelUrl;
  late InferenceModel _model;

  GemmaService({ required this.modelUrl });

  Future<void> init() async {
    await FlutterGemma.installModel(modelType: ModelType.gemmaIt)
        .fromNetwork(modelUrl)
        .withProgress((int pct) {
      print('Download: $pct%');
    })
        .install();

    _model = await FlutterGemma.getActiveModel(
      maxTokens: 512,
      preferredBackend: PreferredBackend.gpu,
    );
  }

  /// Tek seferlik prompt → cevap (sync)
  Future<String> promptOnce(String prompt) async {
    final session = await _model.createSession();
    await session.addQueryChunk(Message.text(text: prompt, isUser: true));
    final response = await session.getResponse();
    await session.close();
    return response;
  }

  /// Streaming token‑token cevap almak istersen
  Stream<String> promptStream(String prompt) async* {
    final session = await _model.createSession();
    await session.addQueryChunk(Message.text(text: prompt, isUser: true));
    await for (final token in session.getResponseAsync()) {
      yield token;
    }
    await session.close();
  }

  Future<void> dispose() async {
    await _model.close();
  }
}