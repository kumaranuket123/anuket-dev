import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// A single chat bubble — user messages appear on the right, assistant on the left.
class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isUser ? 32 : 0,
          right: isUser ? 0 : 32,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surface,
          border: Border.all(
            color: isUser
                ? AppColors.primary.withOpacity(0.4)
                : AppColors.secondary.withOpacity(0.15),
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 3),
            bottomRight: Radius.circular(isUser ? 3 : 14),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 13,
            height: 1.55,
          ),
        ),
      ),
    );
  }
}
