import 'package:flutter/material.dart';
import 'package:responsive_window/responsive_window.dart';

void main() {
  runApp(
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final window = context.window;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Window Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Current window size',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text('Width: ${window.width.toStringAsFixed(0)}'),
                  Text('Height: ${window.height.toStringAsFixed(0)}'),
                  const SizedBox(height: 16),
                  Text('Size: ${_windowSizeLabel(window.size)}'),
                  const SizedBox(height: 24),
                  _LayoutMessage(window: window),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LayoutMessage extends StatelessWidget {
  const _LayoutMessage({
    required this.window,
  });

  final ResponsiveWindowData window;

  @override
  Widget build(BuildContext context) {
    if (window.isCompact) {
      return const Text('Use a compact layout.');
    }

    if (window.isMedium) {
      return const Text('Use a medium layout.');
    }

    if (window.isExpanded) {
      return const Text('Use an expanded layout.');
    }

    if (window.isLarge) {
      return const Text('Use a large layout.');
    }

    return const Text('Use an extra-large layout.');
  }
}

String _windowSizeLabel(ResponsiveWindowSize size) {
  return switch (size) {
    ResponsiveWindowSize.compact => 'Compact',
    ResponsiveWindowSize.medium => 'Medium',
    ResponsiveWindowSize.expanded => 'Expanded',
    ResponsiveWindowSize.large => 'Large',
    ResponsiveWindowSize.extraLarge => 'Extra Large',
  };
}
