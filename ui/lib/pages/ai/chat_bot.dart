import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:no_code/Utils/show_toast.dart';
import 'package:no_code/controllers/auth_controllers/auth_methods.dart';

class AiChatApp extends StatefulWidget {
  const AiChatApp({super.key});

  @override
  State<AiChatApp> createState() => _AiChatAppState();
}

class _AiChatAppState extends State<AiChatApp> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AuthController c = Get.find();
  final List<_ChatMessage> _messages = [];
  bool _loading = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _loading) return;

    setState(() {
      _messages.add(_ChatMessage(text, isUser: true, isMarkdown: false));
      _controller.clear();
      _loading = true;
    });

    _scrollToBottom();

    final response = await getResponse(text);
    final markdownResponse = formatAIResponseToMarkdown(response);

    setState(() {
      _messages.add(_ChatMessage(markdownResponse, isUser: false, isMarkdown: true));
      _loading = false;
    });

    _scrollToBottom();
  }

  String formatAIResponseToMarkdown(String raw) {
    String cleaned = raw
        .replaceAll(r'\"', '"')
        .replaceAll(r'\n\n', '\n\n')
        .replaceAll(r'\n', '\n')
        .trim();

    cleaned = cleaned.replaceAllMapped(RegExp(r'(?<=^|\n)(.*?)(:)', dotAll: true), (match) {
      return '**${match[1]?.trim()}**${match[2]}';
    });

    cleaned = cleaned.replaceAll('- ', '\n- ');

    return cleaned;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<String> getResponse(String prompt) async {
    final res = await c.getAPIRes(context, prompt);
    return res.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediScanAI')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: msg.isMarkdown
                        ? MarkdownBody(data: msg.text)
                        : Text(msg.text, style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  child: const Icon(Icons.mic),
                  onTap: () async {
                    showToast('Your voice will be recorded...', Colors.blue);
                    await Future.delayed(const Duration(seconds: 3));
                    showToast('Your voice was recorded...', Colors.green);
                  },
                ),
                const SizedBox(width: 23),
                GestureDetector(
                  child: const Icon(Icons.camera_alt),
                  onTap: () async {
                    final imgPicker = ImagePicker();
                    await imgPicker.pickImage(source: ImageSource.gallery);
                    showToast('Image picked (handle it as needed)', Colors.orange);
                  },
                ),
                const SizedBox(width: 23),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isMarkdown;

  _ChatMessage(this.text, {required this.isUser, required this.isMarkdown});
}
