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
  })  : assert(
          largeBreakpoint < double.infinity,
          'Breakpoints must be finite values.',
        ),
        assert(
          compactBreakpoint > 0,
          'Breakpoints must be greater than 0.',
        ),
        assert(
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
        ?.windowData;
  }

  /// Returns the nearest [ResponsiveWindowData] from the widget tree.
  ///
  /// Throws a [FlutterError] when no [ResponsiveWindow] exists above the given
  /// [context].
  static ResponsiveWindowData of(BuildContext context) {
    final ResponsiveWindowData? windowData = maybeOf(context);

    if (windowData == null) {
      throw FlutterError(
        'No ResponsiveWindow found in context.\n'
        'Make sure ResponsiveWindow is placed above your app root, usually '
        'wrapping MaterialApp, CupertinoApp, or WidgetsApp.',
      );
    }

    return windowData;
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
    required this.windowData,
    required super.child,
  });

  final ResponsiveWindowData windowData;

  @override
  bool updateShouldNotify(_ResponsiveWindowProvider oldWidget) {
    return windowData != oldWidget.windowData;
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
  })  : assert(
          largeBreakpoint < double.infinity,
          'Breakpoints must be finite values.',
        ),
        assert(
          compactBreakpoint > 0,
          'Breakpoints must be greater than 0.',
        ),
        assert(
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
        assert(
          constraints.hasBoundedWidth && constraints.hasBoundedHeight,
          'ResponsiveWindow cannot be placed where the available width or '
          'height is unbounded.',
        );

        return _ResponsiveWindowProvider(
          windowData: ResponsiveWindowData(
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

/// Resolves a value based on the current [ResponsiveWindowCategory].
///
/// The [compact] value is required and is used as the base fallback.
///
/// When the current category has no configured value, resolution falls back to
/// the nearest smaller configured category:
///
/// - compact uses [compact]
/// - medium uses [medium] or [compact]
/// - expanded uses [expanded], [medium], or [compact]
/// - large uses [large], [expanded], [medium], or [compact]
/// - extraLarge uses [extraLarge], [large], [expanded], [medium], or [compact]
@immutable
final class ResponsiveWindowValue<T> {
  /// Creates a responsive value resolver.
  const ResponsiveWindowValue({
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
  });

  /// The value used for compact widths.
  final T compact;

  /// The value used for medium widths.
  final T? medium;

  /// The value used for expanded widths.
  final T? expanded;

  /// The value used for large widths.
  final T? large;

  /// The value used for extra-large widths.
  final T? extraLarge;

  /// Resolves the value using the nearest [ResponsiveWindowData] in [context].
  T resolve(BuildContext context) {
    return resolveWith(ResponsiveWindowData.of(context));
  }

  /// Resolves the value using the given [ResponsiveWindowData].
  T resolveWith(ResponsiveWindowData windowData) {
    final _ResponsiveWindowValueEntry<T> entry = _resolveEntryWith(windowData);

    return entry.value;
  }

  _ResponsiveWindowValueEntry<T> _resolveEntryWith(
    ResponsiveWindowData windowData,
  ) {
    return switch (windowData.category) {
      ResponsiveWindowCategory.compact => _ResponsiveWindowValueEntry<T>(
          category: ResponsiveWindowCategory.compact,
          value: compact,
        ),
      ResponsiveWindowCategory.medium => _ResponsiveWindowValueEntry<T>(
          category: medium != null
              ? ResponsiveWindowCategory.medium
              : ResponsiveWindowCategory.compact,
          value: medium ?? compact,
        ),
      ResponsiveWindowCategory.expanded => _ResponsiveWindowValueEntry<T>(
          category: expanded != null
              ? ResponsiveWindowCategory.expanded
              : medium != null
                  ? ResponsiveWindowCategory.medium
                  : ResponsiveWindowCategory.compact,
          value: expanded ?? medium ?? compact,
        ),
      ResponsiveWindowCategory.large => _ResponsiveWindowValueEntry<T>(
          category: large != null
              ? ResponsiveWindowCategory.large
              : expanded != null
                  ? ResponsiveWindowCategory.expanded
                  : medium != null
                      ? ResponsiveWindowCategory.medium
                      : ResponsiveWindowCategory.compact,
          value: large ?? expanded ?? medium ?? compact,
        ),
      ResponsiveWindowCategory.extraLarge => _ResponsiveWindowValueEntry<T>(
          category: extraLarge != null
              ? ResponsiveWindowCategory.extraLarge
              : large != null
                  ? ResponsiveWindowCategory.large
                  : expanded != null
                      ? ResponsiveWindowCategory.expanded
                      : medium != null
                          ? ResponsiveWindowCategory.medium
                          : ResponsiveWindowCategory.compact,
          value: extraLarge ?? large ?? expanded ?? medium ?? compact,
        ),
    };
  }
}

final class _ResponsiveWindowValueEntry<T> {
  const _ResponsiveWindowValueEntry({
    required this.category,
    required this.value,
  });

  final ResponsiveWindowCategory category;
  final T value;
}

/// Builds a widget using the current [ResponsiveWindowData].
typedef ResponsiveWindowWidgetBuilder = Widget Function(
  BuildContext context,
  ResponsiveWindowData windowData,
);

/// Builds a responsive widget based on the current [ResponsiveWindowCategory].
///
/// The [compact] builder is required and is used as the base fallback.
///
/// Builders fall back from the current category to the nearest smaller
/// configured category, following the same behavior as [ResponsiveWindowValue].
class ResponsiveWindowBuilder extends StatelessWidget {
  /// The default transition duration used by [ResponsiveWindowBuilder.animated].
  static const Duration defaultTransitionDuration = Duration(milliseconds: 260);

  /// Creates a responsive widget builder without transitions.
  const ResponsiveWindowBuilder({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
  })  : _animated = false,
        _duration = null,
        _reverseDuration = null,
        _switchInCurve = Curves.linear,
        _switchOutCurve = Curves.linear,
        _transitionBuilder = null,
        _layoutBuilder = null;

  /// Creates a responsive widget builder with animated transitions.
  ///
  /// This uses [AnimatedSwitcher] internally. The transition runs only when the
  /// resolved responsive builder changes after applying fallback rules.
  ///
  /// Window size changes can still rebuild this widget, but they do not trigger
  /// an animated transition while the resolved builder remains the same.
  const ResponsiveWindowBuilder.animated({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
    Duration duration = ResponsiveWindowBuilder.defaultTransitionDuration,
    Duration? reverseDuration,
    Curve switchInCurve = Curves.easeOutCubic,
    Curve switchOutCurve = Curves.easeInCubic,
    AnimatedSwitcherTransitionBuilder transitionBuilder =
        AnimatedSwitcher.defaultTransitionBuilder,
    AnimatedSwitcherLayoutBuilder layoutBuilder =
        AnimatedSwitcher.defaultLayoutBuilder,
  })  : _animated = true,
        _duration = duration,
        _reverseDuration = reverseDuration,
        _switchInCurve = switchInCurve,
        _switchOutCurve = switchOutCurve,
        _transitionBuilder = transitionBuilder,
        _layoutBuilder = layoutBuilder;

  /// The builder used for compact widths.
  final ResponsiveWindowWidgetBuilder compact;

  /// The builder used for medium widths.
  final ResponsiveWindowWidgetBuilder? medium;

  /// The builder used for expanded widths.
  final ResponsiveWindowWidgetBuilder? expanded;

  /// The builder used for large widths.
  final ResponsiveWindowWidgetBuilder? large;

  /// The builder used for extra-large widths.
  final ResponsiveWindowWidgetBuilder? extraLarge;

  final bool _animated;
  final Duration? _duration;
  final Duration? _reverseDuration;
  final Curve _switchInCurve;
  final Curve _switchOutCurve;
  final AnimatedSwitcherTransitionBuilder? _transitionBuilder;
  final AnimatedSwitcherLayoutBuilder? _layoutBuilder;

  @override
  Widget build(BuildContext context) {
    final ResponsiveWindowData windowData = context.windowData;

    final _ResponsiveWindowValueEntry<ResponsiveWindowWidgetBuilder> entry =
        ResponsiveWindowValue<ResponsiveWindowWidgetBuilder>(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    )._resolveEntryWith(windowData);

    final Widget child = entry.value(context, windowData);

    if (!_animated) {
      return child;
    }

    return AnimatedSwitcher(
      duration: _duration!,
      reverseDuration: _reverseDuration,
      switchInCurve: _switchInCurve,
      switchOutCurve: _switchOutCurve,
      transitionBuilder: _transitionBuilder!,
      layoutBuilder: _layoutBuilder!,
      child: KeyedSubtree(
        key: ValueKey<ResponsiveWindowCategory>(entry.category),
        child: child,
      ),
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
