import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'horizontal_carousel.dart';

class ProjectsSection extends StatelessWidget {
  final ProjectsData data;

  const ProjectsSection({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final projects = <_ProjectEntry>[
      for (final item in data.clientProjects)
        _ProjectEntry(item: item, projectType: 'Client Project'),
      for (final item in data.personalProjects)
        _ProjectEntry(item: item, projectType: 'Personal Showcase'),
    ];

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
          HorizontalCarousel(
            itemCount: projects.length,
            cardWidth: isMobile ? 320 : 440,
            mobileCardWidth: 320,
            cardHeight: isMobile ? 680 : 640,
            itemBuilder: (context, i) => _ProjectCard(
              item: projects[i].item,
              projectType: projects[i].projectType,
              isMobile: isMobile,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectEntry {
  final ProjectItem item;
  final String projectType;

  const _ProjectEntry({required this.item, required this.projectType});
}

// ---- Shared helpers ---------------------------------------------------------

bool _hasProjectDetail(ProjectItem item) => item.id.trim().isNotEmpty;
bool _hasImage(ProjectItem item) => item.imageUrl.trim().isNotEmpty;
bool _usesAssetImage(ProjectItem item) => !item.imageUrl.startsWith('http');

void _launchExternalUrl(String url) async {
  if (url.isEmpty) return;
  final uri = Uri.parse(url);
  await launchUrl(uri, webOnlyWindowName: '_blank');
}

Widget _projectPlaceholder(ProjectItem item) {
  return Container(
    color: AppColors.background,
    alignment: Alignment.center,
    child: Text(
      item.title,
      textAlign: TextAlign.center,
      style: GoogleFonts.outfit(
        color: AppColors.primary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  );
}

Widget _projectImage(ProjectItem item, {BoxFit fit = BoxFit.cover}) {
  if (!_hasImage(item)) return _projectPlaceholder(item);

  if (_usesAssetImage(item)) {
    return Image.asset(
      item.imageUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => _projectPlaceholder(item),
    );
  }

  return Image.network(
    item.imageUrl,
    fit: fit,
    width: double.infinity,
    height: double.infinity,
    errorBuilder: (context, error, stackTrace) => _projectPlaceholder(item),
  );
}

Widget _projectPreview(ProjectItem item, {double? height, required bool hovered}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 220),
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: hovered
            ? AppColors.primary
            : Colors.white.withValues(alpha: 0.18),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: hovered ? 0.35 : 0.2),
          blurRadius: hovered ? 40 : 28,
          offset: const Offset(0, 18),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox.expand(child: _projectImage(item)),
    ),
  );
}

Widget _projectTechTag(String tech) {
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

Widget _projectLinks(BuildContext context, ProjectItem item) {
  return Wrap(
    spacing: 12,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      if (item.githubLink.isNotEmpty)
        _ProjectIconButton(
          icon: FontAwesomeIcons.github,
          onPressed: () => _launchExternalUrl(item.githubLink),
        ),
      if (item.externalLink.isNotEmpty)
        _ProjectIconButton(
          icon: FontAwesomeIcons.upRightFromSquare,
          onPressed: () => _launchExternalUrl(item.externalLink),
        ),
      FilledButton.icon(
        onPressed: item.androidDownloadLink.trim().isNotEmpty
            ? () => _launchExternalUrl(item.androidDownloadLink)
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
          item.androidDownloadLink.trim().isNotEmpty ? 'Android App' : 'Android Soon',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      FilledButton.icon(
        onPressed: item.iosDownloadLink.trim().isNotEmpty
            ? () => _launchExternalUrl(item.iosDownloadLink)
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
          item.iosDownloadLink.trim().isNotEmpty ? 'iOS App' : 'iOS Coming Soon',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      TextButton(
        onPressed: _hasProjectDetail(item)
            ? () => context.go('/project/${item.id}')
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

// ---- Carousel card ----------------------------------------------------------

class _ProjectCard extends StatefulWidget {
  final ProjectItem item;
  final String projectType;
  final bool isMobile;

  const _ProjectCard({
    required this.item,
    required this.projectType,
    required this.isMobile,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final maxTags = widget.isMobile ? 4 : 8;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: _hasProjectDetail(item)
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: _hasProjectDetail(item)
            ? () => context.go('/project/${item.id}')
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
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
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _projectPreview(item, height: 180, hovered: isHovered),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.projectType,
                      style: GoogleFonts.outfit(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.description,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: item.techStack
                          .take(maxTags)
                          .map(_projectTechTag)
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    _projectLinks(context, item),
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