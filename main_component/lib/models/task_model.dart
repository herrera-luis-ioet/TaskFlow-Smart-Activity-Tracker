import 'package:flutter/foundation.dart';

/// Enum representing task priority levels
enum TaskPriority {
  high,
  medium,
  low,
}

/// Represents a subtask within a main task
class SubTask {
  final String id;
  final String title;
  bool isCompleted;

  SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
  };

  factory SubTask.fromJson(Map<String, dynamic> json) => SubTask(
    id: json['id'] as String,
    title: json['title'] as String,
    isCompleted: json['isCompleted'] as bool,
  );
}

/// Represents an attachment in a task
class TaskAttachment {
  final String id;
  final String name;
  final String url;
  final String type;

  TaskAttachment({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'type': type,
  };

  factory TaskAttachment.fromJson(Map<String, dynamic> json) => TaskAttachment(
    id: json['id'] as String,
    name: json['name'] as String,
    url: json['url'] as String,
    type: json['type'] as String,
  );
}

/// TaskModel represents a task in the TaskFlow application.
///
/// This class contains all the information about a task including its metadata,
/// subtasks, attachments, and notes. It also provides methods for JSON serialization
/// and deserialization.
@immutable
class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final String category;
  final bool isCompleted;
  final List<SubTask> subTasks;
  final List<TaskAttachment> attachments;
  final String notes;
  final DateTime createdAt;
  final DateTime? completedAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    this.isCompleted = false,
    this.subTasks = const [],
    this.attachments = const [],
    this.notes = '',
    required this.createdAt,
    this.completedAt,
  });

  /// Creates a copy of this TaskModel with the given fields replaced with new values.
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    String? category,
    bool? isCompleted,
    List<SubTask>? subTasks,
    List<TaskAttachment>? attachments,
    String? notes,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      subTasks: subTasks ?? this.subTasks,
      attachments: attachments ?? this.attachments,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Converts the TaskModel instance to a JSON map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'priority': priority.toString().split('.').last,
    'category': category,
    'isCompleted': isCompleted,
    'subTasks': subTasks.map((st) => st.toJson()).toList(),
    'attachments': attachments.map((a) => a.toJson()).toList(),
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  /// Creates a TaskModel instance from a JSON map.
  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    dueDate: DateTime.parse(json['dueDate'] as String),
    priority: TaskPriority.values.firstWhere(
      (e) => e.toString().split('.').last == json['priority'],
    ),
    category: json['category'] as String,
    isCompleted: json['isCompleted'] as bool,
    subTasks: (json['subTasks'] as List<dynamic>)
        .map((st) => SubTask.fromJson(st as Map<String, dynamic>))
        .toList(),
    attachments: (json['attachments'] as List<dynamic>)
        .map((a) => TaskAttachment.fromJson(a as Map<String, dynamic>))
        .toList(),
    notes: json['notes'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'] as String)
        : null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          dueDate == other.dueDate &&
          priority == other.priority &&
          category == other.category &&
          isCompleted == other.isCompleted &&
          listEquals(subTasks, other.subTasks) &&
          listEquals(attachments, other.attachments) &&
          notes == other.notes &&
          createdAt == other.createdAt &&
          completedAt == other.completedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      dueDate.hashCode ^
      priority.hashCode ^
      category.hashCode ^
      isCompleted.hashCode ^
      subTasks.hashCode ^
      attachments.hashCode ^
      notes.hashCode ^
      createdAt.hashCode ^
      completedAt.hashCode;
}
