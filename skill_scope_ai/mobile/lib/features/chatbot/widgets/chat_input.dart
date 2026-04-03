import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInput extends StatefulWidget {
  final void Function(String) onSend;
  final bool isLoading;

  const ChatInput({super.key, required this.onSend, this.isLoading = false});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isLoading) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF06B6D4).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Text Field ───────────────────────────────────────────────────
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? const Color(0xFF4F46E5).withOpacity(0.5)
                      : const Color(0xFF06B6D4).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                enabled: !widget.isLoading,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: widget.isLoading
                      ? 'SkillScope AI is thinking...'
                      : 'Ask about skills, careers, or tech...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ── Send Button ──────────────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: (_hasText && !widget.isLoading)
                  ? const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: (_hasText && !widget.isLoading)
                  ? null
                  : const Color(0xFF1E293B),
              shape: BoxShape.circle,
              boxShadow: (_hasText && !widget.isLoading)
                  ? [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (_hasText && !widget.isLoading) ? _handleSend : null,
                borderRadius: BorderRadius.circular(23),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey[600]!,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 18,
                          color: _hasText ? Colors.white : Colors.grey[600],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
