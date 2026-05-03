import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class HeroSection extends StatelessWidget {
  final HeroData data;
  final VoidCallback? onWorkTap;

  const HeroSection({required this.data, this.onWorkTap, super.key});

  static final _badgeStyle = GoogleFonts.inter(
    color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600);
  static final _descStyle = GoogleFonts.inter(
    color: AppColors.textSecondary, fontSize: 16, height: 1.8);
  static final _locationStyle = GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.24),
              ),
            ),
            child: Text(
              'Flutter Developer • Available for work',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Greeting
          Text(
            data.greeting,
            style: GoogleFonts.outfit(
              color: AppColors.primary,
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          // Name
          Text(
            data.name,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: isMobile ? 42 : 72,
              fontWeight: FontWeight.bold,
              height: 0.98,
            ),
          ),
          const SizedBox(height: 12),

          // Role
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              data.role,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 26 : 48,
                fontWeight: FontWeight.w600,
                height: 1.05,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Description
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              data.description,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Action buttons
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              FilledButton(
                onPressed: onWorkTap,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  data.buttonText,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Based in Jaipur, India',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
