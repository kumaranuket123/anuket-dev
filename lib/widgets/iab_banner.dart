import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../utils/browser_utils.dart';

class IabBanner extends StatefulWidget {
  const IabBanner({super.key});

  @override
  State<IabBanner> createState() => _IabBannerState();
}

class _IabBannerState extends State<IabBanner> {
  late final bool _show;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _show = isInAppBrowser();
  }

  @override
  Widget build(BuildContext context) {
    if (!_show || _dismissed) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFF0D1117),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Best viewed in Chrome or Safari — tap ··· to open in browser',
              style: GoogleFonts.firaCode(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _dismissed = true),
            child: const Icon(Icons.close, color: AppColors.textSecondary, size: 16),
          ),
        ],
      ),
    );
  }
}
