import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../widgets/image_viewer.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Future<ProjectItem?>? _projectFuture;
  ProjectItem? _project;

  @override
  void initState() {
    super.initState();
    _projectFuture = _loadProject();
    _projectFuture?.then((item) {
      if (mounted) setState(() => _project = item);
    });
  }

  Future<ProjectItem?> _loadProject() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/portfolio_data.json',
    );
    final portfolioData = PortfolioData.fromJson(json.decode(jsonString));

    final all = [
      ...portfolioData.projects.clientProjects,
      ...portfolioData.projects.personalProjects,
    ];
    try {
      return all.firstWhere((p) => p.id == widget.projectId);
    } catch (_) {
      return null;
    }
  }

  void _launchUrl(String url) async {
    if (url.isEmpty) return;
    await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: _project != null
            ? Text(
                _project!.title,
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const SizedBox.shrink(),
      ),
      body: FutureBuilder<ProjectItem?>(
        future: _projectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          final item = snapshot.data;
          if (item == null) {
            return Center(
              child: Text(
                'Project not found.',
                style: GoogleFonts.inter(color: Colors.red),
              ),
            );
          }

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 40,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _ProjectImage(
                          path: item.imageUrl,
                          width: double.infinity,
                          height: isMobile ? 350 : 500,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Header and Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.outfit(
                                color: AppColors.textPrimary,
                                fontSize: isMobile ? 32 : 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.android_rounded, size: 28),
                                color: item.androidDownloadLink.isNotEmpty
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                onPressed: item.androidDownloadLink.isNotEmpty
                                    ? () => _launchUrl(item.androidDownloadLink)
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.phone_iphone_rounded, size: 28),
                                color: item.iosDownloadLink.isNotEmpty
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                onPressed: item.iosDownloadLink.isNotEmpty
                                    ? () => _launchUrl(item.iosDownloadLink)
                                    : null,
                              ),
                              if (item.githubLink.isNotEmpty)
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.github, size: 28),
                                  color: AppColors.textPrimary,
                                  onPressed: () => _launchUrl(item.githubLink),
                                ),
                              if (item.externalLink.isNotEmpty)
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.upRightFromSquare, size: 28),
                                  color: AppColors.textPrimary,
                                  onPressed: () => _launchUrl(item.externalLink),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tech Stack
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: item.techStack.map((tech) => _TechBadge(tech: tech)).toList(),
                      ),
                      const SizedBox(height: 40),

                      // Full Description
                      Text(
                        "About The Project",
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.fullDescription.isNotEmpty ? item.fullDescription : item.description,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 18,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 40),

                      FilledButton.icon(
                        onPressed: item.androidDownloadLink.isNotEmpty
                            ? () => _launchUrl(item.androidDownloadLink)
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                          disabledBackgroundColor: AppColors.surface,
                          disabledForegroundColor: AppColors.textSecondary,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.android_rounded),
                        label: Text(
                          item.androidDownloadLink.isNotEmpty
                              ? 'Download for Android'
                              : 'Android Coming Soon',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: item.iosDownloadLink.isNotEmpty
                            ? () => _launchUrl(item.iosDownloadLink)
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.textPrimary,
                          disabledBackgroundColor: AppColors.surface,
                          disabledForegroundColor: AppColors.textSecondary,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: AppColors.textSecondary),
                          ),
                        ),
                        icon: const Icon(Icons.phone_iphone_rounded),
                        label: Text(
                          item.iosDownloadLink.isNotEmpty ? 'Download for iOS' : 'iOS Coming Soon',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 40),

                      if (item.userHighlights.isNotEmpty) ...[
                        _HighlightsSection(title: 'For Users', items: item.userHighlights),
                        const SizedBox(height: 40),
                      ],

                      if (item.developerHighlights.isNotEmpty) ...[
                        _HighlightsSection(title: 'For Developers', items: item.developerHighlights),
                        const SizedBox(height: 40),
                      ],

                      if (item.features.isNotEmpty) ...[
                        _HighlightsSection(title: 'Key Features', items: item.features),
                        const SizedBox(height: 40),
                      ],

                      // Gallery — Wrap replaces GridView(shrinkWrap:true) to avoid measuring all items upfront
                      if (item.screenshots.isNotEmpty) ...[
                        Text(
                          "Gallery",
                          style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final itemWidth = isMobile
                                ? constraints.maxWidth
                                : (constraints.maxWidth - 20) / 2;
                            final itemHeight = itemWidth * (16 / 9);
                            return Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: List.generate(item.screenshots.length, (index) {
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => ImageViewer(
                                          images: item.screenshots,
                                          initialIndex: index,
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _ProjectImage(
                                        path: item.screenshots[index],
                                        width: itemWidth,
                                        height: itemHeight,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                        const SizedBox(height: 60),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Extracted as widget so Flutter can skip rebuilds when path/size unchanged
class _ProjectImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const _ProjectImage({
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.fitHeight,
  });

  static const _errorStyle = TextStyle(color: AppColors.textSecondary);

  Widget _errorWidget(double? w, double? h) => Container(
        width: w,
        height: h,
        color: AppColors.surface,
        alignment: Alignment.center,
        child: const Text('Image Unavailable', style: _errorStyle),
      );

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _errorWidget(width, height),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _errorWidget(width, height),
    );
  }
}

// Extracted to StatelessWidget — Flutter skips rebuild when title/items unchanged
class _HighlightsSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _HighlightsSection({required this.title, required this.items});

  static final _titleStyle = GoogleFonts.outfit(
    color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w600);
  static final _itemStyle = GoogleFonts.inter(
    color: AppColors.textSecondary, fontSize: 18, height: 1.5);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _titleStyle),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4, right: 12),
                  child: Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                ),
                Expanded(child: Text(item, style: _itemStyle)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Tech badge chip
class _TechBadge extends StatelessWidget {
  final String tech;

  const _TechBadge({required this.tech});

  static final _style = GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w500);
  static final _decoration = BoxDecoration(
    color: AppColors.primary.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _decoration,
      child: Text(tech, style: _style),
    );
  }
}
