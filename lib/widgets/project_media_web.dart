// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProjectMediaHero extends StatefulWidget {
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
        lower.contains('youtube.com/shorts') ||
        lower.contains('youtu.be/') ||
        lower.contains('vimeo.com') ||
        lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov');
  }

  static bool _isDirectVideo(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov');
  }

  @override
  State<ProjectMediaHero> createState() => _ProjectMediaHeroState();
}

class _ProjectMediaHeroState extends State<ProjectMediaHero> {
  static int _counter = 0;
  late final String _viewId;
  late final bool _isVideo;

  @override
  void initState() {
    super.initState();
    _isVideo = ProjectMediaHero.isVideoUrl(widget.url);
    if (_isVideo) {
      _viewId = 'project_media_${_counter++}';
      final radius = '${widget.borderRadius.toInt()}px';
      // ignore: deprecated_member_use
      ui.platformViewRegistry.registerViewFactory(_viewId, (int id) {
        if (ProjectMediaHero._isDirectVideo(widget.url)) {
          // Native <video> for MP4/WebM/MOV — autoplay + loop for demo showcase
          // ignore: deprecated_member_use
          return html.VideoElement()
            ..src = widget.url
            ..autoplay = true
            ..loop = true
            ..muted = true
            ..controls = true
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = 'cover'
            ..style.borderRadius = radius
            ..style.background = '#0B0F19';
        }
        // iframe for YouTube / Vimeo embeds
        final embedUrl = _toEmbedUrl(widget.url);
        // ignore: deprecated_member_use
        return html.IFrameElement()
          ..src = embedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = radius
          ..setAttribute('allowfullscreen', 'true')
          ..setAttribute('allow', 'autoplay; fullscreen; picture-in-picture');
      });
    }
  }

  static String _toEmbedUrl(String url) {
    if (url.contains('youtube.com/watch')) {
      final uri = Uri.parse(url);
      final videoId = uri.queryParameters['v'];
      if (videoId != null) return 'https://www.youtube.com/embed/$videoId';
    }
    if (url.contains('youtube.com/shorts/')) {
      final videoId = url.split('youtube.com/shorts/').last.split('?').first;
      return 'https://www.youtube.com/embed/$videoId';
    }
    if (url.contains('youtu.be/')) {
      final videoId = url.split('youtu.be/').last.split('?').first;
      return 'https://www.youtube.com/embed/$videoId';
    }
    if (url.contains('vimeo.com/')) {
      final videoId = url.split('vimeo.com/').last.split('?').first;
      return 'https://player.vimeo.com/video/$videoId';
    }
    return url;
  }

  Widget _errorWidget() => Container(
        width: widget.width,
        height: widget.height,
        color: AppColors.surface,
        alignment: Alignment.center,
        child: const Text(
          'Media Unavailable',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_isVideo) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: HtmlElementView(viewType: _viewId),
      );
    }

    final image = widget.url.startsWith('http')
        ? Image.network(widget.url,
            width: widget.width, height: widget.height, fit: widget.fit,
            errorBuilder: (_, _, _) => _errorWidget())
        : Image.asset(widget.url,
            width: widget.width, height: widget.height, fit: widget.fit,
            errorBuilder: (_, _, _) => _errorWidget());

    if (widget.borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: image,
      );
    }
    return image;
  }
}
