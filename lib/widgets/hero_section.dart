import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../models/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  final HeroData data;
  const HeroSection({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    
    return Container(
      constraints: const BoxConstraints(minHeight: 600),
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 100, vertical: 80),
      child: Center(
        child: isMobile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _ProfileAvatar(),
                  const SizedBox(height: 40),
                  _HeroText(data: data),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _HeroText(data: data)),
                  const SizedBox(width: 40),
                  const _ProfileAvatar(),
                ],
              ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final HeroData data;
  const _HeroText({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          data.greeting,
          style: GoogleFonts.outfit(
            color: AppColors.primary,
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.name,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: isMobile ? 50 : 70,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.role,
          style: GoogleFonts.outfit(
            color: AppColors.textSecondary,
            fontSize: isMobile ? 30 : 50,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          data.description,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () async {
            final uri = Uri.parse(data.resumeLink);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            data.buttonText,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    double size = Responsive.isMobile(context) ? 250 : 400;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 100,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
