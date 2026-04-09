# InvestTrack — Project Guidelines

## Workflow

- After every code change run `flutter analyze .` and confirm it reports no issues before marking the task complete.

## Code Style

- Prefer **one class per file** for data classes, plain Dart classes, and widget classes.
  Exceptions:
  - A `StatefulWidget` and its paired private `State` subclass may coexist in the same file.
  - A sealed/abstract base class and its concrete subclasses may coexist when they form a
    tightly coupled group (e.g. BLoC state files, BLoC event files, or enums with helpers).
- Prefer **widget classes over helper methods that return widgets** (e.g. avoid `Widget _buildFoo()`).
  Use a private `StatelessWidget` subclass instead. This preserves widget identity across rebuilds,
  enables `const` constructors, and follows the Flutter style guide.
- Prefer **one class per file** for widget classes as well. Even widget classes that started as
  private helpers should be extracted to their own file once they grow beyond a tightly-coupled
  implementation detail of a single widget (e.g. when they receive only injected data and
  callbacks and carry no knowledge of the parent's internals).
- Prefer `Object?` over `dynamic` unless `dynamic` is required by a framework API, generated code,
  or truly dynamic behavior.
- Keep the order of members in a class logical and easy to scan. Declare fields first (for example,
  `final ScrollController _horizontalScrollController = ScrollController();`), then place
  overridden lifecycle methods in the same order they execute. For Flutter widgets, prefer `build`
  before `dispose`.
- Prefer an explicit `else` branch over an early `return` followed by a closing brace. For example, prefer:
  ```dart
  if (condition) {
    // ...
  } else {
    // ...
  }
  ```
  over:
  ```dart
  if (condition) {
    // ...
    return;
  }
  // ...
  ```
- Do **not** use banner comments (position markers made of repeated characters, e.g.
  `// -----------------------------------------------------------------------`).
  They are clutter that fades into background noise. Good naming, small methods, and
  doc comments make section markers unnecessary (Clean Code).
