import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const ChatMessageModel._();

  const factory ChatMessageModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String message,
    required String sender, // 'user' or 'ai'
    @JsonKey(name: 'is_error') @Default(false) bool isError,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ChatMessageModel;

  bool get isUser => sender == 'user';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  @override
  // TODO: implement createdAt
  DateTime get createdAt => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement isError
  bool get isError => throw UnimplementedError();

  @override
  // TODO: implement message
  String get message => throw UnimplementedError();

  @override
  // TODO: implement sender
  String get sender => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement userId
  String get userId => throw UnimplementedError();
}
