import 'priority.dart';

/// Interface: every object that has an ID must implement this.
abstract class Identifiable {
  String get id;
}

/// Abstract base class for all tasks.
/// You cannot create a Task directly — only its children.
abstract class Task implements Identifiable {
  @override
  final String id;
  final String title;
  final Priority priority;
  final DateTime? deadline; // optional
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.deadline,
    this.isDone = false,
  });

  /// Common way to show a task in the terminal.
  /// Child classes can override this method.
  String display() {
    final status = isDone ? '✓' : ' ';
    final deadlineStr = deadline != null
        ? ' | due: ${deadline!.toIso8601String().substring(0, 10)}'
        : '';
    return '[$status] $id | $title | ${priority.name}$deadlineStr';
  }

  /// Every task must be able to convert itself to JSON.
  Map<String, dynamic> toJson();

  /// Factory constructor: creates the correct type of Task from JSON.
  factory Task.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'normal';
    switch (type) {
      case 'urgent':
        return UrgentTask.fromJson(json);
      default:
        return NormalTask.fromJson(json);
    }
  }
}

/// Normal task (most common type)
class NormalTask extends Task {
  NormalTask({
    required super.id,
    required super.title,
    required super.priority,
    super.deadline,
    super.isDone,
  });

  factory NormalTask.fromJson(Map<String, dynamic> json) {
    return NormalTask(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: Priority.fromString(json['priority'] as String),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      isDone: json['isDone'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'normal',
      'id': id,
      'title': title,
      'priority': priority.name,
      'deadline': deadline?.toIso8601String(),
      'isDone': isDone,
    };
  }
}

/// Urgent task — this is the inheritance example required by the assignment.
class UrgentTask extends Task {
  final String reason;

  UrgentTask({
    required super.id,
    required super.title,
    required super.priority,
    super.deadline,
    super.isDone,
    required this.reason,
  });

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: Priority.fromString(json['priority'] as String),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      isDone: json['isDone'] as bool? ?? false,
      reason: json['reason'] as String? ?? 'No reason given',
    );
  }

  /// We override the display method to show extra information.
  @override
  String display() {
    return '${super.display()} | URGENT: $reason';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'urgent',
      'id': id,
      'title': title,
      'priority': priority.name,
      'deadline': deadline?.toIso8601String(),
      'isDone': isDone,
      'reason': reason,
    };
  }
}