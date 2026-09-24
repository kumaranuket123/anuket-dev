import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Horizontal sliding list with prev/next arrows and animated pagination dots.
/// Matches the visual language of the Recognition (certificates) slider.
class HorizontalCarousel extends StatefulWidget {
  final int itemCount;
  final double cardWidth;
  final double mobileCardWidth;
  final double cardHeight;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final bool showControls;
  final double separator;

  const HorizontalCarousel({
    super.key,
    required this.itemCount,
    required this.cardWidth,
    required this.mobileCardWidth,
    required this.cardHeight,
    required this.itemBuilder,
    this.showControls = true,
    this.separator = 20,
  });

  @override
  State<HorizontalCarousel> createState() => _HorizontalCarouselState();
}

class _HorizontalCarouselState extends State<HorizontalCarousel> {
  late final ScrollController _scrollController;
  int _activeIndex = 0;

  bool get _isMobile => MediaQuery.sizeOf(context).width < 768;

  double get _cardWidth =>
      _isMobile ? widget.mobileCardWidth : widget.cardWidth;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final step = _cardWidth + widget.separator;
    final index = (_scrollController.offset / step)
        .round()
        .clamp(0, widget.itemCount - 1);
    if (index != _activeIndex) setState(() => _activeIndex = index);
  }

  void _scrollTo(int index) {
    final step = _cardWidth + widget.separator;
    _scrollController.animateTo(
      index * step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _scrollPrev() {
    if (_activeIndex > 0) _scrollTo(_activeIndex - 1);
  }

  void _scrollNext() {
    if (_activeIndex < widget.itemCount - 1) _scrollTo(_activeIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount <= 0) return const SizedBox.shrink();

    final cardWidth = _cardWidth;
    final canPrev = _activeIndex > 0;
    final canNext = _activeIndex < widget.itemCount - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final listWidth = constraints.maxWidth;
        final cardStep = cardWidth + widget.separator;
        final visibleCount =
            (listWidth / cardStep).floor().clamp(1, widget.itemCount);
        final pageCount =
            (widget.itemCount - visibleCount + 1).clamp(1, widget.itemCount);
        final activeDot = _activeIndex.clamp(0, pageCount - 1);

        return Column(
          children: [
            SizedBox(
              height: widget.cardHeight,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: widget.itemCount,
                separatorBuilder: (_, _) => SizedBox(width: widget.separator),
                itemBuilder: (context, i) => SizedBox(
                  width: cardWidth,
                  child: widget.itemBuilder(context, i),
                ),
              ),
            ),
            if (widget.showControls) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CarouselArrowButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    enabled: canPrev,
                    onTap: _scrollPrev,
                  ),
                  const SizedBox(width: 20),
                  ...List.generate(pageCount, (i) {
                    final active = i == activeDot;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    );
                  }),
                  const SizedBox(width: 20),
                  _CarouselArrowButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    enabled: canNext,
                    onTap: _scrollNext,
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CarouselArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _CarouselArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}