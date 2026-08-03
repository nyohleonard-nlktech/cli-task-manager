/// Represents the priority level of a task.
/// Using an enum makes the code safer and clearer.
enum Priority {
  low,
  medium,
  high;

  /// Converts a string (e.g. "high") into a Priority.
  /// Throws an error if the string is invalid.
  static Priority fromString(String value) {
    return Priority.values.firstWhere(
      (p) => p.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid priority: $value. Use low, medium or high.'),
    );
  }

  /// Gives a number so we can easily sort tasks later.
  /// High = 3, Medium = 2, Low = 1
  int get weight {
    switch (this) {
      case Priority.high:
        return 3;
      case Priority.medium:
        return 2;
      case Priority.low:
        return 1;
    }
  }
}