import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../models/portfolio_data.dart';

class ProjectsSection extends StatelessWidget {
  final ProjectsData data;
  const ProjectsSection({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 100, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "02. ",
                style: GoogleFonts.outfit(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                data.sectionTitle,
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.surface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          
          if (data.clientProjects.isNotEmpty) ...[
            Text(
              data.clientProjectsTitle,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            ...data.clientProjects.asMap().entries.map((entry) {
              int index = entry.key;
              ProjectItem item = entry.value;
              return Column(
                children: [
                  _ProjectFeatured(
                    item: item,
                    isReversed: index % 2 != 0,
                    projectType: "Client Project",
                  ),
                  if (index < data.clientProjects.length - 1 || data.personalProjects.isNotEmpty)
                    const SizedBox(height: 100),
                ],
              );
            }).toList(),
          ],

          if (data.personalProjects.isNotEmpty) ...[
            Text(
              data.personalProjectsTitle,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            ...data.personalProjects.asMap().entries.map((entry) {
              int index = entry.key;
              ProjectItem item = entry.value;
              return Column(
                children: [
                  _ProjectFeatured(
                    item: item,
                    isReversed: index % 2 != 0, // Keeps alternating layout
                    projectType: "Personal Showcase",
                  ),
                  if (index < data.personalProjects.length - 1)
                    const SizedBox(height: 100),
                ],
              );
            }).toList(),
          ],
        ],
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
    super.key,
  });

  @override
  State<_ProjectFeatured> createState() => _ProjectFeaturedState();
}

class _ProjectFeaturedState extends State<_ProjectFeatured> {
  bool isHovered = false;

  void _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      // Mobile Layout: Card based
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.projectType,
              style: GoogleFonts.outfit(
                color: AppColors.primary,
                fontSize: 14,
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
            const SizedBox(height: 20),
            Text(
              widget.item.description,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.item.techStack
                  .map((tech) => Text(
                        tech,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.item.githubLink.isNotEmpty)
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.github, color: AppColors.textPrimary),
                    onPressed: () => _launchUrl(widget.item.githubLink),
                  ),
                if (widget.item.externalLink.isNotEmpty)
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.upRightFromSquare, color: AppColors.textPrimary),
                    onPressed: () => _launchUrl(widget.item.externalLink),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/project/${widget.item.id}'),
                  child: Text(
                    'Read Case Study', 
                    style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    // Desktop Layout
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // Image / Demo section
          Positioned(
            left: widget.isReversed ? null : 0,
            right: widget.isReversed ? 0 : null,
            child: MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width * 0.5,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(widget.item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isHovered
                        ? Colors.transparent
                        : AppColors.primary.withOpacity(0.5), // Tint effect
                  ),
                ),
              ),
            ),
          ),
          
          // Details section
          Positioned(
            right: widget.isReversed ? null : 0,
            left: widget.isReversed ? 0 : null,
            top: 40,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: widget.isReversed
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.projectType,
                    style: GoogleFonts.outfit(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item.title,
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.item.description,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.6,
                      ),
                      textAlign: widget.isReversed ? TextAlign.left : TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    children: widget.item.techStack
                        .map((tech) => Text(
                              tech,
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: widget.isReversed
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (widget.item.githubLink.isNotEmpty)
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.github, color: AppColors.textPrimary),
                          onPressed: () => _launchUrl(widget.item.githubLink),
                        ),
                      if (widget.item.externalLink.isNotEmpty)
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.upRightFromSquare, color: AppColors.textPrimary),
                          onPressed: () => _launchUrl(widget.item.externalLink),
                        ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () => context.go('/project/${widget.item.id}'),
                        child: Text(
                          'Read Case Study', 
                          style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
