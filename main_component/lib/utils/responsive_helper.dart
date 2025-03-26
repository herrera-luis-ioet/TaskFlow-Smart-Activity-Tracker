import 'package:flutter/material.dart';

/// Utility class for handling responsive design
class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  /// Returns true if the screen width is less than [mobileBreakpoint]
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  /// Returns true if the screen width is between [mobileBreakpoint] and [tabletBreakpoint]
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  /// Returns true if the screen width is greater than or equal to [tabletBreakpoint]
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  /// Returns the current device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    if (isMobile(context)) return DeviceType.mobile;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Returns true if the device is in landscape orientation
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Returns the screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Returns the screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Returns a responsive value based on screen width
  static double responsiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Returns a responsive padding based on screen width
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.all(responsiveValue(
      context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    ));
  }
}

/// Enum representing different device types
enum DeviceType { mobile, tablet, desktop }
