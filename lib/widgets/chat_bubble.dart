import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../theme/app_colors.dart';
import 'chat_panel.dart';

/// Floating chat button and panel overlay.
///
/// Drop this as the last child in a [Stack] that wraps your [Scaffold]:
/// ```dart
/// Stack(
///   children: [
///     Scaffold(...),
///     const ChatBubble(),
///   ],
/// )
/// ```
class ChatBubble extends StatefulWidget {
  const ChatBubble({super.key});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  bool _isLoading = false;
  final List<Map<String, String>> _messages = [];
  final _chatService = ChatService();
  final _scrollController = ScrollController();

  late final AnimationController _animController;
  late final Animation<double> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _slideAnim = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  Future<void> _handleSend(String text) async {
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final reply = await _chatService.sendMessages(_messages);
      setState(() {
        _messages.add({'role': 'assistant', 'content': reply});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': 'Error: $e',
        });
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Positioned.fill(
      child: Stack(
        children: [
          // Dim backdrop when panel is open on mobile.
          if (_isOpen && isMobile)
            GestureDetector(
              onTap: _togglePanel,
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),

          // Chat panel — slides up above the FAB.
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) => Positioned(
              right: isMobile ? 16 : 20,
              left: isMobile ? 16 : null,
              bottom: 80 + bottomPad,
              child: Opacity(
                opacity: _fadeAnim.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnim.value),
                  child: child,
                ),
              ),
            ),
            child: Visibility(
              visible: _isOpen,
              maintainState: true,
              child: ChatPanel(
                messages: _messages,
                isLoading: _isLoading,
                scrollController: _scrollController,
                onSend: _handleSend,
                onClose: _togglePanel,
              ),
            ),
          ),

          // Floating action button — always visible at bottom-right.
          Positioned(
            right: 20,
            bottom: 20 + bottomPad,
            child: _FloatingChatButton(
              isOpen: _isOpen,
              onTap: _togglePanel,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FAB — gradient circle with animated icon swap
// ---------------------------------------------------------------------------

class _FloatingChatButton extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const _FloatingChatButton({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isOpen ? Icons.close_rounded : Icons.chat_bubble_outline_rounded,
            key: ValueKey(isOpen),
            color: AppColors.background,
            size: 22,
          ),
        ),
      ),
    );
  }
}
