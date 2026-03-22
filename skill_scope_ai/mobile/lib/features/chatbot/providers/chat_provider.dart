import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message_model.dart';
import '../services/chat_api_service.dart';

// ── State ──────────────────────────────────────────────────────────────────

class ChatState {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    String? error,
  }) => ChatState(
    messages: messages ?? this.messages,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

// ── Notifier ───────────────────────────────────────────────────────────────

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatApiService _apiService;

  ChatNotifier(this._apiService) : super(const ChatState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final history = await _apiService.getChatHistory(user.id);
      state = state.copyWith(messages: history, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load history: $e',
      );
    }
  }

  Future<void> sendMessage(String text) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Optimistic: show user message immediately
    final userMessage = ChatMessageModel(
      id: const Uuid().v4(),
      userId: user.id,
      message: text,
      sender: 'user',
      createdAt: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, userMessage]);
    
    // Save optimistic user message to DB
    _apiService.saveMessage(userMessage);

    // Set thinking indicator
    state = state.copyWith(isLoading: true);

    try {
      final aiReply = await _apiService.sendMessage(user.id, text);
      final aiMessage = ChatMessageModel(
        id: const Uuid().v4(),
        userId: user.id,
        message: aiReply,
        sender: 'ai',
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
      
      // Save AI message to DB
      _apiService.saveMessage(aiMessage);
    } catch (e) {
      final errorMessage = ChatMessageModel(
        id: const Uuid().v4(),
        userId: user.id,
        message: 'Failed to get response: $e',
        sender: 'ai',
        isError: true,
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isLoading: false,
        error: 'Connection error. Please try again.',
      );
    }
  }
}

// ── Provider ───────────────────────────────────────────────────────────────

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final apiService = ref.watch(chatApiServiceProvider);
  return ChatNotifier(apiService);
});
