# InvestTrack — Project Guidelines

## Workflow

- After every code change run `flutter analyze .` and confirm it reports no issues before marking the task complete.

## Code Style

- Prefer **one class per file** for data classes and plain Dart classes.
  A `StatefulWidget` and its paired private `State` subclass may coexist in the same file.
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
