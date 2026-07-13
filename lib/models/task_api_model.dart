class TaskApiModel {
  final int? id;
  final String title;
  final String content;
  final String priority;
  final String color;
  final String? category;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isCompleted;

  TaskApiModel({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.color,
    this.category,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.isCompleted = false,
  });

  factory TaskApiModel.fromJson(Map<String, dynamic> json) {
    return TaskApiModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      priority: json['priority'],
      color: json['color'],
      category: json['category'] as String?,
      isCompleted: json['isCompleted'] ?? false,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'priority': priority,
      'color': color,
      'isCompleted': isCompleted,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      if (category != null) 'category': category,
    };
  }

  TaskApiModel copyWith({bool? isCompleted, String? category}) {
    return TaskApiModel(
      id: id,
      title: title,
      content: content,
      priority: priority,
      color: color,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}