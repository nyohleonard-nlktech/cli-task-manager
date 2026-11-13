# CLI Task Manager

A Dart command-line application scaffold using the standard Dart package layout.

## Requirements
- Dart SDK matching pubspec.yaml (currently ^3.11.0).
- Git.

## Setup
```bash
git clone https://github.com/nyohleonard-nlktech/cli-task-manager.git
cd cli-task-manager
dart pub get
```

## Run
```bash
dart run
```

If the package defines a named executable, run its file under bin/:
```bash
dart run bin/<entrypoint>.dart
```

Check the actual filename in bin/ before using the second command.

## Quality checks
```bash
dart test
dart analyze
```

## Structure
```text
bin/       # CLI entry point(s)
lib/       # Reusable application code
test/      # Automated tests
pubspec.yaml
pubspec.lock
```

Keep command-line interaction in the executable layer and reusable task logic in lib/. Add tests as task creation, listing, editing, and deletion are implemented.

No license file is present. All rights reserved unless an explicit license is added.
