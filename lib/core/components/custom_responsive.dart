import 'package:flutter/material.dart';

class CustomResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const CustomResponsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 800;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 800;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100 && MediaQuery.of(context).size.width < 1600;

  static bool isUltraWideDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1600;

  static bool isDesktopOrUltra(BuildContext context) => isDesktop(context) || isUltraWideDesktop(context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // * If our width is more than 1100 then we consider it a desktop
        if (width >= 1100) {
          return desktop;
        }
        // * If width it less then 1100 and more then 850 we consider it as tablet
        else if (width >= 800) {
          return tablet ?? desktop;
        }
        // * Or less then that we called it mobile
        else {
          return mobile;
        }
      },
    );
  }
}
