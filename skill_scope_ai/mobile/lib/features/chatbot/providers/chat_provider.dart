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
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    // Prevent multiple concurrent requests
    if (state.isLoading) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      state = state.copyWith(error: 'User not authenticated');
      return;
    }

    // Optimistic: show user message immediately
    final userMessage = ChatMessageModel(
      id: const Uuid().v4(),
      userId: user.id,
      message: trimmedText,
      sender: 'user',
      createdAt: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    // Save optimistic user message to DB (non-blocking)
    _apiService.saveMessage(userMessage);

    try {
      // Call updated API service (takes only text now)
      final aiReply = await _apiService.sendMessage(trimmedText);

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

      // Save AI message to DB (non-blocking)
      _apiService.saveMessage(aiMessage);
    } catch (e) {
      final errorMessage = ChatMessageModel(
        id: const Uuid().v4(),
        userId: user.id,
        message: 'Bot Error: ${e.toString().replaceAll('Exception: ', '')}',
        sender: 'ai',
        isError: true,
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isLoading: false,
        error: 'Failed to get response',
      );
    }
  }
}

// ── Provider ───────────────────────────────────────────────────────────────

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final apiService = ref.watch(chatApiServiceProvider);
  return ChatNotifier(apiService);
});
