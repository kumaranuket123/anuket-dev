import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../models/portfolio_data.dart';

class AboutSection extends StatelessWidget {
  final AboutData data;
  const AboutSection({required this.data, super.key});

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
                "01. ",
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
          const SizedBox(height: 40),
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isMobile ? 0 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.description1,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      data.description2,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: data.skills.map((skill) => _TechChip(name: skill)).toList(),
                    ),
                  ],
                ),
              ),
              if (!isMobile) const SizedBox(width: 50),
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    height: 300,
                    // Typically an image of the user goes here.
                    child: Center(
                      child: Icon(
                        _getIconData(data.profileIcon),
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
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

class _TechChip extends StatelessWidget {
  final String name;
  const _TechChip({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_right, color: AppColors.primary, size: 16),
          const SizedBox(width: 4),
          Text(
            name,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
