import "package:task_manager/services/task_service.dart";
import "package:test/test.dart";
import 'package:task_manager/models/task.dart';

void main() {
  Task createTask() => Task(
    id: '1',
    title: 'Test Task',
    dueDate: DateTime.now(),
  );
  group("Task Model - Constructor and Properties", () {
    late Task task;
    setUp(() {
      task = createTask().copyWith(dueDate: DateTime(2025, 1, 1, 12, 0));
    });
    test("returns true when task default values are correct", () {
      expect([task.description, task.isCompleted], [isEmpty, isFalse]);
    });
    test("returns true when task required values are provided", () {
      expect([task.id, task.title], equals(['1', 'Test Task']));
    });
    test("returns true when task priority is set to medium as default", () {
      expect(task.priority, equals(Priority.medium));
    });
    test("returns true when task dueDate is set to the provided value", () {
      expect(task.dueDate, equals(DateTime(2025, 1, 1, 12, 0)));
    });
  });
  group("Task Model - copyWith()", () {
    late Task task;
    setUp(() {
      task = createTask().copyWith(
        description: 'test',
        priority: Priority.low,
        isCompleted: true,
      );
    });
    test("returns true when values are partially updated", () {
      final updatedTask = task.copyWith(
        title: 'Updated Title',
        isCompleted: false,
      );
      expect(
        [
          updatedTask.id,
          updatedTask.title,
          updatedTask.description,
          updatedTask.priority,
          updatedTask.dueDate,
          updatedTask.isCompleted,
        ],
        equals([
          task.id,
          'Updated Title',
          task.description,
          task.priority,
          task.dueDate,
          isFalse,
        ]),
      );
    });
    test("returns true when values are fully updated", () {
      final updatedTask = task.copyWith(
        id: '2',
        title: 'Fully Updated Task',
        description: 'Updated description',
        priority: Priority.medium,
        dueDate: DateTime(2025, 3, 11, 9, 49),
        isCompleted: false,
      );
      expect(
        [
          updatedTask.id,
          updatedTask.title,
          updatedTask.description,
          updatedTask.priority,
          updatedTask.dueDate,
          updatedTask.isCompleted,
        ],
        equals([
          '2',
          'Fully Updated Task',
          'Updated description',
          Priority.medium,
          DateTime(2025, 3, 11, 9, 49),
          isFalse,
        ]),
      );
    });
    test("returns true when values are unchanged", () {
      final updatedTask = task.copyWith();
      expect(
        [
          updatedTask.id,
          updatedTask.title,
          updatedTask.description,
          updatedTask.priority,
          updatedTask.dueDate,
          updatedTask.isCompleted,
        ],
        equals([
          task.id,
          task.title,
          task.description,
          task.priority,
          task.dueDate,
          task.isCompleted,
        ]),
      );
    });
  });
  group("Task Model - isOverdue getter", () {
    late Task task;
    setUp(() {
      task = createTask().copyWith(dueDate: DateTime.now().subtract(Duration(days: 1)));
    });
    test("returns true when task is past dueDate and incomplete", () {
      expect(task.isOverdue, isTrue);
    });
    test("returns false when task is before dueDate", () {
      final overdueTask = task.copyWith(dueDate: DateTime.now().add(Duration(days: 2)));
      expect(overdueTask.isOverdue, isFalse);
    });
    test("returns false when task is past dueDate and completed", () {
      final overdueTask = task.copyWith(isCompleted: true);
      expect(overdueTask.isOverdue, isFalse);
    });
  });
  group("Task Model - toJson() / fromJson()", () {
    late Task task;
    late Task deserializedTask;
    late Map<String, dynamic> json;
    setUp(() {
      task = createTask().copyWith(
        description: 'Testing JSON serialization',
        priority: Priority.high,
        isCompleted: false,
      );

      json = task.toJson();
      deserializedTask = Task.fromJson(json);
    });
    test(
      "returns true when task is serialized to JSON and deserialized back", () {
        expect(
          [
            deserializedTask.id,
            deserializedTask.title,
            deserializedTask.description,
            deserializedTask.priority,
            deserializedTask.dueDate,
            deserializedTask.isCompleted,
          ],
          equals([
            task.id,
            task.title,
            task.description,
            task.priority,
            task.dueDate,
            task.isCompleted,
          ]),
        );
      },
    );
    test(
      "returns true when field types are preserved after serialization and deserialization", () {
        expect(
          [
            deserializedTask.id,
            deserializedTask.title,
            deserializedTask.description,
            deserializedTask.priority,
            deserializedTask.dueDate,
            deserializedTask.isCompleted,
          ],
          [
            isA<String>(),
            isA<String>(),
            isA<String>(),
            isA<Priority>(),
            isA<DateTime>(),
            isA<bool>(),
          ],
        );
      },
    );
    test(
      "returns true when priority index mapping is correct after serialization and deserialization", () {
        expect(deserializedTask.priority.index, equals(json['priority']));
      },
    );
  });
  group("TaskService - addTask()", () {
    late Task task;
    late TaskService taskService;
    setUp(() {
      taskService = TaskService();
      task = createTask();
    });
    test("returns true when a new task is added to the service", () {
      taskService.addTask(task);
      expect(taskService.allTasks, hasLength(1));
    });
    test(
      "returns true when service throws argument error for empty task title", () {
        final emptyTask = task.copyWith(title: '');
        expect(() => taskService.addTask(emptyTask), throwsArgumentError);
      },
    );
    test("returns true when service allows duplicate task IDs", () {
      final duplicateTask = task.copyWith(title: 'Duplicate ID Test');
      taskService.addTask(task);
      taskService.addTask(duplicateTask);
      expect(task.id, equals(duplicateTask.id));
      expect(taskService.allTasks, hasLength(2));
    });
  });
  group("TaskService - deleteTask()", () {
    late Task task;
    late TaskService taskService;
    setUp(() {
      taskService = TaskService();
      task = createTask();

      taskService.addTask(task);
    });
    test("returns true when a existing task is deleted from service", () {
      taskService.deleteTask('1');
      expect(taskService.allTasks, isNot(contains(task)));
    });
    test(
      "returns true when a non-existent task is attempted to be deleted from service", () {
        taskService.deleteTask('0');
        expect(taskService.allTasks, contains(task));
      },
    );
  });
  group("TaskService - toggleComplete()", () {
    late Task task;
    late TaskService taskService;
    setUp(() {
      taskService = TaskService();
      task = createTask();
    });
    test(
      "returns true when a task completion status is toggled from false to true", () {
        taskService.addTask(task);
        taskService.toggleComplete('1');
        expect(taskService.allTasks.first.isCompleted, isTrue);
      },
    );
    test(
      "returns true when a task completion status is toggled from true to false", () {
        final toggledTask = task.copyWith(isCompleted: true);
        taskService.addTask(toggledTask);
        taskService.toggleComplete('1');
        expect(taskService.allTasks.first.isCompleted, isFalse);
      },
    );
    test(
      "returns true when a task completion status is toggled for an unknown task ID throws a StateError", () {
        expect(() => taskService.toggleComplete('0'), throwsStateError);
      },
    );
  });
  group("TaskService - getByStatus()", () {
    late Task task;
    late TaskService taskService;
    setUp(() {
      taskService = TaskService();
      task = createTask();

      taskService.addTask(task);
    });
    test("returns true when service filter only retrieves active tasks", () {
      final activeTasks = taskService.getByStatus(completed: false);
      expect(activeTasks.first.id, equals(task.id));
    });
    test("returns true when service filter only retrieves completed tasks", () {
      taskService.toggleComplete('1');
      final completedTasks = taskService.getByStatus(completed: true);
      expect(completedTasks.first.id, equals(task.id));
    });
  });
  group("TaskService - sortByPriority()", () {
    late Task task;
    late TaskService taskService;
    late Task highPriorityTask;
    late Task lowPriorityTask;
    setUp(() {
      taskService = TaskService();
      task = createTask();

      highPriorityTask = task.copyWith(id: '2', priority: Priority.high);
      lowPriorityTask = task.copyWith(id: '3', priority: Priority.low);

      taskService.addTask(task);
      taskService.addTask(lowPriorityTask);
      taskService.addTask(highPriorityTask);
    });
    test(
      "returns true when service is sorted by priority with high priority first", () {
        final sortedTasks = taskService.sortByPriority();
        expect(sortedTasks.first.priority, equals(highPriorityTask.priority));
      },
    );
    test("returns true when original list is unchanged", () {
      final originalTasks = List.of(taskService.allTasks);
      taskService.sortByPriority();
      expect(
        [
          taskService.allTasks[0].id,
          taskService.allTasks[1].id,
          taskService.allTasks[2].id,
        ],
        equals([originalTasks[0].id, originalTasks[1].id, originalTasks[2].id]),
      );
    });
  });
  group("TaskService - sortByDueDate()", () {
    late Task task;
    late TaskService taskService;
    late Task lowPriorityTask;
    late Task highPriorityTask;

    setUp(() {
      taskService = TaskService();
      task = createTask().copyWith(dueDate: DateTime(2025, 1, 2, 12, 0));

      lowPriorityTask = task.copyWith(
        id: '2',
        dueDate: DateTime(2025, 1, 3, 12, 0),
      );
      highPriorityTask = task.copyWith(
        id: '3',
        dueDate: DateTime(2025, 1, 1, 12, 0),
      );

      taskService.addTask(task);
      taskService.addTask(lowPriorityTask);
      taskService.addTask(highPriorityTask);
    });
    test(
      "returns true when service is sorted by due date with earliest date first", () {
        final sortedTasks = taskService.sortByDueDate();
        expect(sortedTasks.first.dueDate, equals(highPriorityTask.dueDate));
      },
    );
    test("returns true when original list is unchanged", () {
      final originalTasks = List.of(taskService.allTasks);
      taskService.sortByDueDate();
      expect(
        [
          taskService.allTasks[0].id,
          taskService.allTasks[1].id,
          taskService.allTasks[2].id,
        ],
        equals([originalTasks[0].id, originalTasks[1].id, originalTasks[2].id]),
      );
    });
  });
  group("TaskService - statistics getter", () {
    late Task task;
    late TaskService taskService;
    late Task completedTask;
    late Task overdueTask;
    setUp(() {
      taskService = TaskService();
      task = createTask().copyWith(dueDate: DateTime.now().add(Duration(days: 1)));

      completedTask = task.copyWith(id: '2', isCompleted: true);
      overdueTask = task.copyWith(
        id: '3',
        dueDate: DateTime(2025, 1, 1, 12, 0),
      );

      taskService.addTask(task);
      taskService.addTask(completedTask);
      taskService.addTask(overdueTask);
    });
    test("returns true when statistics getter finds empty tasks list", () {
      taskService.deleteTask('1');
      taskService.deleteTask('2');
      taskService.deleteTask('3');
      final stats = taskService.statistics;
      expect([
        stats['total'],
        stats['completed'],
        stats['overdue'],
      ], equals([0, 0, 0]));
    });
    test("returns true when statistics getter have mixed tasks count", () {
      final stats = taskService.statistics;
      expect([
        stats['total'],
        stats['completed'],
        stats['overdue'],
      ], equals([3, 1, 1]));
    });
    test("returns true when statistics counts overdue tasks correctly", () {
      taskService.toggleComplete('3');
      final stats = taskService.statistics;
      expect(stats['overdue'], equals(0));
    });
  });
}
