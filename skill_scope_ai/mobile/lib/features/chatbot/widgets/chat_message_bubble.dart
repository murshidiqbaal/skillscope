import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/// A bubble widget to display chat messages or error notifications.
///
/// [text] is the message content (supports Markdown for AI responses).
/// [isUser] determines alignment and styling (primary color for user).
/// [isError] if true, styles the bubble as an error (reddish background).
class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isError;
  final DateTime timestamp;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.isError = false,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI avatar on left
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: isError 
                  ? theme.colorScheme.errorContainer 
                  : theme.colorScheme.primaryContainer,
              child: Icon(
                isError ? Icons.error_outline_rounded : Icons.psychology_rounded,
                size: 16, 
                color: isError 
                    ? theme.colorScheme.onErrorContainer 
                    : theme.colorScheme.onPrimaryContainer
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isError
                        ? theme.colorScheme.errorContainer
                        : (isUser
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest),
                    border: isError
                        ? Border.all(color: theme.colorScheme.error.withOpacity(0.5), width: 1)
                        : null,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: isUser || isError
                      ? Text(
                          text,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isError 
                                ? theme.colorScheme.onErrorContainer 
                                : (isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
                          ),
                        )
                      : MarkdownBody(
                          data: text,
                          styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                            p: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            code: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHigh,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(timestamp),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),

          // User avatar on right
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.secondary,
              child: Icon(Icons.person_rounded,
                  size: 16, color: theme.colorScheme.onSecondary),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
