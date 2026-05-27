import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'image_viewer.dart';

class CertificatesSection extends StatefulWidget {
  final List<CertificateItem> certificates;

  const CertificatesSection({super.key, required this.certificates});

  @override
  State<CertificatesSection> createState() => _CertificatesSectionState();
}

class _CertificatesSectionState extends State<CertificatesSection> {
  late final ScrollController _scrollController;
  int _activeIndex = 0;

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
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final cardWidth = (isMobile ? 260.0 : 320.0) + 20.0; // card + separator
    final index = (_scrollController.offset / cardWidth).round()
        .clamp(0, widget.certificates.length - 1);
    if (index != _activeIndex) setState(() => _activeIndex = index);
  }

  void _scrollTo(int index) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final cardWidth = (isMobile ? 260.0 : 320.0) + 20.0;
    _scrollController.animateTo(
      index * cardWidth,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _scrollPrev() {
    if (_activeIndex > 0) _scrollTo(_activeIndex - 1);
  }

  void _scrollNext() {
    if (_activeIndex < widget.certificates.length - 1) _scrollTo(_activeIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.certificates.isEmpty) return const SizedBox.shrink();

    final isMobile = Responsive.isMobile(context);
    final allImages = widget.certificates.map((c) => c.imageUrl).toList();
    final cardWidth = isMobile ? 260.0 : 320.0;
    final canPrev = _activeIndex > 0;
    final canNext = _activeIndex < widget.certificates.length - 1;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '03. Recognition',
            style: GoogleFonts.outfit(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Appreciation & Awards',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: isMobile ? 32 : 46,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Certificates and recognitions received for contributions and impact.',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 48),

          LayoutBuilder(
            builder: (context, constraints) {
              final listWidth = constraints.maxWidth;
              final cardStep = cardWidth + 20.0;
              final visibleCount = (listWidth / cardStep).floor().clamp(1, widget.certificates.length);
              final pageCount = (widget.certificates.length - visibleCount + 1).clamp(1, widget.certificates.length);
              final activeDot = _activeIndex.clamp(0, pageCount - 1);

              return Column(
                children: [
                  // Horizontal list
                  SizedBox(
                    height: isMobile ? 300 : 360,
                    child: ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: widget.certificates.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 20),
                      itemBuilder: (context, i) => _CertificateCard(
                        item: widget.certificates[i],
                        allImages: allImages,
                        index: i,
                        width: cardWidth,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Controls row: prev · dots · next
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ArrowButton(
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
                      _ArrowButton(
                        icon: Icons.arrow_forward_ios_rounded,
                        enabled: canNext,
                        onTap: _scrollNext,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ArrowButton({
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
          color: enabled ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

class _CertificateCard extends StatefulWidget {
  final CertificateItem item;
  final List<String> allImages;
  final int index;
  final double width;

  const _CertificateCard({
    required this.item,
    required this.allImages,
    required this.index,
    required this.width,
  });

  @override
  State<_CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends State<_CertificateCard> {
  bool _hovered = false;

  void _openViewer(BuildContext context) {
    if (widget.item.imageUrl.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => ImageViewer(
        images: widget.allImages.where((u) => u.isNotEmpty).toList(),
        initialIndex: widget.index,
      ),
    );
  }

  Widget _buildPreview() {
    final url = widget.item.imageUrl;
    if (url.isEmpty) return _placeholder();

    final image = url.startsWith('http')
        ? Image.network(url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, _, _) => _placeholder())
        : Image.asset(url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, _, _) => _placeholder());

    return image;
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.workspace_premium_rounded,
              color: AppColors.primary.withValues(alpha: 0.4), size: 52),
          const SizedBox(height: 12),
          Text(
            'Add certificate image',
            style: GoogleFonts.firaCode(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.item.imageUrl.isNotEmpty
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: () => _openViewer(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary.withValues(alpha: 0.6)
                  : AppColors.primary.withValues(alpha: 0.15),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Certificate image preview — Expanded fills leftover height after info strip
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildPreview(),
                      if (widget.item.imageUrl.isNotEmpty && _hovered)
                        Container(
                          color: Colors.black.withValues(alpha: 0.35),
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              'View Certificate',
                              style: GoogleFonts.firaCode(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Info strip
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        widget.item.date,
                        style: GoogleFonts.firaCode(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium_rounded,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.item.issuer,
                            style: GoogleFonts.firaCode(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.item.title,
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.item.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.item.description,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.6,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
