class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      title: json['data']['title'] as String,
      message: json['data']['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['read_at'] != null,
    );
  }

  Map<String, dynamic> toJson() {
    // This is useful if you ever need to send notification data, though it's less common.
    return {
      'id': id,
      'title': title,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
