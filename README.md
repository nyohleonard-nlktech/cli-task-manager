# CLI Task Manager

**A Dart command-line application scaffold for task-management workflows.**

This repository follows a standard Dart package layout with an executable entry point in `bin/`, reusable code in `lib/`, and tests in `test/`.

## Requirements

- Dart SDK matching the constraint in `pubspec.yaml` (currently Dart 3.11 or compatible)
- Git

## Setup

```bash
git clone https://github.com/nyohleonard-nlktech/cli-task-manager.git
cd cli-task-manager
dart pub get
```

## Run

Run the package executable:

```bash
dart run
```

If the project defines a named executable in `bin/`, run it with:

```bash
dart run bin/<entrypoint>.dart
```

Check the actual entry-point filename in the `bin/` directory.

## Test

```bash
dart test
```

## Analyze

```bash
dart analyze
```

## Project structure

```text
.
├── bin/          # Command-line entry point(s)
├── lib/          # Reusable application code
├── test/         # Automated tests
├── pubspec.yaml  # Package metadata and dependencies
├── pubspec.lock
└── README.md
```

## Development

Keep command parsing and user interaction in the executable layer, place reusable task logic in `lib/`, and cover task creation, listing, updates, and deletion with tests as those capabilities are implemented.

## License

No license file is currently present. All rights reserved unless an explicit license is added.
