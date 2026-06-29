import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_window/responsive_window.dart';

void main() {
  group('ResponsiveWindowData', () {
    ResponsiveWindowData dataForWidth(
      double width, {
      double height = 600,
      double compactBreakpoint = ResponsiveWindow.defaultCompactBreakpoint,
      double mediumBreakpoint = ResponsiveWindow.defaultMediumBreakpoint,
      double expandedBreakpoint = ResponsiveWindow.defaultExpandedBreakpoint,
      double largeBreakpoint = ResponsiveWindow.defaultLargeBreakpoint,
    }) {
      return ResponsiveWindowData(
        width: width,
        height: height,
        compactBreakpoint: compactBreakpoint,
        mediumBreakpoint: mediumBreakpoint,
        expandedBreakpoint: expandedBreakpoint,
        largeBreakpoint: largeBreakpoint,
      );
    }

    test('returns the current app window size as a Flutter Size', () {
      final data = dataForWidth(800, height: 480);

      expect(data.size, const Size(800, 480));
    });

    test('classifies compact widths', () {
      final data = dataForWidth(599.99);

      expect(data.category, ResponsiveWindowCategory.compact);
      expect(data.isCompact, isTrue);
      expect(data.isMedium, isFalse);
      expect(data.isExpanded, isFalse);
      expect(data.isLarge, isFalse);
      expect(data.isExtraLarge, isFalse);
    });

    test('classifies medium widths', () {
      final data = dataForWidth(600);

      expect(data.category, ResponsiveWindowCategory.medium);
      expect(data.isCompact, isFalse);
      expect(data.isMedium, isTrue);
      expect(data.isExpanded, isFalse);
      expect(data.isLarge, isFalse);
      expect(data.isExtraLarge, isFalse);
    });

    test('classifies expanded widths', () {
      final data = dataForWidth(840);

      expect(data.category, ResponsiveWindowCategory.expanded);
      expect(data.isCompact, isFalse);
      expect(data.isMedium, isFalse);
      expect(data.isExpanded, isTrue);
      expect(data.isLarge, isFalse);
      expect(data.isExtraLarge, isFalse);
    });

    test('classifies large widths', () {
      final data = dataForWidth(1200);

      expect(data.category, ResponsiveWindowCategory.large);
      expect(data.isCompact, isFalse);
      expect(data.isMedium, isFalse);
      expect(data.isExpanded, isFalse);
      expect(data.isLarge, isTrue);
      expect(data.isExtraLarge, isFalse);
    });

    test('classifies extra-large widths', () {
      final data = dataForWidth(1600);

      expect(data.category, ResponsiveWindowCategory.extraLarge);
      expect(data.isCompact, isFalse);
      expect(data.isMedium, isFalse);
      expect(data.isExpanded, isFalse);
      expect(data.isLarge, isFalse);
      expect(data.isExtraLarge, isTrue);
    });

    test('classifies widths using custom breakpoints', () {
      final data = dataForWidth(
        920,
        compactBreakpoint: 640,
        mediumBreakpoint: 900,
        expandedBreakpoint: 1280,
        largeBreakpoint: 1680,
      );

      expect(data.category, ResponsiveWindowCategory.expanded);
      expect(data.isExpanded, isTrue);
    });

    test('uses inclusive lower bounds and exclusive upper bounds', () {
      expect(
        dataForWidth(600).category,
        ResponsiveWindowCategory.medium,
      );

      expect(
        dataForWidth(840).category,
        ResponsiveWindowCategory.expanded,
      );

      expect(
        dataForWidth(1200).category,
        ResponsiveWindowCategory.large,
      );

      expect(
        dataForWidth(1600).category,
        ResponsiveWindowCategory.extraLarge,
      );
    });

    test('supports value equality', () {
      final first = dataForWidth(800, height: 480);
      final second = dataForWidth(800, height: 480);
      final third = dataForWidth(801, height: 480);

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });

    test('asserts when breakpoints are not ordered', () {
      expect(
        () => ResponsiveWindowData(
          width: 800,
          height: 600,
          compactBreakpoint: 840,
          mediumBreakpoint: 600,
          expandedBreakpoint: 1200,
          largeBreakpoint: 1600,
        ),
        throwsAssertionError,
      );
    });
  });

  group('ResponsiveWindow', () {
    test('exposes default breakpoint constants', () {
      expect(ResponsiveWindow.defaultCompactBreakpoint, 600);
      expect(ResponsiveWindow.defaultMediumBreakpoint, 840);
      expect(ResponsiveWindow.defaultExpandedBreakpoint, 1200);
      expect(ResponsiveWindow.defaultLargeBreakpoint, 1600);
    });

    test('asserts when breakpoints are not ordered', () {
      expect(
        () => ResponsiveWindow(
          compactBreakpoint: 840,
          mediumBreakpoint: 600,
          expandedBreakpoint: 1200,
          largeBreakpoint: 1600,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('provides window data to the widget subtree', (tester) async {
      late ResponsiveWindowData windowData;

      await tester.pumpWidget(
        Center(
          child: SizedBox(
            width: 700,
            height: 500,
            child: ResponsiveWindow(
              child: Builder(
                builder: (context) {
                  windowData = context.windowData;

                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(windowData.width, 700);
      expect(windowData.height, 500);
      expect(windowData.size, const Size(700, 500));
      expect(windowData.category, ResponsiveWindowCategory.medium);
    });

    testWidgets('uses custom breakpoints from ResponsiveWindow',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 600);

      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      late ResponsiveWindowData windowData;

      await tester.pumpWidget(
        Center(
          child: SizedBox(
            width: 920,
            height: 500,
            child: ResponsiveWindow(
              compactBreakpoint: 640,
              mediumBreakpoint: 900,
              expandedBreakpoint: 1280,
              largeBreakpoint: 1680,
              child: Builder(
                builder: (context) {
                  windowData = context.windowData;

                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(windowData.width, 920);
      expect(windowData.height, 500);
      expect(windowData.compactBreakpoint, 640);
      expect(windowData.mediumBreakpoint, 900);
      expect(windowData.expandedBreakpoint, 1280);
      expect(windowData.largeBreakpoint, 1680);
      expect(windowData.category, ResponsiveWindowCategory.expanded);
    });

    testWidgets('maybeOf returns null when no ResponsiveWindow exists above',
        (tester) async {
      late ResponsiveWindowData? windowData;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            windowData = ResponsiveWindowData.maybeOf(context);

            return const SizedBox();
          },
        ),
      );

      expect(windowData, isNull);
    });

    testWidgets('of throws FlutterError when no ResponsiveWindow exists above',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => ResponsiveWindowData.of(context),
              throwsA(isA<FlutterError>()),
            );

            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('maybeWindowData returns null when no ResponsiveWindow exists',
        (tester) async {
      late ResponsiveWindowData? windowData;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            windowData = context.maybeWindowData;

            return const SizedBox();
          },
        ),
      );

      expect(windowData, isNull);
    });

    testWidgets('context.windowData returns the nearest ResponsiveWindowData',
        (tester) async {
      late ResponsiveWindowData windowData;

      await tester.pumpWidget(
        Center(
          child: SizedBox(
            width: 500,
            height: 400,
            child: ResponsiveWindow(
              child: Builder(
                builder: (context) {
                  windowData = context.windowData;

                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(windowData.width, 500);
      expect(windowData.height, 400);
      expect(windowData.size, const Size(500, 400));
      expect(windowData.category, ResponsiveWindowCategory.compact);
    });
  });
}
