A lightweight app-level utility for reading the current Flutter app window size
from anywhere in the widget tree.

Use it to make simple and predictable layout decisions based on window size or
responsive width breakpoints, without scaling widgets or detecting physical
device types.

## Features

- App-level responsive window scope for Flutter apps
- Material Design 3-inspired width breakpoints
- Supports `compact`, `medium`, `expanded`, `large`, and `extraLarge`
- Access responsive window data from `BuildContext`
- Provides responsive window category and boolean helpers
- Provides window width, height, and Flutter `Size`
- Customizable breakpoints
- Uses Flutter widgets only, with no dependency on Material widgets
- Does not control native desktop windows

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
- `windowData.category`
- `windowData.size`
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

## Native Windows

`ResponsiveWindow` does not control the native platform window.

It only measures the available Flutter layout constraints and provides
responsive window data to the widget subtree.

For desktop apps, use a dedicated window management package when you need to
configure the physical window size, minimum size, title, or position.

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
