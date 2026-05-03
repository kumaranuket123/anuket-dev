import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/contact_section.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  Future<PortfolioData>? _portfolioDataFuture;
  String? _resumeLink;

  @override
  void initState() {
    super.initState();
    _portfolioDataFuture = _loadPortfolioData();
    _portfolioDataFuture?.then((data) {
      setState(() => _resumeLink = data.hero.resumeLink);
    });
  }

  Future<PortfolioData> _loadPortfolioData() async {
    final String jsonString = await rootBundle.loadString('assets/data/portfolio_data.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    return PortfolioData.fromJson(jsonResponse);
  }

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.92),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        title: const _GradientLogoText(),
        actions: isMobile
            ? []
            : [
                _NavBarItem(index: 0, title: 'Home', onTap: () => _scrollToSection(_homeKey)),
                _NavBarItem(index: 1, title: 'About', onTap: () => _scrollToSection(_aboutKey)),
                _NavBarItem(index: 2, title: 'Work', onTap: () => _scrollToSection(_projectsKey)),
                _NavBarItem(index: 3, title: 'Contact', onTap: () => _scrollToSection(_contactKey)),
                const SizedBox(width: 20),
                _ResumeButton(url: _resumeLink ?? ''),
                const SizedBox(width: 20),
              ],
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppColors.surface,
              child: Column(
                children: [
                  const _DrawerTerminalHeader(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        _DrawerItem(index: 0, title: 'Home', onTap: () {
                          Navigator.pop(context);
                          _scrollToSection(_homeKey);
                        }),
                        _DrawerItem(index: 1, title: 'About', onTap: () {
                          Navigator.pop(context);
                          _scrollToSection(_aboutKey);
                        }),
                        _DrawerItem(index: 2, title: 'Work', onTap: () {
                          Navigator.pop(context);
                          _scrollToSection(_projectsKey);
                        }),
                        _DrawerItem(index: 3, title: 'Contact', onTap: () {
                          Navigator.pop(context);
                          _scrollToSection(_contactKey);
                        }),
                        const SizedBox(height: 20),
                        _ResumeButton(url: _resumeLink ?? ''),
                      ],
                    ),
                  ),
                  const _DrawerFooter(),
                ],
              ),
            )
          : null,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _GridBackground(),
          ),
          FutureBuilder<PortfolioData>(
            future: _portfolioDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading data.',
                    style: GoogleFonts.inter(color: Colors.red),
                  ),
                );
              }

              final data = snapshot.data!;

              return SingleChildScrollView(
                controller: _scrollController,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      children: [
                        HeroSection(
                          key: _homeKey,
                          data: data.hero,
                          onWorkTap: () => _scrollToSection(_projectsKey),
                        ),
                        AboutSection(key: _aboutKey, data: data.about),
                        ProjectsSection(key: _projectsKey, data: data.projects),
                        ContactSection(key: _contactKey, data: data.contact),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Gradient logo with monospace font
class _GradientLogoText extends StatelessWidget {
  const _GradientLogoText();

  static const _gradient = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static final _style = GoogleFonts.firaCode(fontWeight: FontWeight.w700, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => _gradient.createShader(bounds),
      child: Text('>_ anuket', style: _style),
    );
  }
}

// Navigation bar item with numbered prefix
class _NavBarItem extends StatefulWidget {
  final int index;
  final String title;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.index,
    required this.title,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  static final _numberStyle = GoogleFonts.firaCode(
    color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600);
  static final _titleStyle = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w500);

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hasNumber = widget.index > 0 && widget.index < 3;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasNumber) ...[
                Text(
                  '${widget.index.toString().padLeft(2, '0')}.',
                  style: _numberStyle,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.title,
                style: _titleStyle.copyWith(
                  color: _isHovered ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Resume button with terminal command styling
class _ResumeButton extends StatelessWidget {
  final String url;
  const _ResumeButton({this.url = ''});

  Future<void> _launchResume() async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: url.isNotEmpty ? _launchResume : null,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: url.isNotEmpty ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
      child: Text(
        '[resume.sh]',
        style: GoogleFonts.firaCode(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// Drawer header with terminal styling
class _DrawerTerminalHeader extends StatelessWidget {
  const _DrawerTerminalHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              _Dot(color: Color(0xFFFF5F57)),
              SizedBox(width: 6),
              _Dot(color: Color(0xFFFFBD2E)),
              SizedBox(width: 6),
              _Dot(color: Color(0xFF28C840)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '// navigation',
            style: GoogleFonts.firaCode(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// Traffic light dots
class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// Drawer item with terminal prompt
class _DrawerItem extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.index,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasNumber = index > 0 && index < 3;
    final prefix = hasNumber ? '${index.toString().padLeft(2, '0')}. ' : '';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Row(
          children: [
            if (hasNumber)
              Text(
                prefix,
                style: GoogleFonts.firaCode(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            Text(
              title,
              style: GoogleFonts.firaCode(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Drawer footer with status line
class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        '~  [4 sections loaded]',
        style: GoogleFonts.firaCode(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          fontSize: 11,
        ),
      ),
    );
  }
}

// Background grid
class _GridBackground extends StatelessWidget {
  const _GridBackground();

  static final _painter = _GridPainter();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _painter, isComplex: true, willChange: false);
  }
}

// Grid painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F2FE).withOpacity(0.030)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}
