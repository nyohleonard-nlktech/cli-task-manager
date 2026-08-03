/// Base class for all task-related errors.
/// All other custom exceptions will inherit from this one.
class TaskException implements Exception {
  final String message;

  TaskException(this.message);

  @override
  String toString() => 'TaskException: $message';
}

/// Thrown when a task with a given ID does not exist.
class TaskNotFoundException extends TaskException {
  TaskNotFoundException(String id)
      : super('Task with id "$id" was not found.');
}

/// Thrown when the data given for a task is invalid
/// (example: empty title).
class InvalidTaskDataException extends TaskException {
  InvalidTaskDataException(String message) : super(message);
}

/// Thrown when there is a problem saving or loading the JSON file.
class StorageException extends TaskException {
  StorageException(String message) : super(message);
}