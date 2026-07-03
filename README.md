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
- Provides window width, height, Flutter `Size`, category, and boolean helpers
- Customizable breakpoints
- Uses Flutter widgets only, with no dependency on Material widgets
- Does not configure native desktop windows

## Default Breakpoints

`ResponsiveWindow` uses Material Design 3-inspired width breakpoints by default.

The responsive category is based on the available app window width. It does not
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
- `windowData.category`
- `windowData.isCompact`
- `windowData.isMedium`
- `windowData.isExpanded`
- `windowData.isLarge`
- `windowData.isExtraLarge`

`windowData.size` returns the current app window dimensions as a Flutter `Size`.

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

#### Custom breakpoints

You can customize the width breakpoints when wrapping your app.

```dart
const ResponsiveWindow(
  compactBreakpoint: 640,
  mediumBreakpoint: 900,
  expandedBreakpoint: 1280,
  largeBreakpoint: 1680,
  child: App(),
)
```

Breakpoints must be ordered from smallest to largest.

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

A local `ResponsiveWindow` is not suitable for subtrees with unbounded width or
height constraints.

When multiple `ResponsiveWindow` widgets exist in the widget tree,
`context.windowData` reads from the nearest one.

## Native Windows

`ResponsiveWindow` does not manage native desktop window behavior.

It only measures the available Flutter layout constraints and provides
responsive window data to the widget subtree.

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
