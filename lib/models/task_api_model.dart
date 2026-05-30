class TaskApiModel {
  final int? id;
  final String title;
  final String content;
  final String priority;
  final String color;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskApiModel({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.color,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  // Convertir JSON reçu du backend → TaskApiModel
  factory TaskApiModel.fromJson(Map<String, dynamic> json) {
    return TaskApiModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      priority: json['priority'],
      color: json['color'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convertir TaskApiModel → JSON à envoyer au backend
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'priority': priority,
      'color': color,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    };
  }
}