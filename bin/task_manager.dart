import 'package:task_manager/repositories/task_repository.dart';
import 'package:task_manager/services/task_service.dart';
import 'package:task_manager/cli/cli_handler.dart';

Future<void> main() async {
  // 1. Create the repository (handles JSON file)
  final repository = JsonTaskRepository();

  // 2. Create the service (business logic)
  final service = TaskService(repository);

  // 3. Create the CLI and start the app
  final cli = CliHandler(service);

  await cli.run();
}