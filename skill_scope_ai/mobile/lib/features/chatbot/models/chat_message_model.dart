/// Model representing a single chat message in the conversation.
/// 
/// [sender] can be 'user' or 'ai'.
/// [isError] indicates if the message represents a failure or error notification.
class ChatMessageModel {
  final String id;
  final String userId;
  final String message;
  final String sender; // 'user' or 'ai'
  final bool isError;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.sender,
    this.isError = false,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        id: json['id'] as String? ?? '',
        userId: json['user_id'] as String? ?? '',
        message: json['message'] as String? ?? '',
        sender: json['sender'] as String? ?? 'ai',
        isError: json['is_error'] as bool? ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'message': message,
        'sender': sender,
        'is_error': isError,
        'created_at': createdAt.toIso8601String(),
      };
}
