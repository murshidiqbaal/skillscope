import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Chat Input Widget
///
/// Features:
/// - Glassmorphism input field
/// - Animated focus border
/// - Gradient send button
/// - Loading state handling
class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;

  const ChatInput({Key? key, required this.onSend, this.isLoading = false})
    : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _focusController;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty && !widget.isLoading) {
      onSend(_controller.text);
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  void onSend(String text) {
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF0F172A).withOpacity(0.8),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF06B6D4).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: AnimatedBuilder(
        animation: _focusController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(
                    0xFF1E293B,
                  ).withOpacity(0.5 + (0.3 * _focusController.value)),
                  const Color(
                    0xFF0F172A,
                  ).withOpacity(0.7 + (0.2 * _focusController.value)),
                ],
              ),
              border: Border.all(
                color: Color.lerp(
                  const Color(0xFF06B6D4).withOpacity(0.2),
                  const Color(0xFF06B6D4).withOpacity(0.5),
                  _focusController.value,
                )!,
                width: 1,
              ),
              boxShadow: [
                if (_isFocused)
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !widget.isLoading,
                    minLines: 1,
                    maxLines: 4,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask about skills or career guidance...',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    cursorColor: const Color(0xFF06B6D4),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Send Button
                _buildSendButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build animated send button
  Widget _buildSendButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF4F46E5), const Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : _handleSend,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      strokeWidth: 2.5,
                    ),
                  )
                : const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ).animate().scaleXY(
                    begin: 0.8,
                    end: 1,
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                  ),
          ),
        ),
      ),
    );
  }
}
