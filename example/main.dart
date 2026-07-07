import 'package:flutter/material.dart';
import 'package:responsive_window/responsive_window.dart';

void main() {
  runApp(
    // ResponsiveWindow should wrap the root app widget.
    const ResponsiveWindow(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Window Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Window Example'),
      ),
      body: SafeArea(
        child: ResponsiveWindowBuilder.animated(
          // This animates only when the resolved responsive builder changes.
          compact: (context, windowData) {
            return _BottomNavigationLayout(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _handleDestinationSelected,
              child: _ExampleIndexedStack(selectedIndex: _selectedIndex),
            );
          },
          expanded: (context, windowData) {
            return _RailNavigationLayout(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _handleDestinationSelected,
              child: _ExampleIndexedStack(selectedIndex: _selectedIndex),
            );
          },
        ),
      ),
    );
  }

  void _handleDestinationSelected(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }
}

class _ExampleIndexedStack extends StatelessWidget {
  const _ExampleIndexedStack({
    required this.selectedIndex,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: const [
        _WindowDataPage(),
        _ResponsiveBuilderPage(),
        _AnimatedResponsiveBuilderPage(),
      ],
    );
  }
}

class _WindowDataPage extends StatelessWidget {
  const _WindowDataPage();

  @override
  Widget build(BuildContext context) {
    final ResponsiveWindowData windowData = context.windowData;

    return _WindowDataCardPage(
      title: 'Current window data',
      description:
          'This page reads ResponsiveWindowData directly from context.',
      windowData: windowData,
      color: _windowCategoryColor(windowData.category),
      footer: _LayoutMessage(windowData: windowData),
    );
  }
}

class _ResponsiveBuilderPage extends StatelessWidget {
  const _ResponsiveBuilderPage();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWindowBuilder(
      // Only compact and expanded are provided.
      //
      // medium falls back to compact.
      // large and extraLarge fall back to expanded.
      compact: (context, windowData) {
        return _WindowDataCardPage(
          title: 'ResponsiveWindowBuilder',
          description: 'Compact builder selected. Medium uses this fallback.',
          windowData: windowData,
          color: _windowCategoryColor(windowData.category),
          footer: const Text('Builder fallback: compact -> compact/medium'),
        );
      },
      expanded: (context, windowData) {
        return _WindowDataCardPage(
          title: 'ResponsiveWindowBuilder',
          description:
              'Expanded builder selected. Large and extra-large use this fallback.',
          windowData: windowData,
          color: _windowCategoryColor(windowData.category),
          footer: const Text(
            'Builder fallback: expanded -> expanded/large/extraLarge',
          ),
        );
      },
    );
  }
}

class _AnimatedResponsiveBuilderPage extends StatelessWidget {
  const _AnimatedResponsiveBuilderPage();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWindowBuilder.animated(
      // compact, medium, and large are provided.
      //
      // expanded falls back to medium.
      // extraLarge falls back to large.
      compact: (context, windowData) {
        return _WindowDataCardPage(
          title: 'ResponsiveWindowBuilder.animated',
          description: 'Compact animated builder selected.',
          windowData: windowData,
          color: _windowCategoryColor(windowData.category),
          footer: const Text('Animated builder: compact'),
        );
      },
      medium: (context, windowData) {
        return _WindowDataCardPage(
          title: 'ResponsiveWindowBuilder.animated',
          description:
              'Medium animated builder selected. Expanded uses this fallback.',
          windowData: windowData,
          color: _windowCategoryColor(windowData.category),
          footer: const Text('Animated builder: medium/expanded'),
        );
      },
      large: (context, windowData) {
        return _WindowDataCardPage(
          title: 'ResponsiveWindowBuilder.animated',
          description:
              'Large animated builder selected. Extra-large uses this fallback.',
          windowData: windowData,
          color: _windowCategoryColor(windowData.category),
          footer: const Text('Animated builder: large/extraLarge'),
        );
      },
    );
  }
}

class _BottomNavigationLayout extends StatelessWidget {
  const _BottomNavigationLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onDestinationSelected,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Data',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_quilt_outlined),
              activeIcon: Icon(Icons.view_quilt),
              label: 'Builder',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_motion_outlined),
              activeIcon: Icon(Icons.auto_awesome_motion),
              label: 'Animated',
            ),
          ],
        ),
      ],
    );
  }
}

class _RailNavigationLayout extends StatelessWidget {
  const _RailNavigationLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: Text('Data'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.view_quilt_outlined),
              selectedIcon: Icon(Icons.view_quilt),
              label: Text('Builder'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.auto_awesome_motion_outlined),
              selectedIcon: Icon(Icons.auto_awesome_motion),
              label: Text('Animated'),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: child),
      ],
    );
  }
}

class _WindowDataCardPage extends StatelessWidget {
  const _WindowDataCardPage({
    required this.title,
    required this.description,
    required this.windowData,
    required this.color,
    required this.footer,
  });

  final String title;
  final String description;
  final ResponsiveWindowData windowData;
  final Color color;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry pagePadding =
        const ResponsiveWindowValue<EdgeInsetsGeometry>(
      compact: EdgeInsets.all(16),
      medium: EdgeInsets.all(24),
      expanded: EdgeInsets.all(36),
    ).resolveWith(windowData);

    final Color foregroundColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: pagePadding,
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Card(
                color: color,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(color: foregroundColor),
                    textAlign: TextAlign.center,
                    child: IconTheme.merge(
                      data: IconThemeData(color: foregroundColor),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: foregroundColor),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(description),
                          const SizedBox(height: 24),
                          Text(
                            'Width: ${windowData.width.toStringAsFixed(0)}',
                          ),
                          Text(
                            'Height: ${windowData.height.toStringAsFixed(0)}',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Category: '
                            '${_windowCategoryLabel(windowData.category)}',
                          ),
                          const SizedBox(height: 24),
                          footer,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LayoutMessage extends StatelessWidget {
  const _LayoutMessage({
    required this.windowData,
  });

  final ResponsiveWindowData windowData;

  @override
  Widget build(BuildContext context) {
    if (windowData.isCompact) {
      return const Text('Use a compact layout.');
    }

    if (windowData.isMedium) {
      return const Text('Use a medium layout.');
    }

    if (windowData.isExpanded) {
      return const Text('Use an expanded layout.');
    }

    if (windowData.isLarge) {
      return const Text('Use a large layout.');
    }

    return const Text('Use an extra-large layout.');
  }
}

Color _windowCategoryColor(ResponsiveWindowCategory category) {
  return switch (category) {
    ResponsiveWindowCategory.compact => Colors.deepOrange,
    ResponsiveWindowCategory.medium => Colors.amber,
    ResponsiveWindowCategory.expanded => Colors.green,
    ResponsiveWindowCategory.large => Colors.blue,
    ResponsiveWindowCategory.extraLarge => Colors.deepPurple,
  };
}

String _windowCategoryLabel(ResponsiveWindowCategory category) {
  return switch (category) {
    ResponsiveWindowCategory.compact => 'Compact',
    ResponsiveWindowCategory.medium => 'Medium',
    ResponsiveWindowCategory.expanded => 'Expanded',
    ResponsiveWindowCategory.large => 'Large',
    ResponsiveWindowCategory.extraLarge => 'Extra Large',
  };
}
