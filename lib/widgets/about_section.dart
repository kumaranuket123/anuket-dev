import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class AboutSection extends StatelessWidget {
  final AboutData data;

  const AboutSection({required this.data, super.key});

  bool _usesAssetImage(String value) => value.startsWith('assets/');

  Widget _buildProfileVisual() {
    if (_usesAssetImage(data.profileIcon)) {
      return Image.asset(
        data.profileIcon,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              _getIconData(data.profileIcon),
              size: 80,
              color: AppColors.primary,
            ),
          );
        },
      );
    }

    return Center(
      child: Icon(
        _getIconData(data.profileIcon),
        size: 80,
        color: AppColors.primary,
      ),
    );
  }

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
            '01. About Me',
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
              'I build production-ready Flutter experiences with clean architecture, thoughtful UI, and the pragmatism needed to ship consistently.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(height: 1, color: AppColors.surface),
          const SizedBox(height: 40),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AboutProfileCard(image: _buildProfileVisual()),
                    const SizedBox(height: 24),
                    _AboutCopyCard(data: data),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _AboutCopyCard(data: data)),
                    // const SizedBox(width: 36),
                    // Expanded(
                    //   flex: 2,
                    //   child: _AboutProfileCard(image: _buildProfileVisual()),
                    // ),
                  ],
                ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'computer':
        return Icons.computer;
      default:
        return Icons.person;
    }
  }
}

class _AboutCopyCard extends StatelessWidget {
  final AboutData data;

  const _AboutCopyCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.surface),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              'Flutter Engineer',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description1,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 17,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            data.description2,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 17,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Core Strengths',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: data.skills
                .map((skill) => _TechChip(name: skill))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AboutProfileCard extends StatelessWidget {
  final Widget image;

  const _AboutProfileCard({required this.image});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.surface),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Based in India',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: isMobile ? 320 : 420,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: image,
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String name;

  const _TechChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: Icon(Icons.arrow_outward, color: AppColors.primary, size: 14),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
