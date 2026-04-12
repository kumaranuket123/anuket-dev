import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../models/portfolio_data.dart';

class ContactSection extends StatelessWidget {
  final ContactData data;
  const ContactSection({required this.data, super.key});

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: data.email,
      queryParameters: {'subject': data.subject},
    );
    await launchUrl(emailLaunchUri);
  }

  void _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            data.heading,
            style: GoogleFonts.outfit(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.title,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: isMobile ? 40 : 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 600,
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 18,
                height: 1.6,
              ),
            ),
          ),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _launchEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
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
              if (data.meetingLink.isNotEmpty)
                ElevatedButton(
                  onPressed: () => _launchUrl(data.meetingLink),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    data.meetingButtonText,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 100),
          // Footer Connect Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (data.socials.github.isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.github),
                  color: AppColors.textSecondary,
                  hoverColor: AppColors.primary,
                  onPressed: () => _launchUrl(data.socials.github),
                ),
              if (data.socials.github.isNotEmpty) const SizedBox(width: 20),
              if (data.socials.linkedin.isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedin),
                  color: AppColors.textSecondary,
                  hoverColor: AppColors.primary,
                  onPressed: () => _launchUrl(data.socials.linkedin),
                ),
              if (data.socials.linkedin.isNotEmpty) const SizedBox(width: 20),
              if (data.socials.twitter.isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.twitter),
                  color: AppColors.textSecondary,
                  hoverColor: AppColors.primary,
                  onPressed: () => _launchUrl(data.socials.twitter),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            data.footerText,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
