An app-level utility for reading the current Flutter app window size
from anywhere in the widget tree.

Use it to make simple and predictable layout decisions based on window size or
responsive width breakpoints, without scaling widgets or detecting physical
device types.

## Features

- App-level responsive window scope for Flutter apps
- Material Design 3-inspired width breakpoints
- Supports `compact`, `medium`, `expanded`, `large`, and `extraLarge`
- Access responsive window data from `BuildContext`
- Provides window `width`, `height`, Flutter `Size`, `category`, and boolean helpers
- Provides breakpoint configuration through `ResponsiveWindowBreakpoints`
- Resolves responsive values with breakpoint fallbacks
- Compares responsive categories with `isAtLeast` and `isAtMost`
- Builds responsive widgets with optional animated transitions
- Uses Flutter widgets only, with no dependency on Material widgets
- Does not configure native desktop windows

## Default Breakpoints

`ResponsiveWindow` uses Material Design 3-inspired width breakpoints by default.

The responsive category is based on the available window width. It does not
detect the physical device type.

A desktop window resized to a narrow width can be classified as `compact`.
A wide tablet or desktop window can be classified as `expanded`, `large`, or
`extraLarge`.

| Category | Width |
|---|---:|
| `compact` | `< 600` |
| `medium` | `>= 600 && < 840` |
| `expanded` | `>= 840 && < 1200` |
| `large` | `>= 1200 && < 1600` |
| `extraLarge` | `>= 1600` |

The default values are also available as
`ResponsiveWindowBreakpoints.material3` when you want to pass them explicitly.

Reference: [Material Design 3 breakpoints](https://m3.material.io/foundations/layout/breakpoints/overview).

## Usage

#### Wrap your app

Place `ResponsiveWindow` above your root app widget.

```dart
import 'package:flutter/material.dart';
import 'package:responsive_window/responsive_window.dart';

void main() {
  runApp(
    const ResponsiveWindow(
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
```

`ResponsiveWindow` should usually wrap `MaterialApp`, `CupertinoApp`, or
`WidgetsApp`.

#### Read window data

Use `context.windowData` to read the current responsive window data.

```dart
import 'package:flutter/widgets.dart';
import 'package:responsive_window/responsive_window.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveWindowData windowData = context.windowData;

    if (windowData.isCompact) {
      return const CompactLayout();
    }

    if (windowData.isMedium) {
      return const MediumLayout();
    }

    if (windowData.isExpanded) {
      return const ExpandedLayout();
    }

    if (windowData.isLarge) {
      return const LargeLayout();
    }

    return const ExtraLargeLayout();
  }
}
```

Available properties and helpers:

- `windowData.width`
- `windowData.height`
- `windowData.size`
- `windowData.breakpoints`
- `windowData.category`
- `windowData.isCompact`
- `windowData.isMedium`
- `windowData.isExpanded`
- `windowData.isLarge`
- `windowData.isExtraLarge`
- `windowData.isAtLeast(category)`
- `windowData.isAtMost(category)`

`windowData.size` returns the current app window dimensions as a Flutter `Size`.

For convenience, `ResponsiveWindowData` also exposes the configured breakpoint
boundaries through `compactBreakpoint`, `mediumBreakpoint`,
`expandedBreakpoint`, and `largeBreakpoint`.

#### Use the responsive category

`windowData.category` returns the current responsive category as a
`ResponsiveWindowCategory`.

```dart
Widget build(BuildContext context) {
  final ResponsiveWindowData windowData = context.windowData;

  switch (windowData.category) {
    case ResponsiveWindowCategory.compact:
      return const CompactLayout();

    case ResponsiveWindowCategory.medium:
      return const MediumLayout();

    case ResponsiveWindowCategory.expanded:
      return const ExpandedLayout();

    case ResponsiveWindowCategory.large:
      return const LargeLayout();

    case ResponsiveWindowCategory.extraLarge:
      return const ExtraLargeLayout();
  }
}
```

#### Resolve responsive values

Use `ResponsiveWindowValue` to choose a value based on the current responsive
category.

This is useful when layout values should react to the current window size, such
as padding, spacing, column count, or maximum content width.

```dart
Widget build(BuildContext context) {
  final double padding = const ResponsiveWindowValue<double>(
    compact: 16,
    expanded: 24,
    large: 32,
  ).resolve(context);

  final int columns = const ResponsiveWindowValue<int>(
    compact: 1,
    medium: 2,
    large: 4,
  ).resolve(context);

  return Padding(
    padding: EdgeInsets.all(padding),
    child: ProductGrid(columns: columns),
  );
}
```

`compact` is required and works as the base fallback.

Values fall back from the current category to the nearest smaller configured
category:

- `compact` uses `compact`
- `medium` uses `medium` or `compact`
- `expanded` uses `expanded`, `medium`, or `compact`
- `large` uses `large`, `expanded`, `medium`, or `compact`
- `extraLarge` uses `extraLarge`, `large`, `expanded`, `medium`, or `compact`

If you already have a `ResponsiveWindowData` instance, you can resolve directly
from it:

```dart
final ResponsiveWindowData windowData = context.windowData;

final double padding = const ResponsiveWindowValue<double>(
  compact: 16,
  expanded: 24,
).resolveWith(windowData);
```

You can also use `ResponsiveWindowValue<Widget>` when you need to switch
between widgets.

```dart
Widget build(BuildContext context) {
  final Widget navigation = const ResponsiveWindowValue<Widget>(
    compact: AppBottomNavigation(),
    expanded: AppNavigationRail(),
  ).resolve(context);

  return Scaffold(
    body: ContentWithNavigation(
      navigation: navigation,
    ),
  );
}
```

For small local widget choices, `ResponsiveWindowValue<Widget>` is usually
enough. For larger layout changes, prefer `ResponsiveWindowBuilder`.

#### Compare responsive categories

Use `isAtLeast` and `isAtMost` for simple boolean decisions based on the
responsive category order.

These helpers are useful when a behavior should apply to a range of categories
and you would otherwise need to combine multiple boolean helpers in one
condition.

Use `isAtLeast` when a behavior should apply from a category upward.

Instead of writing:

```dart
final bool showSidebar =
    windowData.isExpanded || windowData.isLarge || windowData.isExtraLarge;
```

You can write:

```dart
final bool showSidebar = windowData.isAtLeast(
  ResponsiveWindowCategory.expanded,
);
```

For example, show a sidebar on `expanded`, `large`, and `extraLarge` widths:

```dart
Widget build(BuildContext context) {
  final ResponsiveWindowData windowData = context.windowData;

  final bool showSidebar = windowData.isAtLeast(
    ResponsiveWindowCategory.expanded,
  );

  return Row(
    children: [
      if (showSidebar) const Sidebar(),
      const Expanded(child: Content()),
    ],
  );
}
```

Use `isAtMost` when a behavior should apply up to a category.

Instead of writing:

```dart
final bool useCompactControls = windowData.isCompact || windowData.isMedium;
```

You can write:

```dart
final bool useCompactControls = windowData.isAtMost(
  ResponsiveWindowCategory.medium,
);
```

For example, use compact controls on `compact` and `medium` widths:

```dart
Widget build(BuildContext context) {
  final ResponsiveWindowData windowData = context.windowData;

  final bool useCompactControls = windowData.isAtMost(
    ResponsiveWindowCategory.medium,
  );

  return Toolbar(
    compact: useCompactControls,
  );
}
```

For simple yes/no decisions, prefer `isAtLeast` or `isAtMost`. For choosing
different values by category, use `ResponsiveWindowValue`.

#### Build responsive widgets

Use `ResponsiveWindowBuilder` when the widget tree should change based on the
current responsive category.

```dart
ResponsiveWindowBuilder(
  compact: (context, windowData) {
    return const CompactLayout();
  },
  expanded: (context, windowData) {
    return const ExpandedLayout();
  },
)
```

`compact` is required and works as the base fallback.

Builders follow the same fallback rule as `ResponsiveWindowValue`. If the
current category does not define a builder, `ResponsiveWindowBuilder` uses the
nearest smaller configured builder.

In the example above, `medium` uses the `compact` builder, while `large` and
`extraLarge` use the `expanded` builder.

Use `ResponsiveWindowBuilder` instead of `ResponsiveWindowValue<Widget>` when
the responsive change affects a larger widget tree, needs access to
`ResponsiveWindowData` inside the builder, or is easier to read as separate
layout branches.

#### Build responsive widgets with animation

Use `ResponsiveWindowBuilder.animated` when switching between responsive layouts
should be animated.

The default transition duration is 220 milliseconds.

```dart
ResponsiveWindowBuilder.animated(
  compact: (context, windowData) {
    return const CompactLayout();
  },
  medium: (context, windowData) {
    return const MediumLayout();
  },
  large: (context, windowData) {
    return const LargeLayout();
  },
)
```

Animated transitions run only when the resolved responsive builder changes after
applying fallback rules.

For example, if `expanded` falls back to `medium`, resizing between `medium` and
`expanded` does not trigger a layout transition because the resolved builder is
the same.

You can customize the animation:

```dart
ResponsiveWindowBuilder.animated(
  duration: const Duration(milliseconds: 300),
  switchInCurve: Curves.easeOutCubic,
  switchOutCurve: Curves.easeInCubic,
  transitionBuilder: (child, animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
  compact: (context, windowData) {
    return const CompactLayout();
  },
  expanded: (context, windowData) {
    return const ExpandedLayout();
  },
)
```

#### Custom breakpoints

You can customize the width `breakpoints` when wrapping your app.

```dart
const ResponsiveWindow(
  breakpoints: ResponsiveWindowBreakpoints(
    compact: 640,
    medium: 900,
    expanded: 1280,
    large: 1680,
  ),
  child: App(),
)
```

Breakpoints must be finite values greater than 0 and ordered from smallest to
largest.

The values represent upper width boundaries. For example, with `compact: 640`,
widths smaller than `640` are classified as `compact`.

## Advanced Scope Usage

The primary and recommended usage is to place `ResponsiveWindow` at the app
level, above `MaterialApp`, `CupertinoApp`, or `WidgetsApp`.

`ResponsiveWindow` uses Flutter's `LayoutBuilder`, so it reads the layout
constraints provided by its parent.

In most apps, the app-level `ResponsiveWindow` is all you need.

In advanced cases, you can place another `ResponsiveWindow` inside a specific
subtree. This is only useful when that subtree is laid out with bounded width
and height constraints that are different from the full app window.

If the local subtree receives the same width and height constraints as the app
window, the extra `ResponsiveWindow` is unnecessary.

`ResponsiveWindow` cannot be placed inside a subtree where the available width
or height constraints are unbounded.

When multiple `ResponsiveWindow` widgets exist in the widget tree,
`context.windowData` reads from the nearest one.

## Native Windows

`ResponsiveWindow` does not manage native desktop window behavior.

It only reads the available Flutter layout constraints and provides responsive
window data to the widget subtree.

For desktop apps, use a dedicated window management package when you need to
configure the native window size, minimum size, title, or position.

## Extension Conflicts

This package exposes a `BuildContext` extension that enables:

```dart
final ResponsiveWindowData windowData = context.windowData;
```

If another imported extension also exposes a `windowData` getter on
`BuildContext`, calling `context.windowData` may become ambiguous in that file.

In that case, hide this package extension from the import:

```dart
import 'package:responsive_window/responsive_window.dart'
    hide BuildContextResponsiveWindow;
```

Then use the core API directly:

```dart
final ResponsiveWindowData windowData = ResponsiveWindowData.of(context);
```

## Additional Information

Issues and feature requests can be reported on GitHub.

Contributions are welcome.

If you find this package useful,
please consider giving it a like.
