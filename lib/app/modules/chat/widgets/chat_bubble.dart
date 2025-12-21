import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'package:hikepass_app/app/shared/theme/app_typography.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isBot;
  final String time;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isBot,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isBot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            // Avatar bot
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isBot
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isBot ? AppColors.primary : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isBot ? 4 : 20),
                      bottomRight: Radius.circular(isBot ? 20 : 4),
                    ),
                  ),
                  child: isBot
                      ? MarkdownBody(
                          data: message,
                          styleSheet: MarkdownStyleSheet(
                            p: AppTypography.sRegular.copyWith(
                              color: Colors.white,
                              height: 1.5,
                            ),
                            strong: AppTypography.sBold.copyWith(
                              color: Colors.white,
                            ),
                            em: AppTypography.sRegular.copyWith(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                            listBullet: AppTypography.sRegular.copyWith(
                              color: Colors.white,
                            ),
                            listIndent: 16,
                            blockSpacing: 8,
                            h1: AppTypography.h3.copyWith(color: Colors.white),
                            h2: AppTypography.h3.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            h3: AppTypography.h3.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            code: AppTypography.sRegular.copyWith(
                              color: Colors.white,
                              backgroundColor: Colors.black26,
                              fontFamily: 'monospace',
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          selectable: true, // Bisa di-copy
                        )
                      : Text(
                          message,
                          style: AppTypography.sRegular.copyWith(
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTypography.xsRegular.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (!isBot) ...[
            const SizedBox(width: 8),
            // Avatar user
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: AppColors.secondary, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
