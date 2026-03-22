import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../models/chat_message_model.dart';

class ChatApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.fastapiBaseUrl));
  final _supabase = Supabase.instance.client;

  Future<String> sendMessage(String userId, String message) async {
    try {
      final response = await _dio.post('/chat', data: {
        'user_id': userId,
        'message': message,
      });

      if (response.statusCode == 200) {
        return response.data['response'];
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> saveMessage(ChatMessageModel message) async {
    try {
      await _supabase.from('chat_messages').insert(message.toJson());
    } catch (e) {
      print('Failed to save message to Supabase: $e');
    }
  }

  Future<List<ChatMessageModel>> getChatHistory(String userId) async {
    try {
      final response = await _dio.get('/chat/history/$userId');
      
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => ChatMessageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch chat history');
      }
    } catch (e) {
      // Fallback: Fetch directly from Supabase if backend is down
      final response = await _supabase
          .from('chat_messages')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);
      
      return (response as List).map((json) => ChatMessageModel.fromJson(json)).toList();
    }
  }
}

final chatApiServiceProvider = Provider((ref) => ChatApiService());
