import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class HeroSection extends StatelessWidget {
  final HeroData data;

  const HeroSection({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      constraints: BoxConstraints(minHeight: isMobile ? 0 : 680),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: isMobile ? 40 : 80,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroVisual(data: data),
                const SizedBox(height: 28),
                _HeroText(data: data),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: _HeroText(data: data)),
                const SizedBox(width: 48),
                Expanded(flex: 5, child: _HeroVisual(data: data)),
              ],
            ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final HeroData data;

  const _HeroText({required this.data});

  Future<void> _launchResume() async {
    if (data.resumeLink.isEmpty) return;

    final uri = Uri.parse(data.resumeLink);
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Text(
          data.greeting,
          style: GoogleFonts.outfit(
            color: AppColors.primary,
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
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
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            FilledButton(
              onPressed: _launchResume,
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
    );
  }
}

class _HeroVisual extends StatelessWidget {
  final HeroData data;

  const _HeroVisual({required this.data});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 20),
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
              'Building mobile and web products',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: isMobile ? 1 : 0.86,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.22),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: const _HeroFallback(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.code_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const Spacer(),
          Text(
            'Building reliable Flutter products for mobile and web.',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Clean architecture, thoughtful UX, and practical execution from idea to shipped product.',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
