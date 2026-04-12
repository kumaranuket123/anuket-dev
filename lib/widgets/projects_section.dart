import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class ProjectsSection extends StatelessWidget {
  final ProjectsData data;

  const ProjectsSection({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '02. Selected Work',
            style: GoogleFonts.outfit(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              data.sectionTitle,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: isMobile ? 32 : 46,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              'A focused selection of products I designed and built with Flutter, from polished client delivery to personal apps with complex user flows.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(height: 1, color: AppColors.surface),
          const SizedBox(height: 50),
          if (data.clientProjects.isNotEmpty) ...[
            _SectionLabel(title: data.clientProjectsTitle),
            const SizedBox(height: 28),
            ...data.clientProjects.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                      entry.key == data.clientProjects.length - 1 &&
                          data.personalProjects.isEmpty
                      ? 0
                      : 36,
                ),
                child: _ProjectFeatured(
                  item: entry.value,
                  isReversed: entry.key.isOdd,
                  projectType: 'Client Project',
                ),
              );
            }),
          ],
          if (data.clientProjects.isNotEmpty &&
              data.personalProjects.isNotEmpty)
            const SizedBox(height: 20),
          if (data.personalProjects.isNotEmpty) ...[
            _SectionLabel(title: data.personalProjectsTitle),
            const SizedBox(height: 28),
            ...data.personalProjects.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == data.personalProjects.length - 1
                      ? 0
                      : 36,
                ),
                child: _ProjectFeatured(
                  item: entry.value,
                  isReversed: entry.key.isOdd,
                  projectType: 'Personal Showcase',
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        color: AppColors.textSecondary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ProjectFeatured extends StatefulWidget {
  final ProjectItem item;
  final bool isReversed;
  final String projectType;

  const _ProjectFeatured({
    required this.item,
    required this.projectType,
    this.isReversed = false,
  });

  @override
  State<_ProjectFeatured> createState() => _ProjectFeaturedState();
}

class _ProjectFeaturedState extends State<_ProjectFeatured> {
  bool isHovered = false;

  bool get _hasProjectDetail => widget.item.id.trim().isNotEmpty;
  bool get _usesAssetImage => !widget.item.imageUrl.startsWith('http');
  bool get _hasAndroidDownloadLink =>
      widget.item.androidDownloadLink.trim().isNotEmpty;
  bool get _hasIosDownloadLink => widget.item.iosDownloadLink.trim().isNotEmpty;

  void _launchUrl(String url) async {
    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  Widget _buildImageWidget() {
    if (_usesAssetImage) {
      return Image.asset(widget.item.imageUrl, fit: BoxFit.contain);
    }

    return Image.network(
      widget.item.imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.surface,
          alignment: Alignment.center,
          child: const Text(
            'Image Unavailable',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        );
      },
    );
  }

  Widget _buildProjectPreview({double? height}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHovered
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isHovered ? 0.35 : 0.2),
            blurRadius: isHovered ? 40 : 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: _buildImageWidget(),
        ),
      ),
    );
  }

  Widget _buildTechTag(String tech) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.surface),
      ),
      child: Text(
        tech,
        style: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProjectLinks() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (widget.item.githubLink.isNotEmpty)
          _ProjectIconButton(
            icon: FontAwesomeIcons.github,
            onPressed: () => _launchUrl(widget.item.githubLink),
          ),
        if (widget.item.externalLink.isNotEmpty)
          _ProjectIconButton(
            icon: FontAwesomeIcons.upRightFromSquare,
            onPressed: () => _launchUrl(widget.item.externalLink),
          ),
        FilledButton.icon(
          onPressed: _hasAndroidDownloadLink
              ? () => _launchUrl(widget.item.androidDownloadLink)
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            disabledBackgroundColor: AppColors.surface,
            disabledForegroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.android_rounded, size: 18),
          label: Text(
            _hasAndroidDownloadLink ? 'Android App' : 'Android Soon',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
          ),
        ),
        FilledButton.icon(
          onPressed: _hasIosDownloadLink
              ? () => _launchUrl(widget.item.iosDownloadLink)
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            disabledBackgroundColor: AppColors.surface,
            disabledForegroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.textSecondary),
            ),
          ),
          icon: const Icon(Icons.phone_iphone_rounded, size: 18),
          label: Text(
            _hasIosDownloadLink ? 'iOS App' : 'iOS Coming Soon',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
          ),
        ),
        TextButton(
          onPressed: _hasProjectDetail
              ? () => context.go('/project/${widget.item.id}')
              : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.primary),
            ),
          ),
          child: Text(
            'Read Case Study',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectContent() {
    return SizedBox(
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.projectType,
            style: GoogleFonts.outfit(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.item.title,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            widget.item.description,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.75,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.item.techStack.map(_buildTechTag).toList(),
          ),
          const SizedBox(height: 28),
          _buildProjectLinks(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surface),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProjectPreview(height: 240),
            const SizedBox(height: 24),
            Text(
              widget.projectType,
              style: GoogleFonts.outfit(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.item.title,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.item.description,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.item.techStack.map(_buildTechTag).toList(),
            ),
            const SizedBox(height: 20),
            _buildProjectLinks(),
          ],
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isHovered
                ? AppColors.primary.withValues(alpha: 0.45)
                : AppColors.surface,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isHovered ? 0.28 : 0.16),
              blurRadius: isHovered ? 36 : 24,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.isReversed
              ? [
                  _buildProjectContent(),
                  const SizedBox(width: 32),
                  Expanded(child: _buildProjectPreview(height: 360)),
                ]
              : [
                  Expanded(child: _buildProjectPreview(height: 360)),
                  const SizedBox(width: 32),
                  _buildProjectContent(),
                ],
        ),
      ),
    );
  }
}

class _ProjectIconButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onPressed;

  const _ProjectIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: FaIcon(icon, color: AppColors.textPrimary, size: 18),
          ),
        ),
      ),
    );
  }
}
