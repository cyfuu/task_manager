import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/widgets/task_tile.dart';
import 'package:task_manager/models/task.dart';

void main() {
  Widget buildTaskTile({
    required Task task,
    required VoidCallback onToggle,
    required VoidCallback onDelete,
  }) => MaterialApp(
    home: Scaffold(
      body: TaskTile(task: task, onToggle: onToggle, onDelete: onDelete),
    ),
  );

  Task buildTask() =>
      Task(id: '1', title: 'Test Task', dueDate: DateTime.now());

  late Task task;

  group('TaskTile - Rendering', () {
    setUp(() {
      task = buildTask().copyWith(isCompleted: true);
    });
    testWidgets('returns true when TaskTile displays the correct task title', 
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTaskTile(
        task: task,
        onToggle: () {},
        onDelete: () {},
      ));

      expect(find.text(task.title), findsOneWidget);
    });
    testWidgets('returns true when TaskTile displays the correct priority label', 
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTaskTile(
        task: task,
        onToggle: () {},
        onDelete: () {},
      ));

      expect(find.text(task.priority.name.toUpperCase()), findsOneWidget);
    });
    testWidgets('returns true when TaskTile reflects isCompleted in checkbox', 
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTaskTile(
        task: task, 
        onToggle: () {}, 
        onDelete: () {}
      ));

      final checkBox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkBox.value, isTrue);
    });
    testWidgets('returns true when TaskTile displays the delete icon', 
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTaskTile(
        task: task, 
        onToggle: () {}, 
        onDelete: () {}
      ));

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });
  group('TaskTile - Checkbox Interaction', () {
    setUp(() {
      task = buildTask();
    });
    testWidgets('returns true when onToggle is called when tapping checkbox', 
    (WidgetTester tester) async {
      bool toggle = false;

      await tester.pumpWidget(buildTaskTile(
        task: task, 
        onToggle: () {
          toggle = true;
        }, 
        onDelete: () {}
        ));

        await tester.tap(find.byType(Checkbox));
        await tester.pump();
        expect(toggle, isTrue);
    });
    testWidgets('returns true when onToggle is called exactly once', 
    (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(buildTaskTile(
        task: task, 
        onToggle: () {
          count++;
        }, 
        onDelete: () {}
      ));

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(count, equals(1));
    });
  });
}