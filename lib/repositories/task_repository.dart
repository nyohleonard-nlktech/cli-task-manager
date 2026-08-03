import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import '../models/task.dart';
import '../exceptions/task_exceptions.dart';

/// Generic interface.
/// T must have an id (that's why we use `extends Identifiable`).
abstract class Repository<T extends Identifiable> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
  Future<void> save();
}

/// Concrete implementation that saves tasks in a local JSON file.
class JsonTaskRepository implements Repository<Task> {
  final String filePath;
  List<Task> _tasks = [];

  JsonTaskRepository({String? path})
      : filePath = path ?? p.join(Directory.current.path, 'tasks.json');

  /// Loads tasks from the JSON file into memory.
  Future<void> _load() async {
    final file = File(filePath);

    if (!await file.exists()) {
      _tasks = [];
      return;
    }

    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        _tasks = [];
        return;
      }

      final List<dynamic> jsonList = jsonDecode(content);
      _tasks = jsonList
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException('Failed to load tasks: $e');
    }
  }

  @override
  Future<List<Task>> getAll() async {
    await _load();
    return List.unmodifiable(_tasks); // return a copy so outside cannot change it
  }

  @override
  Future<Task?> getById(String id) async {
    await _load();
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> add(Task item) async {
    await _load();

    if (_tasks.any((t) => t.id == item.id)) {
      throw InvalidTaskDataException('Task with id ${item.id} already exists');
    }

    _tasks.add(item);
    await save();
  }

  @override
  Future<void> update(Task item) async {
    await _load();

    final index = _tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) {
      throw TaskNotFoundException(item.id);
    }

    _tasks[index] = item;
    await save();
  }

  @override
  Future<void> delete(String id) async {
    await _load();

    final initialLength = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);

    if (_tasks.length == initialLength) {
      throw TaskNotFoundException(id);
    }

    await save();
  }

  @override
  Future<void> save() async {
    try {
      final file = File(filePath);
      final jsonList = _tasks.map((t) => t.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      throw StorageException('Failed to save tasks: $e');
    }
  }
}