import 'package:flutter/material.dart';
import '../data/z2h_data.dart';
import '../theme/z2h_theme.dart';
import 'z2h_logo.dart';

class Z2HFooter extends StatelessWidget {
  const Z2HFooter({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF04070F),
        border: Border(top: BorderSide(color: Z2HColors.borderSubtle)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 680;
              final brandCol = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Z2HBrandLockup(),
                  const SizedBox(height: 12),
                  Text(
                    'Building resilient hybrid applications, scalable backend systems, and applied deep learning solutions for global partners.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Z2HColors.textMuted,
                          height: 1.5,
                        ),
                  ),
                ],
              );

              final addressCol = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'R&D Lab Headquarters',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  for (final line in Z2HData.addressLines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        line,
                        style: const TextStyle(color: Z2HColors.textMuted, fontSize: 13.5),
                      ),
                    ),
                ],
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isNarrow)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        brandCol,
                        const SizedBox(height: 20),
                        addressCol,
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: brandCol),
                        const SizedBox(width: 36),
                        Expanded(flex: 2, child: addressCol),
                      ],
                    ),
                  const SizedBox(height: 24),
                  const Divider(color: Z2HColors.borderSubtle),
                  const SizedBox(height: 12),
                  const Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 8,
                    spacing: 16,
                    children: [
                      Text(
                        '© 2026 Z2H Innovations & R&D Lab. All rights reserved.',
                        style: TextStyle(color: Z2HColors.textMuted, fontSize: 12.5),
                      ),
                      Text(
                        Z2HData.poweredBy,
                        style: TextStyle(
                          color: Z2HColors.accentCyan,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
