# Agent Instructions & Guidelines

## Code Style & Safety Rules

### 1. Avoid Non-Null Assertions (`!`)

- **Rule**: Never use the non-null assertion operator (`!`) in Dart/Flutter
  code.
- **Rationale**: Non-null assertions can cause runtime crashes
  (`NullCheckOperatorFailed`) if unexpected null states occur.
- **Preferred Pattern**: Extract nullable properties into local variables and
  check them against `null` before use, allowing Dart's flow analysis (type
  promotion) to safely infer non-null types.

**Example**:

```dart
// ❌ Avoid:
if (state.lastUpdated != null) {
Text(_formatLastUpdated(state.lastUpdated!))
}

// ✅ Preferred:
final DateTime? lastUpdated = state.lastUpdated;
if (lastUpdated != null) {
Text(_formatLastUpdated(lastUpdated))
}
```

### 2. Named Parameters for Multi-Parameter Methods

- **Rule**: When a method or function has more than one parameter, all of its
  parameters must be named (using `{...}` syntax).
- **Rationale**: Named parameters improve readability and prevent invocation
  bugs caused by swapping positional arguments of the same type.

**Example**:

```dart
// ❌ Avoid:
void updateUser(String userId, String name, int age) {}
updateUser('123', 'John', 30);

// ✅ Preferred:
void updateUser({required String userId, required String name, required int age}) {}
updateUser(userId: '123', name: 'John',age:30);
```

### 3. Avoid Hardcoded Values

- **Rule**: Avoid magic numbers, inline strings, hardcoded URLs, retry counts,
  or timeout durations directly within widgets, blocs, or repositories.
- **Rationale**: Hardcoded values reduce maintainability, hinder testing, and
  make configuration or localization updates error-prone.
- **Preferred Pattern**: Extract configuration values, API paths, magic numbers,
  and durations into constants (`res/constants/`), and use `flutter_translate`
  for user-facing strings.

**Example**:

```dart
// ❌ Avoid:
Future.delayed(const Duration(milliseconds: 300000));
if (items.length > 50) {}

// ✅ Preferred:
const Duration cacheTtlThreshold = Duration(minutes: 5);
Future.delayed(cacheTtlThreshold);
if (items.length > constants.itemsPerPage) {}
```

### 4. Explicit `else` Blocks over Early Returns

- **Rule**: Avoid early-return guard clauses in methods. Instead, prefer
  explicit `else` blocks for handling alternate conditions or error states.
- **Rationale**: Explicit `else` blocks improve code readability and maintain a
  clear, structured control flow.
- **Preferred Pattern**: Wrap the main execution logic inside an `if` condition
  (e.g. checking validity or state), and place error emission or fallback
  handling in the corresponding `else` block.

**Example**:

```dart
// ❌ Avoid (Early return guard clause):
if (userId.isEmpty && !_isDemo) {
emit(const UnauthenticatedInvestmentsAccessState(errorMessage: 'User ID not found.'));
return;
}
// ... rest of method ...

// ✅ Preferred (Explicit else block):
if (userId.isNotEmpty || _isDemo) {
// ... rest of method ...
} else {
emit(const UnauthenticatedInvestmentsAccessState(errorMessage: 'User ID not found.'));
}
```

# This file should never exceed 200 lines of code, meaning, this line should never be below line number 200. If we need to add something to this file, we simply have to remove something less critical or make text less verbose.