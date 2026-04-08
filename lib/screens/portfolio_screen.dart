import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    _portfolioDataFuture = _loadPortfolioData();
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
        backgroundColor: AppColors.background.withOpacity(0.9),
        elevation: 0,
        title: Text(
          '<Anuket />',
          style: GoogleFonts.outfit(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: isMobile
            ? []
            : [
                _NavBarItem(title: 'Home', onTap: () => _scrollToSection(_homeKey)),
                _NavBarItem(title: 'About', onTap: () => _scrollToSection(_aboutKey)),
                _NavBarItem(title: 'Work', onTap: () => _scrollToSection(_projectsKey)),
                _NavBarItem(title: 'Contact', onTap: () => _scrollToSection(_contactKey)),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text('Resume', style: GoogleFonts.inter()),
                  ),
                ),
                const SizedBox(width: 20),
              ],
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppColors.surface,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 50),
                  _DrawerItem(title: 'Home', onTap: () {
                    Navigator.pop(context);
                    _scrollToSection(_homeKey);
                  }),
                  _DrawerItem(title: 'About', onTap: () {
                    Navigator.pop(context);
                    _scrollToSection(_aboutKey);
                  }),
                  _DrawerItem(title: 'Work', onTap: () {
                    Navigator.pop(context);
                    _scrollToSection(_projectsKey);
                  }),
                  _DrawerItem(title: 'Contact', onTap: () {
                    Navigator.pop(context);
                    _scrollToSection(_contactKey);
                  }),
                ],
              ),
            )
          : null,
      body: FutureBuilder<PortfolioData>(
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
                    Container(key: _homeKey, child: HeroSection(data: data.hero)),
                    Container(key: _aboutKey, child: AboutSection(data: data.about)),
                    Container(key: _projectsKey, child: ProjectsSection(data: data.projects)),
                    Container(key: _contactKey, child: ContactSection(data: data.contact)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavBarItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
