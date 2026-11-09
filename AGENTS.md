# Agent Instructions & Guidelines

## Code Style & Safety Rules

### 1. Avoid Non-Null Assertions (`!`)

- **Rule**: Never use the non-null assertion operator (`!`) in Dart/Flutter code.
- **Preferred Pattern**: Extract nullable properties into local variables and check against `null` before use.

```dart
final DateTime? lastUpdated = state.lastUpdated;
if (lastUpdated != null) {
  Text(_formatLastUpdated(lastUpdated));
}
```

### 2. Named Parameters for Multi-Parameter Methods

- **Rule**: When a method has more than one parameter, all parameters must be named (`{...}`).

```dart
void updateUser({required String userId, required String name, required int age}) {}
```

### 3. Avoid Hardcoded Values

- **Rule**: Avoid magic numbers, inline strings, or durations in widgets or blocs. Use constants (`res/constants/`) and `flutter_translate`.

### 4. Explicit `else` Blocks over Early Returns

- **Rule**: Avoid early-return guard clauses. Use explicit `else` blocks for alternate conditions or error states.

### 5. Strict Dependency Injection & Dependency Inversion

- **Rule**: Never use service locator calls (`GetIt.I.get()`) inside domain services, BLoCs, or repositories. Always inject dependencies via constructor parameters.

### 6. Avoid Conversational Prefixes in Dartdoc Comments

- **Rule**: Never use conversational prefixes like `Note:`, `Warning:`, or `Important:` at the beginning of Dartdoc comments.

### 7. Architectural Terminology

- **Rule**: Refer to the application's architecture exclusively as **Onion Architecture**, never as Clean Architecture.

### 8. Avoid Bare `as` Type Casts

- **Rule**: Avoid bare `as` type casts. Always verify types first using an `if` condition (e.g., `if (obj is ExpectedType) { ... }`), allowing Dart's type promotion to safely infer the type without runtime cast exceptions.

### 9. Never Use `null as ...` Type Casts

- **Rule**: Never use `null as dynamic` or any form of `null as T` to bypass constructor parameters or type constraints. Use proper nullable types or pass the exact required data source/dependency.

# This file should never exceed 200 lines of code, meaning, this line should never be below line number 200. If we need to add something to this file, we simply have to remove something less critical or make text less verbose.
