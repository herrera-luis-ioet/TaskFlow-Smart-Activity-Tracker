import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// A widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (ResponsiveHelper.isTablet(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}

/// A widget that builds different layouts based on orientation
class OrientationBuilder extends StatelessWidget {
  final Widget portrait;
  final Widget? landscape;

  const OrientationBuilder({
    super.key,
    required this.portrait,
    this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isLandscape(context)
        ? landscape ?? portrait
        : portrait;
  }
}
