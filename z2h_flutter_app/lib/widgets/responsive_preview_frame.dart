import 'package:flutter/material.dart';
import '../theme/z2h_theme.dart';

enum DevicePreset {
  auto('Auto (Live)', null),
  iphone('iPhone (390×844)', Size(390, 844)),
  mobile('Mobile (412×860)', Size(412, 860)),
  tablet('Tablet (820×920)', Size(820, 920)),
  desktop('Desktop (1280×860)', Size(1280, 860));

  const DevicePreset(this.label, this.size);
  final String label;
  final Size? size;
}

class ResponsivePreviewFrame extends StatelessWidget {
  const ResponsivePreviewFrame({
    super.key,
    required this.preset,
    required this.child,
  });

  final DevicePreset preset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final targetSize = preset.size;
    if (targetSize == null) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableW = constraints.maxWidth - 24;
        final availableH = constraints.maxHeight - 24;
        final width = targetSize.width.clamp(280.0, availableW > 280 ? availableW : 280.0);
        final height = targetSize.height.clamp(420.0, availableH > 420 ? availableH : 420.0);
        final isPhone = preset == DevicePreset.iphone || preset == DevicePreset.mobile;

        return Container(
          color: const Color(0xFF03050B),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Z2HColors.bgPrimary,
              borderRadius: BorderRadius.circular(isPhone ? 34 : 20),
              border: Border.all(
                color: Z2HColors.accentCyan.withOpacity(0.45),
                width: isPhone ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Z2HColors.accentCyan.withOpacity(0.14),
                  blurRadius: 36,
                  spreadRadius: 2,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                size: Size(width, height),
                padding: isPhone
                    ? const EdgeInsets.only(top: 18, bottom: 14)
                    : EdgeInsets.zero,
              ),
              child: Column(
                children: [
                  if (isPhone)
                    Container(
                      height: 22,
                      color: Z2HColors.bgSecondary,
                      alignment: Alignment.center,
                      child: Container(
                        width: 72,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
