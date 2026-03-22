import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/chat_provider.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/type_indicator.dart';
import '../widgets/suggestion_chip.dart';

/// Premium Animated AI Chatbot Screen
class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Auto scroll on new messages
    if (chatState.messages.isNotEmpty) {
      _scrollToBottom();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // Animated Header
            _buildAnimatedHeader(isMobile)
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.2, duration: 600.ms, curve: Curves.easeOut),

            // Messages area
            Expanded(
              child: chatState.messages.isEmpty && !chatState.isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(isMobile ? 16 : 20),
                      itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == chatState.messages.length && chatState.isLoading) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFF4F46E5).withOpacity(0.1),
                                  child: const Icon(Icons.psychology_rounded, size: 14, color: Color(0xFF06B6D4)),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const ChatTypingIndicator(),
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: 0.2, duration: 300.ms, curve: Curves.easeOut),
                          );
                        }

                        final message = chatState.messages[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ChatMessageBubble(
                            text: message.message,
                            isUser: message.sender == 'user',
                            isError: message.isError,
                            timestamp: message.createdAt,
                          )
                          .animate()
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 400.ms,
                            curve: Curves.easeOut,
                          )
                          .fadeIn(duration: 400.ms),
                        );
                      },
                    ),
            ),

            // Suggestions (show only when no messages)
            if (chatState.messages.isEmpty) _buildSuggestionsSection(isMobile),

            // Chat input
            ChatInput(onSend: _handleSendMessage, isLoading: chatState.isLoading)
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.2, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  /// Build animated header
  Widget _buildAnimatedHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.1),
            const Color(0xFF8B5CF6).withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF06B6D4).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4F46E5).withOpacity(0.3),
                      const Color(0xFF8B5CF6).withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF06B6D4).withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: Color(0xFF06B6D4),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SkillScope AI Assistant',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ask anything about skills, careers, and technologies',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4F46E5).withOpacity(0.2),
                      const Color(0xFF06B6D4).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF06B6D4).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: Color(0xFF06B6D4),
                  size: 60,
                ),
              ).animate().scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),
              const SizedBox(height: 24),
              Text(
                'Ask SkillScope AI',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ).animate().slideY(
                begin: 0.2,
                duration: 600.ms,
                delay: 100.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 12),
              Text(
                'Ask anything about your career, skills, or learning path',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  color: Colors.grey[400],
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().slideY(
                begin: 0.2,
                duration: 600.ms,
                delay: 200.ms,
                curve: Curves.easeOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build suggestions section
  Widget _buildSuggestionsSection(bool isMobile) {
    final suggestions = [
      'Top skills for Flutter developer',
      'How to learn AI?',
      'Best backend technologies 2024',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested Questions',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(suggestions.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < suggestions.length - 1 ? 10 : 0,
                  ),
                  child: SuggestionChip(
                    text: suggestions[index],
                    onTap: () => _handleSendMessage(suggestions[index]),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
