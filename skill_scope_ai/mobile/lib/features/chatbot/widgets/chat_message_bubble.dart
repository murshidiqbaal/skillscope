import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isError;
  final DateTime? timestamp;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.isError = false,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // ── Avatar + Bubble ────────────────────────────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser) ...[
                  _AiAvatar(isError: isError),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: _BubbleBody(
                    text: text,
                    isUser: isUser,
                    isError: isError,
                  ),
                ),
                if (isUser) ...[const SizedBox(width: 8), _UserAvatar()],
              ],
            ),

            // ── Timestamp ─────────────────────────────────────────────────
            if (timestamp != null)
              Padding(
                padding: EdgeInsets.only(
                  top: 4,
                  left: isUser ? 0 : 40,
                  right: isUser ? 4 : 0,
                ),
                child: Text(
                  DateFormat('h:mm a').format(timestamp!),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Bubble body ────────────────────────────────────────────────────────────

class _BubbleBody extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isError;

  const _BubbleBody({
    required this.text,
    required this.isUser,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Copied to clipboard',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF1E293B),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUser
              ? null
              : isError
              ? const Color(0xFF450A0A)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: isUser
              ? null
              : Border.all(
                  color: isError
                      ? Colors.red.withOpacity(0.3)
                      : const Color(0xFF06B6D4).withOpacity(0.1),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? const Color(0xFF4F46E5).withOpacity(0.3)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isError) ...[
              const Icon(
                Icons.error_outline_rounded,
                size: 14,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: isUser
                      ? Colors.white
                      : isError
                      ? Colors.redAccent[100]
                      : Colors.grey[200],
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatars ────────────────────────────────────────────────────────────────

class _AiAvatar extends StatelessWidget {
  final bool isError;
  const _AiAvatar({required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isError
              ? [Colors.red.withOpacity(0.3), Colors.redAccent.withOpacity(0.2)]
              : [
                  const Color(0xFF4F46E5).withOpacity(0.3),
                  const Color(0xFF06B6D4).withOpacity(0.2),
                ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: isError
              ? Colors.red.withOpacity(0.3)
              : const Color(0xFF06B6D4).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        isError ? Icons.error_outline_rounded : Icons.smart_toy_rounded,
        size: 14,
        color: isError ? Colors.redAccent : const Color(0xFF06B6D4),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.person_rounded, size: 14, color: Colors.white),
    );
  }
}
