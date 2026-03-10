# Exercise Overview & Learning Objectives

This exercise assesses a student's ability to write meaningful automated tests for a Flutter application. Students are given a partially-built Task Manager app and are required to produce two test files that cover both business logic (unit tests) and UI behavior (widget tests). The exercise simulates a real-world scenario where a developer is responsible for quality assurance before a feature ships.

## 1.1 The Application: Task Manager

Students receive a pre-built Flutter project called task_manager. The app allows users to:

* Create tasks with a title, description, priority (low / medium / high), and due date
* Mark tasks as complete or incomplete
* Filter tasks by status (all / active / completed)
* Sort tasks by priority or due date
* Delete tasks
* Compute statistics (total, completed, overdue count)

### Project Structure Provided to Students

| File | Description |
|------|-------------|
| `lib/models/task.dart` | Task data model |
| `lib/services/task_service.dart` | Business logic layer |
| `lib/providers/task_provider.dart` | State management (ChangeNotifier) |
| `lib/screens/task_list_screen.dart` | Main list UI |
| `lib/screens/add_task_screen.dart` | Add/edit task form UI |
| `lib/widgets/task_tile.dart` | Individual task list item widget |
| `pubspec.yaml` | Already includes flutter_test, mockito, provider |

## 1.2 Learning Objectives

Upon completing this exercise, students should demonstrate the ability to:

1. Write isolated unit tests for model classes and service layers
2. Use `setUp()` and `tearDown()` to manage test state lifecycle
3. Test edge cases and boundary conditions, not just the happy path
4. Use `expect()` with appropriate matchers (equals, isTrue, throwsA, etc.)
5. Pump and render Flutter widgets in a test environment using `WidgetTester`
6. Find widgets using finder strategies (byType, byKey, byText)
7. Simulate user interactions (tap, enterText, drag) using `WidgetTester`
8. Verify widget state changes after interactions
9. Mock dependencies using Mockito to isolate the unit under test
