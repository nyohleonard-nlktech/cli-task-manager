import 'dart:io';

import '../models/priority.dart';
import '../services/task_service.dart';
import '../exceptions/task_exceptions.dart';

class CliHandler {
  final TaskService service;

  CliHandler(this.service);

  Future<void> run() async {
    print('=== Dart CLI Task Manager ===\n');

    while (true) {
      _printMenu();
      final choice = stdin.readLineSync()?.trim();

      try {
        switch (choice) {
          case '1':
            await _addTask();
            break;
          case '2':
            await _listTasks();
            break;
          case '3':
            await _markDone();
            break;
          case '4':
            await _deleteTask();
            break;
          case '5':
            print('\nGoodbye!');
            return;
          default:
            print('\nInvalid option. Please try again.\n');
        }
      } on TaskException catch (e) {
        print('\nError: ${e.message}\n');
      } catch (e) {
        print('\nUnexpected error: $e\n');
      }
    }
  }

  void _printMenu() {
    print('''
1. Add task
2. List tasks
3. Mark task as done
4. Delete task
5. Exit
''');
    stdout.write('Choose an option: ');
  }

  Future<void> _addTask() async {
    stdout.write('\nTitle: ');
    final title = stdin.readLineSync()?.trim() ?? '';

    stdout.write('Priority (low / medium / high): ');
    final prioStr = stdin.readLineSync()?.trim() ?? 'medium';
    final priority = Priority.fromString(prioStr);

    stdout.write('Deadline (YYYY-MM-DD) or leave empty: ');
    final deadlineStr = stdin.readLineSync()?.trim();
    DateTime? deadline;
    if (deadlineStr != null && deadlineStr.isNotEmpty) {
      deadline = DateTime.parse(deadlineStr);
    }

    stdout.write('Is this an urgent task? (y/n): ');
    final isUrgent = stdin.readLineSync()?.trim().toLowerCase() == 'y';

    String? reason;
    if (isUrgent) {
      stdout.write('Reason for urgency: ');
      reason = stdin.readLineSync()?.trim();
    }

    final task = await service.addTask(
      title: title,
      priority: priority,
      deadline: deadline,
      isUrgent: isUrgent,
      urgentReason: reason,
    );

    print('\nTask added successfully:');
    print(task.display());
    print('');
  }

  Future<void> _listTasks() async {
    stdout.write('\nSort by (p)riority or (d)eadline? [p]: ');
    final sortChoice = stdin.readLineSync()?.trim().toLowerCase() ?? 'p';

    final tasks = await service.listTasks(sortByPriority: sortChoice != 'd');

    if (tasks.isEmpty) {
      print('\nNo tasks found.\n');
      return;
    }

    print('\n---------- TASKS ----------');
    for (final task in tasks) {
      print(task.display());
    }
    print('---------------------------\n');
  }

  Future<void> _markDone() async {
    stdout.write('\nEnter Task ID: ');
    final id = stdin.readLineSync()?.trim() ?? '';
    await service.markAsDone(id);
    print('\nTask marked as done.\n');
  }

  Future<void> _deleteTask() async {
    stdout.write('\nEnter Task ID: ');
    final id = stdin.readLineSync()?.trim() ?? '';
    await service.deleteTask(id);
    print('\nTask deleted successfully.\n');
  }
}