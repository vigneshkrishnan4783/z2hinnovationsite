import 'package:flutter/material.dart';
import '../data/z2h_data.dart';
import '../theme/z2h_theme.dart';
import '../widgets/inquiry_dialog.dart';
import '../widgets/z2h_footer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = Z2HData.services
        .where((s) => _selectedCategory == 'all' || s.category == _selectedCategory)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = classifyWidth(constraints.maxWidth);
        final isCompact = sizeClass == ScreenSizeClass.smallPhone || sizeClass == ScreenSizeClass.mobile;
        final pad = isCompact ? 16.0 : 28.0;
        final cols = switch (sizeClass) {
          ScreenSizeClass.desktop => 3,
          ScreenSizeClass.tablet => 2,
          ScreenSizeClass.mobile || ScreenSizeClass.smallPhone => 1,
        };

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
                          'SERVICES & CAPABILITIES',
                          style: TextStyle(
                            color: Z2HColors.accentCyan,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Full-Spectrum Engineering & Applied AI Delivery',
                          style: TextStyle(fontSize: isCompact ? 24 : 34, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'From IT consultancy and freelance engineering sprints to Flutter hybrid apps, Hibernate/API backends, and deep learning research.',
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
                            _filterChip('all', 'All Capabilities'),
                            _filterChip('consulting', 'IT Consultancy & Freelance'),
                            _filterChip('engineering', 'Apps & Backend'),
                            _filterChip('ai', 'LLM & Deep Learning R&D'),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _buildCards(filtered, cols),
                        const SizedBox(height: 28),
                        Center(
                          child: FilledButton.icon(
                            onPressed: () => showZ2HInquiryDialog(
                              context,
                              title: 'Start a Project With Z2H',
                              subtitle: 'Share your requirements for a tailored engineering proposal.',
                            ),
                            icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                            label: const Text('Request Technical Proposal'),
                          ),
                        ),
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

  Widget _buildCards(List<ServiceItem> items, int cols) {
    if (cols == 1) {
      return Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _ServiceCard(item: items[i]),
            if (i < items.length - 1) const SizedBox(height: 14),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += cols) {
      final slice = items.skip(i).take(cols).toList();
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int j = 0; j < cols; j++) ...[
                Expanded(child: j < slice.length ? _ServiceCard(item: slice[j]) : const SizedBox.shrink()),
                if (j < cols - 1) const SizedBox(width: 14),
              ],
            ],
          ),
        ),
      );
      if (i + cols < items.length) rows.add(const SizedBox(height: 14));
    }
    return Column(children: rows);
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item});
  final ServiceItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: item.accent.withOpacity(0.35)),
                  ),
                  child: Text(
                    item.badge,
                    style: TextStyle(color: item.accent, fontSize: 10.5, fontWeight: FontWeight.w700),
                  ),
                ),
                Icon(item.icon, color: item.accent, size: 22),
              ],
            ),
            const SizedBox(height: 12),
            Text(item.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(item.description, style: const TextStyle(color: Z2HColors.textSecondary, fontSize: 13.5, height: 1.5)),
            const SizedBox(height: 12),
            for (final h in item.highlights)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 16, color: Z2HColors.accentEmerald),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(h, style: const TextStyle(color: Z2HColors.textSecondary, fontSize: 12.8)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.tags
                  .map(
                    (t) => Chip(
                      label: Text(t, style: const TextStyle(fontSize: 11)),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
