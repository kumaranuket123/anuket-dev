import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Future<ProjectItem?>? _projectFuture;

  @override
  void initState() {
    super.initState();
    _projectFuture = _loadProject();
  }

  Future<ProjectItem?> _loadProject() async {
    final String jsonString = await rootBundle.loadString('assets/data/portfolio_data.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    final portfolioData = PortfolioData.fromJson(jsonResponse);
    
    try {
      return portfolioData.projects.clientProjects.firstWhere((p) => p.id == widget.projectId);
    } catch (_) {}
    
    try {
      return portfolioData.projects.personalProjects.firstWhere((p) => p.id == widget.projectId);
    } catch (_) {}
    
    return null;
  }

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
        title: FutureBuilder<ProjectItem?>(
          future: _projectFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Text(
                snapshot.data!.title,
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      body: FutureBuilder<ProjectItem?>(
        future: _projectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Project not found.',
                style: GoogleFonts.inter(color: Colors.red),
              ),
            );
          }

          final item = snapshot.data!;

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
                        child: Image.network(
                          item.imageUrl,
                          width: double.infinity,
                          height: isMobile ? 250 : 500,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: isMobile ? 250 : 500,
                              color: AppColors.surface,
                              child: const Center(
                                child: Text('Image Unavailable', style: TextStyle(color: AppColors.textSecondary)),
                              ),
                            );
                          },
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
                        children: item.techStack
                            .map((tech) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    tech,
                                    style: GoogleFonts.inter(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
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

                      // Features Section
                      if (item.features.isNotEmpty) ...[
                        Text(
                          "Key Features",
                          style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...item.features.map((feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4.0, right: 12.0),
                                    child: Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                                  ),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: GoogleFonts.inter(
                                        color: AppColors.textSecondary,
                                        fontSize: 18,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 40),
                      ],

                      // Screenshots Array
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
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 16 / 9,
                          ),
                          itemCount: item.screenshots.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.screenshots[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.surface,
                                    child: const Center(
                                      child: Text('Image Unavailable', style: TextStyle(color: AppColors.textSecondary)),
                                    ),
                                  );
                                },
                              ),
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
