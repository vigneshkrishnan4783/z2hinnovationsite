import 'package:flutter/material.dart';
import '../data/z2h_data.dart';
import '../theme/z2h_theme.dart';
import '../widgets/inquiry_dialog.dart';
import '../widgets/z2h_footer.dart';

class CareersScreen extends StatefulWidget {
  const CareersScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  State<CareersScreen> createState() => _CareersScreenState();
}

class _CareersScreenState extends State<CareersScreen> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = Z2HData.roles
        .where((r) => _selectedCategory == 'all' || r.category == _selectedCategory)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = classifyWidth(constraints.maxWidth);
        final isCompact = sizeClass == ScreenSizeClass.smallPhone || sizeClass == ScreenSizeClass.mobile;
        final pad = isCompact ? 16.0 : 28.0;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: pad, vertical: 32),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Z2HColors.borderSubtle)),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CAREERS AT Z2H INNOVATIONS & R&D LAB',
                          style: TextStyle(
                            color: Z2HColors.accentCyan,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Build Frontier AI & Apps From Thiruvananthapuram',
                          style: TextStyle(fontSize: isCompact ? 24 : 34, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join our Kuruvankonam, Kowdiar R&D lab—high-ownership engineering pods working across Flutter, Backend APIs, LLMs, and Deep Learning.',
                          style: TextStyle(color: Z2HColors.textSecondary, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: pad, vertical: 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _filterChip('all', 'All Roles'),
                            _filterChip('ai', 'AI & Deep Learning'),
                            _filterChip('flutter', 'Flutter & Hybrid'),
                            _filterChip('backend', 'Backend & Consulting'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        for (final role in filtered) ...[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: isCompact
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _RoleInfo(role: role),
                                        const SizedBox(height: 14),
                                        SizedBox(
                                          width: double.infinity,
                                          child: FilledButton(
                                            onPressed: () => _openApply(context, role.title),
                                            child: const Text('Apply Now'),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(child: _RoleInfo(role: role)),
                                        const SizedBox(width: 16),
                                        FilledButton(
                                          onPressed: () => _openApply(context, role.title),
                                          child: const Text('Apply Now'),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Z2HFooter(onNavigate: widget.onNavigate),
            ],
          ),
        );
      },
    );
  }

  void _openApply(BuildContext context, String roleTitle) {
    showZ2HInquiryDialog(
      context,
      title: 'Apply to Z2H R&D Lab',
      subtitle: 'Share your profile with our Thiruvananthapuram engineering team.',
      prefilledRole: roleTitle,
    );
  }

  Widget _filterChip(String key, String label) {
    final active = _selectedCategory == key;
    return ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) => setState(() => _selectedCategory = key),
      selectedColor: Z2HColors.accentCyan,
      labelStyle: TextStyle(
        color: active ? const Color(0xFF040711) : Z2HColors.textSecondary,
        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}

class _RoleInfo extends StatelessWidget {
  const _RoleInfo({required this.role});
  final CareerRole role;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(role.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            Text(role.location, style: const TextStyle(color: Z2HColors.textMuted, fontSize: 13)),
            Text('• ${role.type}', style: const TextStyle(color: Z2HColors.textMuted, fontSize: 13)),
            Text('• ${role.stack}', style: const TextStyle(color: Z2HColors.accentCyan, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}
