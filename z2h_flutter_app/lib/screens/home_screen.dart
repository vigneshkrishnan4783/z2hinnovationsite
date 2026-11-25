import 'package:flutter/material.dart';
import '../data/z2h_data.dart';
import '../theme/z2h_theme.dart';
import '../widgets/inquiry_dialog.dart';
import '../widgets/z2h_footer.dart';
import '../widgets/z2h_strategy_visual.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = classifyWidth(constraints.maxWidth);
        final isDesktop = sizeClass == ScreenSizeClass.desktop;
        final isCompact = sizeClass == ScreenSizeClass.smallPhone || sizeClass == ScreenSizeClass.mobile;
        final horizontalPad = isCompact ? 16.0 : 28.0;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: isCompact ? 24 : 44),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.7, -0.7),
                    radius: 1.2,
                    colors: [
                      Z2HColors.accentCyan.withOpacity(0.11),
                      Z2HColors.bgPrimary,
                    ],
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 6, child: _HeroCopy(onNavigate: onNavigate, isCompact: false)),
                              const SizedBox(width: 32),
                              const Expanded(flex: 5, child: Z2HStrategyVisual()),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _HeroCopy(onNavigate: onNavigate, isCompact: isCompact),
                              const SizedBox(height: 24),
                              const Z2HStrategyVisual(),
                            ],
                          ),
                  ),
                ),
              ),

              // Objectives Grid
              Container(
                color: Z2HColors.bgSecondary.withOpacity(0.55),
                padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionBadge(label: 'COMPANY OBJECTIVES'),
                        const SizedBox(height: 10),
                        Text(
                          'Built for Client Delivery, Engineered for Long-Term Value',
                          style: TextStyle(
                            fontSize: isCompact ? 22 : 30,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bridging agile IT consultancy, Flutter hybrid apps, enterprise backends, and deep learning R&D.',
                          style: TextStyle(color: Z2HColors.textSecondary, fontSize: 15),
                        ),
                        const SizedBox(height: 22),
                        _ResponsiveGrid(
                          maxWidth: constraints.maxWidth,
                          desktopColumns: 4,
                          tabletColumns: 2,
                          children: Z2HData.objectives
                              .map((obj) => _ObjectiveCard(item: obj))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Investor Thesis Banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Container(
                      padding: EdgeInsets.all(isCompact ? 20 : 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF11192E), Color(0xFF0B1120)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Z2HColors.accentCyan.withOpacity(0.32)),
                      ),
                      child: isDesktop
                          ? Row(
                              children: [
                                Expanded(flex: 6, child: _InvestorCopy(onNavigate: onNavigate)),
                                const SizedBox(width: 28),
                                const Expanded(flex: 5, child: _InvestorPillars()),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _InvestorCopy(onNavigate: onNavigate),
                                const SizedBox(height: 20),
                                const _InvestorPillars(),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              Z2HFooter(onNavigate: onNavigate),
            ],
          ),
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onNavigate, required this.isCompact});

  final ValueChanged<int> onNavigate;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionBadge(label: 'Z2H INNOVATIONS & R&D LAB • 2026', showDot: true),
        const SizedBox(height: 14),
        Text(
          Z2HData.heroHeadline,
          style: TextStyle(
            fontSize: isCompact ? 27 : 40,
            fontWeight: FontWeight.w800,
            height: 1.12,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          Z2HData.heroDescription,
          style: TextStyle(color: Z2HColors.textSecondary, fontSize: 15.5, height: 1.55),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () => onNavigate(1),
              icon: const Icon(Icons.layers_rounded, size: 18),
              label: const Text('Explore Capabilities'),
            ),
          ],
        ),
        const SizedBox(height: 22),
        const Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _MetricTile(value: '4-in-1', label: 'iPhone, Android, Web & Desktop'),
            _MetricTile(value: '2x Model', label: 'Services + R&D Delivery'),
            _MetricTile(value: '24/7', label: 'Cloud & AI Support'),
          ],
        ),
      ],
    );
  }
}

class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({required this.item});
  final ObjectiveItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Z2HColors.accentCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: Z2HColors.accentCyan, size: 22),
            ),
            const SizedBox(height: 14),
            Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            Text(item.description, style: const TextStyle(color: Z2HColors.textSecondary, fontSize: 13.5, height: 1.5)),
            const SizedBox(height: 12),
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

class _InvestorCopy extends StatelessWidget {
  const _InvestorCopy({required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionBadge(label: 'WHY Z2H R&D LAB • 2026'),
        const SizedBox(height: 10),
        const Text(
          'From Concept to Production Across Every Screen',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, height: 1.2),
        ),
        const SizedBox(height: 10),
        const Text(
          'Headquartered at Kuruvankonam, Kowdiar, Z2H combines AI solution development, freelance software squads, backend APIs, and IT consulting into one fast, reliable delivery engine.',
          style: TextStyle(color: Z2HColors.textSecondary, fontSize: 14.5, height: 1.55),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () => showZ2HInquiryDialog(
                context,
                title: 'Start a Project With Z2H',
                subtitle: 'Share your project goals with our engineering team.',
              ),
              icon: const Icon(Icons.rocket_launch_rounded, size: 18),
              label: const Text('Start a Project'),
            ),
            OutlinedButton(
              onPressed: () => onNavigate(1),
              child: const Text('View Services'),
            ),
          ],
        ),
      ],
    );
  }
}

class _InvestorPillars extends StatelessWidget {
  const _InvestorPillars();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _PillarCard(
          title: '1. Reliable Delivery & Architecture',
          body: 'IT consultancy, hybrid apps, and backend APIs built for long-term stability and scale.',
        ),
        SizedBox(height: 10),
        _PillarCard(
          title: '2. Reusable AI & Flutter Accelerators',
          body: 'Modular LLM toolkits and responsive Flutter UI systems speed up delivery across every release.',
        ),
        SizedBox(height: 10),
        _PillarCard(
          title: '3. Kerala Deep-Tech Hub Advantage',
          body: 'Headquartered in Kuruvankonam, Kowdiar, combining top engineering talent with global delivery standards.',
        ),
      ],
    );
  }
}

class _PillarCard extends StatelessWidget {
  const _PillarCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Z2HColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(color: Z2HColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: Z2HColors.textMuted, fontSize: 12)),
      ],
    );
  }
}

class _SectionBadge extends StatelessWidget {
  const _SectionBadge({required this.label, this.showDot = false});
  final String label;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Z2HColors.accentCyan.withOpacity(0.08),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Z2HColors.accentCyan.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(color: Z2HColors.accentEmerald, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Z2HColors.accentCyan,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({
    required this.maxWidth,
    required this.desktopColumns,
    required this.tabletColumns,
    required this.children,
  });

  final double maxWidth;
  final int desktopColumns;
  final int tabletColumns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final sizeClass = classifyWidth(maxWidth);
    final cols = switch (sizeClass) {
      ScreenSizeClass.desktop => desktopColumns,
      ScreenSizeClass.tablet => tabletColumns,
      ScreenSizeClass.mobile || ScreenSizeClass.smallPhone => 1,
    };

    if (cols == 1) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const SizedBox(height: 14),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < children.length; i += cols) {
      final slice = children.skip(i).take(cols).toList();
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int j = 0; j < cols; j++) ...[
                Expanded(child: j < slice.length ? slice[j] : const SizedBox.shrink()),
                if (j < cols - 1) const SizedBox(width: 14),
              ],
            ],
          ),
        ),
      );
      if (i + cols < children.length) rows.add(const SizedBox(height: 14));
    }
    return Column(children: rows);
  }
}
