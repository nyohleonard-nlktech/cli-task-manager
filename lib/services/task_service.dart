import '../models/task.dart';
import '../models/priority.dart';
import '../repositories/task_repository.dart';
import '../exceptions/task_exceptions.dart';

class TaskService {
  final Repository<Task> repository;

  TaskService(this.repository);

  /// Creates a new task and saves it.
  Future<Task> addTask({
    required String title,
    required Priority priority,
    DateTime? deadline,
    bool isUrgent = false,
    String? urgentReason,
  }) async {
    // Validation
    if (title.trim().isEmpty) {
      throw InvalidTaskDataException('Title cannot be empty');
    }

    // Simple unique ID (using current time)
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final Task task;

    if (isUrgent) {
      task = UrgentTask(
        id: id,
        title: title.trim(),
        priority: priority,
        deadline: deadline,
        reason: urgentReason ?? 'No reason provided',
      );
    } else {
      task = NormalTask(
        id: id,
        title: title.trim(),
        priority: priority,
        deadline: deadline,
      );
    }

    await repository.add(task);
    return task;
  }

  /// Returns all tasks, sorted by priority or by deadline.
 Future<List<Task>> listTasks({bool sortByPriority = true}) async {
  final tasks = List<Task>.from(await repository.getAll()); // ← important change

  if (sortByPriority) {
    tasks.sort((a, b) => b.priority.weight.compareTo(a.priority.weight));
  } else {
    tasks.sort((a, b) {
      if (a.deadline == null && b.deadline == null) return 0;
      if (a.deadline == null) return 1;
      if (b.deadline == null) return -1;
      return a.deadline!.compareTo(b.deadline!);
    });
  }

  return tasks;
}

  /// Marks a task as completed.
  Future<void> markAsDone(String id) async {
    final task = await repository.getById(id);

    if (task == null) {
      throw TaskNotFoundException(id);
    }

    task.isDone = true;
    await repository.update(task);
  }

  /// Deletes a task.
  Future<void> deleteTask(String id) async {
    await repository.delete(id);
  }
}