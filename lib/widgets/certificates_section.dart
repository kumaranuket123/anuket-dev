import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'horizontal_carousel.dart';
import 'image_viewer.dart';

class CertificatesSection extends StatelessWidget {
  final List<CertificateItem> certificates;

  const CertificatesSection({super.key, required this.certificates});

  @override
  Widget build(BuildContext context) {
    if (certificates.isEmpty) return const SizedBox.shrink();

    final isMobile = Responsive.isMobile(context);
    final allImages = certificates.map((c) => c.imageUrl).toList();
    final cardHeight = isMobile ? 300.0 : 360.0;

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

          HorizontalCarousel(
            itemCount: certificates.length,
            cardWidth: 320,
            mobileCardWidth: 260,
            cardHeight: cardHeight,
            itemBuilder: (context, i) => _CertificateCard(
              item: certificates[i],
              allImages: allImages,
              index: i,
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateCard extends StatefulWidget {
  final CertificateItem item;
  final List<String> allImages;
  final int index;

  const _CertificateCard({
    required this.item,
    required this.allImages,
    required this.index,
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
