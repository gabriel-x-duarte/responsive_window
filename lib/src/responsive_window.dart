import 'package:flutter/widgets.dart';

/// Represents the responsive category for the available window width.
///
/// This follows the compact, medium, expanded, large, and extra-large width
/// breakpoint names from Material Design 3.
///
/// It does not identify the physical device type. Device examples from Material
/// Design 3 are common examples for each width range, not runtime device
/// detection.
///
/// The width ranges documented for each value refer to the default
/// [ResponsiveWindowBreakpoints.material3] breakpoints. Custom breakpoints can
/// change the actual width range represented by each category.
enum ResponsiveWindowCategory {
  /// Compact width.
  ///
  /// With the default breakpoints, represents widths under 600 logical pixels.
  /// Commonly associated with phones in portrait orientation.
  compact,

  /// Medium width.
  ///
  /// With the default breakpoints, represents widths from 600 to below 840
  /// logical pixels. Commonly associated with tablets in portrait orientation
  /// and unfolded foldables in portrait orientation.
  medium,

  /// Expanded width.
  ///
  /// With the default breakpoints, represents widths from 840 to below 1200
  /// logical pixels. Commonly associated with phones in landscape orientation,
  /// tablets in landscape orientation, unfolded foldables in landscape
  /// orientation, and desktop windows.
  expanded,

  /// Large width.
  ///
  /// With the default breakpoints, represents widths from 1200 to below 1600
  /// logical pixels. Commonly associated with desktop windows.
  large,

  /// Extra-large width.
  ///
  /// With the default breakpoints, represents widths of 1600 logical pixels and
  /// above. Commonly associated with desktop windows and ultra-wide monitors.
  extraLarge,
}

/// Represents the geometric aspect of the current responsive window scope.
///
/// This is based only on the current [ResponsiveWindowData.width] and
/// [ResponsiveWindowData.height]. It does not identify the physical device
/// orientation.
enum ResponsiveWindowAspect {
  /// Indicates that the current width is greater than the current height.
  landscape,

  /// Indicates that the current height is greater than the current width.
  portrait,

  /// Indicates that the current width and height are equal.
  square,
}

/// Width breakpoints used to classify the available responsive app window size.
@immutable
final class ResponsiveWindowBreakpoints {
  /// Creates width breakpoints for responsive category classification.
  const ResponsiveWindowBreakpoints({
    required this.compact,
    required this.medium,
    required this.expanded,
    required this.large,
  })  : assert(
          large < double.infinity,
          'Breakpoints must be finite values.',
        ),
        assert(
          compact > 0,
          'Breakpoints must be greater than 0.',
        ),
        assert(
          compact < medium && medium < expanded && expanded < large,
          'Breakpoints must be ordered from smallest to largest.',
        );

  /// Material Design 3-inspired default width breakpoints.
  static const ResponsiveWindowBreakpoints material3 =
      ResponsiveWindowBreakpoints(
    compact: 600,
    medium: 840,
    expanded: 1200,
    large: 1600,
  );

  /// The upper width boundary for [ResponsiveWindowCategory.compact].
  ///
  /// Widths smaller than this value are classified as
  /// [ResponsiveWindowCategory.compact].
  final double compact;

  /// The upper width boundary for [ResponsiveWindowCategory.medium].
  ///
  /// Widths greater than or equal to [compact] and smaller than [medium] are
  /// classified as [ResponsiveWindowCategory.medium].
  final double medium;

  /// The upper width boundary for [ResponsiveWindowCategory.expanded].
  ///
  /// Widths greater than or equal to [medium] and smaller than [expanded] are
  /// classified as [ResponsiveWindowCategory.expanded].
  final double expanded;

  /// The upper width boundary for [ResponsiveWindowCategory.large].
  ///
  /// Widths greater than or equal to [expanded] and smaller than [large] are
  /// classified as [ResponsiveWindowCategory.large]. Widths greater than or
  /// equal to [large] are classified as [ResponsiveWindowCategory.extraLarge].
  final double large;

  /// Returns the responsive category for the given [width].
  ResponsiveWindowCategory categoryForWidth(double width) {
    if (width < compact) return ResponsiveWindowCategory.compact;
    if (width < medium) return ResponsiveWindowCategory.medium;
    if (width < expanded) return ResponsiveWindowCategory.expanded;
    if (width < large) return ResponsiveWindowCategory.large;
    return ResponsiveWindowCategory.extraLarge;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveWindowBreakpoints &&
          runtimeType == other.runtimeType &&
          compact == other.compact &&
          medium == other.medium &&
          expanded == other.expanded &&
          large == other.large;

  @override
  int get hashCode => Object.hash(
        compact,
        medium,
        expanded,
        large,
      );

  @override
  String toString() {
    return 'ResponsiveWindowBreakpoints('
        'compact: $compact, '
        'medium: $medium, '
        'expanded: $expanded, '
        'large: $large'
        ')';
  }
}

/// Immutable layout data for the current responsive window scope.
@immutable
final class ResponsiveWindowData {
  /// Creates responsive layout data for the current window scope.
  const ResponsiveWindowData({
    required this.width,
    required this.height,
    required this.breakpoints,
  });

  /// The maximum width available to the current window scope.
  final double width;

  /// The maximum height available to the current window scope.
  final double height;

  /// The breakpoints used to classify the current available width.
  final ResponsiveWindowBreakpoints breakpoints;

  /// The upper width boundary for [ResponsiveWindowCategory.compact].
  ///
  /// Widths smaller than this value are classified as
  /// [ResponsiveWindowCategory.compact].
  double get compactBreakpoint => breakpoints.compact;

  /// The upper width boundary for [ResponsiveWindowCategory.medium].
  ///
  /// Widths greater than or equal to [compactBreakpoint] and smaller than
  /// [mediumBreakpoint] are classified as [ResponsiveWindowCategory.medium].
  double get mediumBreakpoint => breakpoints.medium;

  /// The upper width boundary for [ResponsiveWindowCategory.expanded].
  ///
  /// Widths greater than or equal to [mediumBreakpoint] and smaller than
  /// [expandedBreakpoint] are classified as [ResponsiveWindowCategory.expanded].
  double get expandedBreakpoint => breakpoints.expanded;

  /// The upper width boundary for [ResponsiveWindowCategory.large].
  ///
  /// Widths greater than or equal to [expandedBreakpoint] and smaller than
  /// [largeBreakpoint] are classified as [ResponsiveWindowCategory.large].
  /// Widths greater than or equal to [largeBreakpoint] are classified as
  /// [ResponsiveWindowCategory.extraLarge].
  double get largeBreakpoint => breakpoints.large;

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

  /// The current window scope size as a Flutter [Size].
  Size get size => Size(width, height);

  /// The geometric aspect of the current responsive window scope.
  ///
  /// This is based on the current [width] and [height]. It does not identify the
  /// physical device orientation.
  ResponsiveWindowAspect get aspect {
    if (width > height) return ResponsiveWindowAspect.landscape;
    if (height > width) return ResponsiveWindowAspect.portrait;
    return ResponsiveWindowAspect.square;
  }

  /// Whether the current width is greater than the current height.
  bool get isLandscape => aspect == ResponsiveWindowAspect.landscape;

  /// Whether the current height is greater than the current width.
  bool get isPortrait => aspect == ResponsiveWindowAspect.portrait;

  /// Whether the current width and height are equal.
  bool get isSquare => aspect == ResponsiveWindowAspect.square;

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
    return breakpoints.categoryForWidth(width);
  }

  /// The ordinal position of the current category.
  ///
  /// [ResponsiveWindowCategory] values are declared from the smallest width
  /// category to the largest one. Their enum indexes represent that responsive
  /// order.
  int get _categoryIndex => category.index;

  /// Whether the current category is equal to or larger than [minimumCategory].
  bool isAtLeast(ResponsiveWindowCategory minimumCategory) {
    return _categoryIndex >= minimumCategory.index;
  }

  /// Whether the current category is equal to or smaller than [maximumCategory].
  bool isAtMost(ResponsiveWindowCategory maximumCategory) {
    return _categoryIndex <= maximumCategory.index;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveWindowData &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          breakpoints == other.breakpoints;

  @override
  int get hashCode => Object.hash(
        width,
        height,
        breakpoints,
      );

  @override
  String toString() {
    return 'ResponsiveWindowData('
        'width: $width, '
        'height: $height, '
        'category: $category, '
        'aspect: $aspect, '
        'breakpoints: $breakpoints'
        ')';
  }
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
/// It uses [LayoutBuilder], so it reads the layout constraints provided by its
/// parent. When placed at the root, this usually represents the current Flutter
/// app window size.
///
/// The default width breakpoints are defined by
/// [ResponsiveWindowBreakpoints.material3]:
///
/// - compact: widths under 600 logical pixels
/// - medium: widths from 600 to below 840 logical pixels
/// - expanded: widths from 840 to below 1200 logical pixels
/// - large: widths from 1200 to below 1600 logical pixels
/// - extraLarge: widths from 1600 logical pixels and above
///
/// See [Material Design 3 breakpoints](https://m3.material.io/foundations/layout/breakpoints/overview).
///
/// This widget does not control the native platform window. For desktop apps,
/// use a dedicated window management package when you need to configure the
/// physical window size, minimum size, title, or position.
class ResponsiveWindow extends StatelessWidget {
  /// Creates a responsive app window scope.
  const ResponsiveWindow({
    super.key,
    required this.child,
    this.breakpoints = ResponsiveWindowBreakpoints.material3,
  });

  /// The child widget that receives access to [ResponsiveWindowData].
  ///
  /// This is typically a `MaterialApp`, `CupertinoApp`, or `WidgetsApp`.
  final Widget child;

  /// The width breakpoints used to classify the available window width.
  final ResponsiveWindowBreakpoints breakpoints;

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
            breakpoints: breakpoints,
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
  static const Duration defaultTransitionDuration = Duration(milliseconds: 220);

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

/// Convenience extension for accessing [ResponsiveWindowData] from a [BuildContext].
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
