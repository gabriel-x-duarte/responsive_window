import 'package:flutter/widgets.dart';

/// Represents the responsive category for the available app window width.
///
/// This follows the compact, medium, expanded, large, and extra-large width
/// breakpoint names from Material Design 3.
///
/// It does not identify the physical device type. Device examples from Material
/// Design 3 are common examples for each width range, not runtime device
/// detection.
enum ResponsiveWindowCategory {
  /// Compact width.
  ///
  /// Represents widths under 600 logical pixels.
  /// Commonly associated with phones in portrait orientation.
  compact,

  /// Medium width.
  ///
  /// Represents widths from 600 to 839 logical pixels.
  /// Commonly associated with tablets in portrait orientation and unfolded
  /// foldables in portrait orientation.
  medium,

  /// Expanded width.
  ///
  /// Represents widths from 840 to 1199 logical pixels.
  /// Commonly associated with phones in landscape orientation, tablets in
  /// landscape orientation, unfolded foldables in landscape orientation, and
  /// desktop windows.
  expanded,

  /// Large width.
  ///
  /// Represents widths from 1200 to 1599 logical pixels.
  /// Commonly associated with desktop windows.
  large,

  /// Extra-large width.
  ///
  /// Represents widths of 1600 logical pixels and above.
  /// Commonly associated with desktop windows and ultra-wide monitors.
  extraLarge,
}

/// Immutable layout data for the current responsive app window scope.
@immutable
final class ResponsiveWindowData {
  /// Creates responsive layout data for the current app window scope.
  const ResponsiveWindowData({
    required this.width,
    required this.height,
    required this.compactBreakpoint,
    required this.mediumBreakpoint,
    required this.expandedBreakpoint,
    required this.largeBreakpoint,
  }) : assert(
          compactBreakpoint < mediumBreakpoint &&
              mediumBreakpoint < expandedBreakpoint &&
              expandedBreakpoint < largeBreakpoint,
          'Breakpoints must be ordered from smallest to largest.',
        );

  /// The maximum width available to the current app window scope.
  final double width;

  /// The maximum height available to the current app window scope.
  final double height;

  /// The upper width boundary for [ResponsiveWindowCategory.compact].
  ///
  /// Widths smaller than this value are classified as
  /// [ResponsiveWindowCategory.compact].
  final double compactBreakpoint;

  /// The upper width boundary for [ResponsiveWindowCategory.medium].
  ///
  /// Widths greater than or equal to [compactBreakpoint] and smaller than
  /// [mediumBreakpoint] are classified as [ResponsiveWindowCategory.medium].
  final double mediumBreakpoint;

  /// The upper width boundary for [ResponsiveWindowCategory.expanded].
  ///
  /// Widths greater than or equal to [mediumBreakpoint] and smaller than
  /// [expandedBreakpoint] are classified as [ResponsiveWindowCategory.expanded].
  final double expandedBreakpoint;

  /// The upper width boundary for [ResponsiveWindowCategory.large].
  ///
  /// Widths greater than or equal to [expandedBreakpoint] and smaller than
  /// [largeBreakpoint] are classified as [ResponsiveWindowCategory.large].
  /// Widths greater than or equal to [largeBreakpoint] are classified as
  /// [ResponsiveWindowCategory.extraLarge].
  final double largeBreakpoint;

  /// Returns the nearest [ResponsiveWindowData] from the widget tree, if any.
  ///
  /// This method establishes a dependency on the nearest [ResponsiveWindow].
  static ResponsiveWindowData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ResponsiveWindowProvider>()
        ?.data;
  }

  /// Returns the nearest [ResponsiveWindowData] from the widget tree.
  ///
  /// Throws a [FlutterError] when no [ResponsiveWindow] exists above the given
  /// [context].
  static ResponsiveWindowData of(BuildContext context) {
    final data = maybeOf(context);

    if (data == null) {
      throw FlutterError(
        'No ResponsiveWindow found in context.\n'
        'Make sure ResponsiveWindow is placed above your app root, usually '
        'wrapping MaterialApp, CupertinoApp, or WidgetsApp.',
      );
    }

    return data;
  }

  /// The current app window size as a Flutter [Size].
  Size get size => Size(width, height);

  /// Whether the current width is smaller than [compactBreakpoint].
  bool get isCompact => width < compactBreakpoint;

  /// Whether the current width is greater than or equal to [compactBreakpoint]
  /// and smaller than [mediumBreakpoint].
  bool get isMedium => width >= compactBreakpoint && width < mediumBreakpoint;

  /// Whether the current width is greater than or equal to [mediumBreakpoint]
  /// and smaller than [expandedBreakpoint].
  bool get isExpanded =>
      width >= mediumBreakpoint && width < expandedBreakpoint;

  /// Whether the current width is greater than or equal to [expandedBreakpoint]
  /// and smaller than [largeBreakpoint].
  bool get isLarge => width >= expandedBreakpoint && width < largeBreakpoint;

  /// Whether the current width is greater than or equal to [largeBreakpoint].
  bool get isExtraLarge => width >= largeBreakpoint;

  /// The responsive category for the current width.
  ResponsiveWindowCategory get category {
    if (isCompact) return ResponsiveWindowCategory.compact;
    if (isMedium) return ResponsiveWindowCategory.medium;
    if (isExpanded) return ResponsiveWindowCategory.expanded;
    if (isLarge) return ResponsiveWindowCategory.large;
    return ResponsiveWindowCategory.extraLarge;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveWindowData &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          compactBreakpoint == other.compactBreakpoint &&
          mediumBreakpoint == other.mediumBreakpoint &&
          expandedBreakpoint == other.expandedBreakpoint &&
          largeBreakpoint == other.largeBreakpoint;

  @override
  int get hashCode => Object.hash(
        width,
        height,
        compactBreakpoint,
        mediumBreakpoint,
        expandedBreakpoint,
        largeBreakpoint,
      );
}

class _ResponsiveWindowProvider extends InheritedWidget {
  const _ResponsiveWindowProvider({
    required this.data,
    required super.child,
  });

  final ResponsiveWindowData data;

  @override
  bool updateShouldNotify(_ResponsiveWindowProvider oldWidget) {
    return data != oldWidget.data;
  }
}

/// Provides responsive app window data to the widget subtree.
///
/// This widget is intended to wrap the root app widget, usually above
/// `MaterialApp`, `CupertinoApp`, or `WidgetsApp`.
///
/// It uses [LayoutBuilder], so it measures the available space from its parent
/// constraints. When placed at the root, this usually represents the current
/// Flutter app window size.
///
/// The default width breakpoints are inspired by Material Design 3:
///
/// - compact: widths under 600 logical pixels
/// - medium: widths from 600 to 839 logical pixels
/// - expanded: widths from 840 to 1199 logical pixels
/// - large: widths from 1200 to 1599 logical pixels
/// - extraLarge: widths from 1600 logical pixels and above
///
/// See [Material Design 3 breakpoints](https://m3.material.io/foundations/layout/breakpoints/overview).
///
/// This widget does not control the native platform window. For desktop apps,
/// use a dedicated window management package when you need to configure the
/// physical window size, minimum size, title, or position.
class ResponsiveWindow extends StatelessWidget {
  /// The default upper width boundary for compact layouts.
  ///
  /// Matches the Material Design 3 compact upper boundary of 600 logical pixels.
  static const double defaultCompactBreakpoint = 600.0;

  /// The default upper width boundary for medium layouts.
  ///
  /// Matches the Material Design 3 medium upper boundary of 840 logical pixels.
  static const double defaultMediumBreakpoint = 840.0;

  /// The default upper width boundary for expanded layouts.
  ///
  /// Matches the Material Design 3 expanded upper boundary of 1200 logical pixels.
  static const double defaultExpandedBreakpoint = 1200.0;

  /// The default upper width boundary for large layouts.
  ///
  /// Matches the Material Design 3 large upper boundary of 1600 logical pixels.
  static const double defaultLargeBreakpoint = 1600.0;

  /// Creates a responsive app window scope.
  const ResponsiveWindow({
    super.key,
    required this.child,
    this.compactBreakpoint = ResponsiveWindow.defaultCompactBreakpoint,
    this.mediumBreakpoint = ResponsiveWindow.defaultMediumBreakpoint,
    this.expandedBreakpoint = ResponsiveWindow.defaultExpandedBreakpoint,
    this.largeBreakpoint = ResponsiveWindow.defaultLargeBreakpoint,
  }) : assert(
          compactBreakpoint < mediumBreakpoint &&
              mediumBreakpoint < expandedBreakpoint &&
              expandedBreakpoint < largeBreakpoint,
          'Breakpoints must be ordered from smallest to largest.',
        );

  /// The child widget that receives access to [ResponsiveWindowData].
  ///
  /// This is typically a `MaterialApp`, `CupertinoApp`, or `WidgetsApp`.
  final Widget child;

  /// The upper width boundary for compact layouts.
  ///
  /// Widths smaller than this value are classified as compact.
  final double compactBreakpoint;

  /// The upper width boundary for medium layouts.
  ///
  /// Widths greater than or equal to [compactBreakpoint] and smaller than
  /// [mediumBreakpoint] are classified as medium.
  final double mediumBreakpoint;

  /// The upper width boundary for expanded layouts.
  ///
  /// Widths greater than or equal to [mediumBreakpoint] and smaller than
  /// [expandedBreakpoint] are classified as expanded.
  final double expandedBreakpoint;

  /// The upper width boundary for large layouts.
  ///
  /// Widths greater than or equal to [expandedBreakpoint] and smaller than
  /// [largeBreakpoint] are classified as large. Widths greater than or equal to
  /// [largeBreakpoint] are classified as extra-large.
  final double largeBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _ResponsiveWindowProvider(
          data: ResponsiveWindowData(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            compactBreakpoint: compactBreakpoint,
            mediumBreakpoint: mediumBreakpoint,
            expandedBreakpoint: expandedBreakpoint,
            largeBreakpoint: largeBreakpoint,
          ),
          child: child,
        );
      },
    );
  }
}

/// Convenience extension for accessing [ResponsiveWindowData] from a BuildContext.
extension BuildContextResponsiveWindow on BuildContext {
  /// Returns the nearest [ResponsiveWindowData].
  ///
  /// ```dart
  /// if (context.windowData.isCompact) {
  ///   // Build compact layout.
  /// }
  /// ```
  ResponsiveWindowData get windowData => ResponsiveWindowData.of(this);

  /// Returns the nearest [ResponsiveWindowData], if any.
  ResponsiveWindowData? get maybeWindowData =>
      ResponsiveWindowData.maybeOf(this);
}
