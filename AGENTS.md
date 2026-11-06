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
