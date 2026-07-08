## 2.0.1

* DOCS: improve README wording and inline API formatting
* DOCS: improve public API documentation for default and custom breakpoints

## 2.0.0

* BREAKING: replace individual `ResponsiveWindow` breakpoint parameters with `ResponsiveWindowBreakpoints`
* BREAKING: replace individual `ResponsiveWindowData` breakpoint constructor parameters with `breakpoints`
* FEAT: add `ResponsiveWindowBreakpoints` with Material Design 3-inspired preset
* FEAT: add `isAtLeast` and `isAtMost` category helpers
* FEAT: add debug-friendly `toString` output for responsive data and breakpoints
* REFACTOR: centralize breakpoint validation and width classification
* REFACTOR: reduce default animated builder transition duration to 220ms
* DOCS: update breakpoint configuration documentation
* DOCS: explain category helper usage
* DOCS: clarify `ResponsiveWindowValue<Widget>` versus `ResponsiveWindowBuilder`
* TEST: add coverage for breakpoint configuration
* TEST: add coverage for category comparison helpers

## 1.1.1

* FIX: validate responsive breakpoints
* FIX: assert bounded responsive window constraints
* DOCS: clarify breakpoint requirements
* DOCS: clarify local responsive scope constraints
* TEST: add coverage for breakpoint and constraint assertions

## 1.1.0

* FEAT: add responsive value resolution with breakpoint fallbacks
* FEAT: add responsive widget builder
* FEAT: add animated responsive widget builder
* DOCS: document responsive values and builders
* TEST: add coverage for responsive values and builders

## 1.0.3

* DOCS: clarify local ResponsiveWindow constraint guidance

## 1.0.2

* DOCS: clarify advanced responsive window scope usage
* DOCS: improve README native window guidance

## 1.0.1

* DOCS: refine README overview
* DOCS: remove top-level changelog title
* CHORE: remove empty Flutter configuration from pubspec

## 1.0.0

* FEAT: add app-level responsive window scope
* FEAT: add Material Design 3-inspired width breakpoints
* FEAT: add `ResponsiveWindowCategory` for responsive width categories
* FEAT: add `ResponsiveWindowData` with width, height, size, category, and boolean helpers
* FEAT: add `BuildContext` accessors for responsive window data
* FEAT: add support for custom width breakpoints
* DOCS: add README usage documentation
* DOCS: add public API documentation
* DOCS: add example app
