import 'package:flutter/material.dart';
import 'package:note_arkadasim/ai_services/gemma_ai_service.dart';

class GemmaPage extends StatefulWidget {
  const GemmaPage({Key? key}) : super(key: key);

  @override
  State<GemmaPage> createState() => _GemmaPageState();
}

class _GemmaPageState extends State<GemmaPage> {
  final gemmaService = GemmaService(
    modelUrl: 'https://huggingface.co/google/gemma-3-1b-it/resolve/main/gemma-3-1b-it-Q4_K_M.gguf',
  );

  final TextEditingController _controller = TextEditingController();

  final List<_ChatMessage> _messages = [];
  bool _isModelLoading = true;
  bool _isChatting = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    setState(() {
      _isModelLoading = true;
    });

    await gemmaService.init();

    setState(() {
      _isModelLoading = false;
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty || _isChatting || _isModelLoading) return;

    setState(() {
      _messages.add(_ChatMessage(text: message, isUser: true));
      _isChatting = true;
    });

    _controller.clear();

    final responseBuffer = StringBuffer();
    _messages.add(_ChatMessage(text: "", isUser: false));
    final responseIndex = _messages.length - 1;

    try {
      await for (final token in gemmaService.promptStream(message)) {
        responseBuffer.write(token);
        setState(() {
          _messages[responseIndex] = _ChatMessage(text: responseBuffer.toString(), isUser: false);
        });
      }
    } catch (e) {
      setState(() {
        _messages[responseIndex] = _ChatMessage(text: "Hata: $e", isUser: false);
      });
    }

    setState(() {
      _isChatting = false;
    });
  }

  @override
  void dispose() {
    gemmaService.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Gemma Chat")),
      body: SafeArea(
        child: Column(
          children: [
            if (_isModelLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: const [
                    LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor: Colors.grey,
                      color: Colors.purple,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Model yükleniyor...",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        gradient: msg.isUser
                            ? const LinearGradient(colors: [Colors.purple, Colors.blue])
                            : LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade200]),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
                          bottomRight: Radius.circular(msg.isUser ? 0 : 16),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.scaffoldBackgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) => _sendMessage(value),
                      decoration: const InputDecoration(
                        hintText: "Mesajınızı yazın...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xfff1f1f1),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                      enabled: !_isModelLoading && !_isChatting,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: (_isModelLoading || _isChatting) ? Colors.grey : Colors.purple,
                    ),
                    onPressed: (_isModelLoading || _isChatting) ? null : () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}
