import 'package:flutter/material.dart';
import '../theme/z2h_theme.dart';

Future<void> showZ2HInquiryDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  String? prefilledRole,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => _InquiryDialog(
      title: title,
      subtitle: subtitle,
      prefilledRole: prefilledRole,
    ),
  );
}

class _InquiryDialog extends StatefulWidget {
  const _InquiryDialog({
    required this.title,
    required this.subtitle,
    this.prefilledRole,
  });

  final String title;
  final String subtitle;
  final String? prefilledRole;

  @override
  State<_InquiryDialog> createState() => _InquiryDialogState();
}

class _InquiryDialogState extends State<_InquiryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedTopic = 'AI & LLM Solution Development';
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Z2HColors.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Z2HColors.accentCyan.withOpacity(0.4)),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 19)),
          const SizedBox(height: 4),
          Text(
            widget.subtitle,
            style: const TextStyle(color: Z2HColors.textMuted, fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.prefilledRole != null) ...[
                  TextFormField(
                    initialValue: widget.prefilledRole,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                if (widget.prefilledRole == null) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedTopic,
                    dropdownColor: Z2HColors.bgSurface,
                    decoration: const InputDecoration(labelText: 'Focus Area'),
                    items: const [
                      DropdownMenuItem(value: 'AI & LLM Solution Development', child: Text('AI & LLM Solution Development')),
                      DropdownMenuItem(value: 'Hybrid Flutter App Build', child: Text('Hybrid Flutter App Build')),
                      DropdownMenuItem(value: 'Backend & Hibernate APIs', child: Text('Backend & Hibernate APIs')),
                      DropdownMenuItem(value: 'IT Consulting & Freelance', child: Text('IT Consulting & Freelance')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedTopic = v);
                    },
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Brief Summary'),
                ),
                if (_submitted) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Z2HColors.accentEmerald.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Z2HColors.accentEmerald.withOpacity(0.45)),
                    ),
                    child: const Text(
                      'Inquiry captured in Flutter preview mode. Ready to wire to your Z2H backend API.',
                      style: TextStyle(color: Color(0xFFA7F3D0), fontSize: 12.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _submitted = true);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
