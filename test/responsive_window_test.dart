import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_window/responsive_window.dart';

void main() {
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

  Widget testDirectionality({
    required Widget child,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: child,
    );
  }

  Widget constrainedResponsiveWindow({
    required double width,
    required double height,
    required Widget child,
  }) {
    return testDirectionality(
      child: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: ResponsiveWindow(
            child: child,
          ),
        ),
      ),
    );
  }

  group('ResponsiveWindowData', () {
    test('returns the current app window size as a Flutter Size', () {
      final ResponsiveWindowData data = dataForWidth(800, height: 480);

      expect(data.size, const Size(800, 480));
    });

    test('classifies compact widths', () {
      final ResponsiveWindowData data = dataForWidth(599.99);

      expect(data.category, ResponsiveWindowCategory.compact);
      expect(data.isCompact, isTrue);
      expect(data.isMedium, isFalse);
      expect(data.isExpanded, isFalse);
      expect(data.isLarge, isFalse);
      expect(data.isExtraLarge, isFalse);
    });

    test('classifies medium widths', () {
      final ResponsiveWindowData data = dataForWidth(600);

      expect(data.category, ResponsiveWindowCategory.medium);
      expect(data.isCompact, isFalse);
      expect(data.isMedium, isTrue);
      expect(data.isExpanded, isFalse);
      expect(data.isLarge, isFalse);
      expect(data.isExtraLarge, isFalse);
    });

    test('classifies expanded widths', () {
      final ResponsiveWindowData data = dataForWidth(840);

      expect(data.category, ResponsiveWindowCategory.expanded);
      expect(data.isCompact, isFalse);
      expect(data.isMedium, isFalse);
      expect(data.isExpanded, isTrue);
      expect(data.isLarge, isFalse);
      expect(data.isExtraLarge, isFalse);
    });

    test('classifies large widths', () {
      final ResponsiveWindowData data = dataForWidth(1200);

      expect(data.category, ResponsiveWindowCategory.large);
      expect(data.isCompact, isFalse);
      expect(data.isMedium, isFalse);
      expect(data.isExpanded, isFalse);
      expect(data.isLarge, isTrue);
      expect(data.isExtraLarge, isFalse);
    });

    test('classifies extra-large widths', () {
      final ResponsiveWindowData data = dataForWidth(1600);

      expect(data.category, ResponsiveWindowCategory.extraLarge);
      expect(data.isCompact, isFalse);
      expect(data.isMedium, isFalse);
      expect(data.isExpanded, isFalse);
      expect(data.isLarge, isFalse);
      expect(data.isExtraLarge, isTrue);
    });

    test('classifies widths using custom breakpoints', () {
      final ResponsiveWindowData data = dataForWidth(
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
      final ResponsiveWindowData first = dataForWidth(800, height: 480);
      final ResponsiveWindowData second = dataForWidth(800, height: 480);
      final ResponsiveWindowData third = dataForWidth(801, height: 480);

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });

    test('asserts when breakpoints are not finite', () {
      expect(
        () => ResponsiveWindowData(
          width: 800,
          height: 600,
          compactBreakpoint: 600,
          mediumBreakpoint: 840,
          expandedBreakpoint: 1200,
          largeBreakpoint: double.infinity,
        ),
        throwsAssertionError,
      );
    });

    test('asserts when compactBreakpoint is not greater than 0', () {
      expect(
        () => ResponsiveWindowData(
          width: 800,
          height: 600,
          compactBreakpoint: 0,
          mediumBreakpoint: 840,
          expandedBreakpoint: 1200,
          largeBreakpoint: 1600,
        ),
        throwsAssertionError,
      );
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

    test('asserts when breakpoints are not finite', () {
      expect(
        () => ResponsiveWindow(
          compactBreakpoint: 600,
          mediumBreakpoint: 840,
          expandedBreakpoint: 1200,
          largeBreakpoint: double.infinity,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    test('asserts when compactBreakpoint is not greater than 0', () {
      expect(
        () => ResponsiveWindow(
          compactBreakpoint: 0,
          mediumBreakpoint: 840,
          expandedBreakpoint: 1200,
          largeBreakpoint: 1600,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
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

    testWidgets(
      'asserts when placed where height constraints are unbounded',
      (tester) async {
        await tester.pumpWidget(
          testDirectionality(
            child: const SingleChildScrollView(
              child: ResponsiveWindow(
                child: SizedBox(),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      'asserts when placed where width constraints are unbounded',
      (tester) async {
        await tester.pumpWidget(
          testDirectionality(
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ResponsiveWindow(
                child: SizedBox(),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets('provides window data to the widget subtree', (tester) async {
      late ResponsiveWindowData windowData;

      await tester.pumpWidget(
        constrainedResponsiveWindow(
          width: 700,
          height: 500,
          child: Builder(
            builder: (context) {
              windowData = context.windowData;

              return const SizedBox();
            },
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
        testDirectionality(
          child: Center(
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
        constrainedResponsiveWindow(
          width: 500,
          height: 400,
          child: Builder(
            builder: (context) {
              windowData = context.windowData;

              return const SizedBox();
            },
          ),
        ),
      );

      expect(windowData.width, 500);
      expect(windowData.height, 400);
      expect(windowData.size, const Size(500, 400));
      expect(windowData.category, ResponsiveWindowCategory.compact);
    });
  });

  group('ResponsiveWindowValue', () {
    test('resolves exact configured values for each category', () {
      const ResponsiveWindowValue<String> value = ResponsiveWindowValue<String>(
        compact: 'compact',
        medium: 'medium',
        expanded: 'expanded',
        large: 'large',
        extraLarge: 'extraLarge',
      );

      expect(value.resolveWith(dataForWidth(500)), 'compact');
      expect(value.resolveWith(dataForWidth(600)), 'medium');
      expect(value.resolveWith(dataForWidth(840)), 'expanded');
      expect(value.resolveWith(dataForWidth(1200)), 'large');
      expect(value.resolveWith(dataForWidth(1600)), 'extraLarge');
    });

    test('falls back to the nearest smaller configured value', () {
      const ResponsiveWindowValue<String> value = ResponsiveWindowValue<String>(
        compact: 'compact',
        medium: 'medium',
        large: 'large',
      );

      expect(value.resolveWith(dataForWidth(500)), 'compact');
      expect(value.resolveWith(dataForWidth(600)), 'medium');
      expect(value.resolveWith(dataForWidth(840)), 'medium');
      expect(value.resolveWith(dataForWidth(1200)), 'large');
      expect(value.resolveWith(dataForWidth(1600)), 'large');
    });

    test('uses compact as the base fallback', () {
      const ResponsiveWindowValue<int> value = ResponsiveWindowValue<int>(
        compact: 1,
      );

      expect(value.resolveWith(dataForWidth(500)), 1);
      expect(value.resolveWith(dataForWidth(600)), 1);
      expect(value.resolveWith(dataForWidth(840)), 1);
      expect(value.resolveWith(dataForWidth(1200)), 1);
      expect(value.resolveWith(dataForWidth(1600)), 1);
    });

    test('treats optional null values as not configured', () {
      const ResponsiveWindowValue<String> value = ResponsiveWindowValue<String>(
        compact: 'compact',
        medium: null,
        expanded: 'expanded',
        large: null,
      );

      expect(value.resolveWith(dataForWidth(600)), 'compact');
      expect(value.resolveWith(dataForWidth(1200)), 'expanded');
      expect(value.resolveWith(dataForWidth(1600)), 'expanded');
    });

    testWidgets('resolve uses ResponsiveWindowData from context',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 700);

      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      late int resolvedValue;

      await tester.pumpWidget(
        constrainedResponsiveWindow(
          width: 900,
          height: 500,
          child: Builder(
            builder: (context) {
              resolvedValue = const ResponsiveWindowValue<int>(
                compact: 1,
                medium: 2,
                expanded: 3,
              ).resolve(context);

              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedValue, 3);
    });
  });

  group('ResponsiveWindowBuilder', () {
    test('exposes default transition duration', () {
      expect(
        ResponsiveWindowBuilder.defaultTransitionDuration,
        const Duration(milliseconds: 260),
      );
    });

    testWidgets('builds the compact builder', (tester) async {
      await tester.pumpWidget(
        constrainedResponsiveWindow(
          width: 500,
          height: 500,
          child: ResponsiveWindowBuilder(
            compact: (context, data) {
              return const Text('compact');
            },
          ),
        ),
      );

      expect(find.text('compact'), findsOneWidget);
    });

    testWidgets('builds the exact configured builder for each category',
        (tester) async {
      Future<void> pumpForWidth(double width) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width + 100, 700);

        await tester.pumpWidget(
          constrainedResponsiveWindow(
            width: width,
            height: 500,
            child: ResponsiveWindowBuilder(
              compact: (context, data) {
                return const Text('compact');
              },
              medium: (context, data) {
                return const Text('medium');
              },
              expanded: (context, data) {
                return const Text('expanded');
              },
              large: (context, data) {
                return const Text('large');
              },
              extraLarge: (context, data) {
                return const Text('extraLarge');
              },
            ),
          ),
        );
      }

      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      await pumpForWidth(500);
      expect(find.text('compact'), findsOneWidget);

      await pumpForWidth(700);
      expect(find.text('medium'), findsOneWidget);

      await pumpForWidth(900);
      expect(find.text('expanded'), findsOneWidget);

      await pumpForWidth(1300);
      expect(find.text('large'), findsOneWidget);

      await pumpForWidth(1700);
      expect(find.text('extraLarge'), findsOneWidget);
    });

    testWidgets('falls back to the nearest smaller configured builder',
        (tester) async {
      Future<void> pumpForWidth(double width) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width + 100, 700);

        await tester.pumpWidget(
          constrainedResponsiveWindow(
            width: width,
            height: 500,
            child: ResponsiveWindowBuilder(
              compact: (context, data) {
                return const Text('compact');
              },
              medium: (context, data) {
                return const Text('medium');
              },
              large: (context, data) {
                return const Text('large');
              },
            ),
          ),
        );
      }

      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      await pumpForWidth(500);
      expect(find.text('compact'), findsOneWidget);

      await pumpForWidth(700);
      expect(find.text('medium'), findsOneWidget);

      await pumpForWidth(900);
      expect(find.text('medium'), findsOneWidget);

      await pumpForWidth(1300);
      expect(find.text('large'), findsOneWidget);

      await pumpForWidth(1700);
      expect(find.text('large'), findsOneWidget);
    });

    testWidgets('passes ResponsiveWindowData to the selected builder',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 700);

      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      late ResponsiveWindowData builderData;

      await tester.pumpWidget(
        constrainedResponsiveWindow(
          width: 900,
          height: 500,
          child: ResponsiveWindowBuilder(
            compact: (context, data) {
              builderData = data;

              return const Text('compact');
            },
            expanded: (context, data) {
              builderData = data;

              return const Text('expanded');
            },
          ),
        ),
      );

      expect(find.text('expanded'), findsOneWidget);
      expect(builderData.width, 900);
      expect(builderData.height, 500);
      expect(builderData.category, ResponsiveWindowCategory.expanded);
    });
  });

  group('ResponsiveWindowBuilder.animated', () {
    testWidgets('builds the resolved responsive builder', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 700);

      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      await tester.pumpWidget(
        constrainedResponsiveWindow(
          width: 900,
          height: 500,
          child: ResponsiveWindowBuilder.animated(
            compact: (context, data) {
              return const Text('compact');
            },
            expanded: (context, data) {
              return const Text('expanded');
            },
          ),
        ),
      );

      expect(find.text('expanded'), findsOneWidget);
    });

    testWidgets(
      'does not create an animated transition when fallback builder is unchanged',
      (tester) async {
        Future<void> pumpForWidth(double width) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width + 100, 700);

          await tester.pumpWidget(
            constrainedResponsiveWindow(
              width: width,
              height: 500,
              child: ResponsiveWindowBuilder.animated(
                duration: const Duration(seconds: 1),
                compact: (context, data) {
                  return const Text('compact');
                },
                medium: (context, data) {
                  return const Text('medium');
                },
              ),
            ),
          );
        }

        addTearDown(() {
          tester.view.resetDevicePixelRatio();
          tester.view.resetPhysicalSize();
        });

        await pumpForWidth(1700);
        expect(find.text('medium'), findsOneWidget);

        await pumpForWidth(1300);
        await tester.pump();

        expect(find.text('medium'), findsOneWidget);
        expect(find.text('compact'), findsNothing);
      },
    );

    testWidgets(
      'creates an animated transition when resolved builder changes',
      (tester) async {
        Future<void> pumpForWidth(double width) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width + 100, 700);

          await tester.pumpWidget(
            constrainedResponsiveWindow(
              width: width,
              height: 500,
              child: ResponsiveWindowBuilder.animated(
                duration: const Duration(seconds: 1),
                compact: (context, data) {
                  return const Text('compact');
                },
                medium: (context, data) {
                  return const Text('medium');
                },
              ),
            ),
          );
        }

        addTearDown(() {
          tester.view.resetDevicePixelRatio();
          tester.view.resetPhysicalSize();
        });

        await pumpForWidth(700);
        expect(find.text('medium'), findsOneWidget);

        await pumpForWidth(500);
        await tester.pump();

        expect(find.text('medium'), findsOneWidget);
        expect(find.text('compact'), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text('medium'), findsNothing);
        expect(find.text('compact'), findsOneWidget);
      },
    );
  });
}
