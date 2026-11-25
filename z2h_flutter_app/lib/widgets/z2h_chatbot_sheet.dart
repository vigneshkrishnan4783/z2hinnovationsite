import 'package:flutter/material.dart';
import '../theme/z2h_theme.dart';

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

Future<void> showZ2HChatbotSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Z2HColors.bgSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      side: BorderSide(color: Z2HColors.borderSubtle),
    ),
    builder: (ctx) => const _Z2HChatbotSheet(),
  );
}

class _Z2HChatbotSheet extends StatefulWidget {
  const _Z2HChatbotSheet();

  @override
  State<_Z2HChatbotSheet> createState() => _Z2HChatbotSheetState();
}

class _Z2HChatbotSheetState extends State<_Z2HChatbotSheet> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedTopic = 'AI & LLM Solutions';

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          'Hello! Welcome to Z2H Innovations & R&D Lab Customer Care. Select a topic below or ask your question directly.',
      isUser: false,
    ),
  ];

  static const _quickTopics = <String, String>{
    'AI & LLM Solutions':
        'We engineer custom LLM copilots, RAG knowledge engines, and deep learning workflows from Zero to Market. Tell us what problem you want to solve!',
    'Flutter Mobile & Web':
        'We build single-codebase Flutter applications responsive across iPhone, Android, tablets, and desktops. Which platforms are you targeting?',
    'API & Backend Systems':
        'We architect scalable REST/GraphQL APIs, Hibernate ORM data layers, and cloud deployments. Share your system requirements anytime.',
    'Freelance / IT Consulting':
        'Our senior engineers and freelance pods help startups launch market-ready products fast. What timeline are you aiming for?',
  };

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _selectTopic(String topic) {
    setState(() {
      _selectedTopic = topic;
      _messages.add(_ChatMessage(text: 'Tell me about $topic.', isUser: true));
      _messages.add(_ChatMessage(text: _quickTopics[topic]!, isUser: false));
    });
    _scrollToBottom();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messages.add(
        _ChatMessage(
          text:
              'Thank you for reaching out regarding "$_selectedTopic". Our Z2H team at Kuruvankonam, Kowdiar has noted your message and can assist you further.',
          isUser: false,
        ),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 10, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Z2HColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Z2HColors.accentCyan.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.support_agent_rounded, color: Z2HColors.accentCyan, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Z2H Customer Care', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        Text(
                          'Interactive Support & Inquiry Chatbot',
                          style: TextStyle(color: Z2HColors.textMuted, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickTopics.keys.map((topic) {
                    final active = topic == _selectedTopic;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(topic, style: const TextStyle(fontSize: 11.5)),
                        backgroundColor: active ? Z2HColors.accentCyan.withOpacity(0.18) : null,
                        side: BorderSide(
                          color: active ? Z2HColors.accentCyan : Z2HColors.borderSubtle,
                        ),
                        onPressed: () => _selectTopic(topic),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(14),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 320),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? Z2HColors.accentCyan.withOpacity(0.16)
                            : Z2HColors.bgSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: msg.isUser
                              ? Z2HColors.accentCyan.withOpacity(0.4)
                              : Z2HColors.borderSubtle,
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: const TextStyle(fontSize: 13.5, height: 1.4),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Z2HColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Ask our customer care assistant...',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded, size: 18),
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
