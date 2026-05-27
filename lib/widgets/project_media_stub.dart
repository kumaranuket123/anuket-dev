import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProjectMediaHero extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const ProjectMediaHero({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
  });

  static bool isVideoUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('youtube.com/watch') ||
        lower.contains('youtu.be/') ||
        lower.contains('vimeo.com') ||
        lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov');
  }

  Widget _errorWidget() => Container(
        width: width,
        height: height,
        color: AppColors.surface,
        alignment: Alignment.center,
        child: const Text(
          'Media Unavailable',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (isVideoUrl(url)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          color: Colors.black,
          alignment: Alignment.center,
          child: const Icon(
            Icons.play_circle_outline,
            color: Colors.white54,
            size: 64,
          ),
        ),
      );
    }

    final image = url.startsWith('http')
        ? Image.network(url, width: width, height: height, fit: fit,
            errorBuilder: (_, _, _) => _errorWidget())
        : Image.asset(url, width: width, height: height, fit: fit,
            errorBuilder: (_, _, _) => _errorWidget());

    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      );
    }
    return image;
  }
}
