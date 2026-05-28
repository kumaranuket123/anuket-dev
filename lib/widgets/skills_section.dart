import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class SkillsSection extends StatelessWidget {
  final SkillsData data;

  const SkillsSection({required this.data, super.key});

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
            '02. Skills',
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
              data.subtitle,
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
          _SkillsGrid(categories: data.categories, isMobile: isMobile),
        ],
      ),
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  final List<SkillCategory> categories;
  final bool isMobile;

  const _SkillsGrid({required this.categories, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;
    final columns = isMobile ? 1 : (Responsive.isTablet(context) ? 2 : 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(categories.length, (index) {
            return SizedBox(
              width: cardWidth,
              child: _CategoryCard(
                category: categories[index],
                index: index,
              ),
            );
          }),
        );
      },
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final SkillCategory category;
  final int index;

  const _CategoryCard({required this.category, required this.index});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    // Stagger the entrance animation
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'code':
        return Icons.code_rounded;
      case 'layers':
        return Icons.layers_rounded;
      case 'architecture':
        return Icons.account_tree_rounded;
      case 'storage':
        return Icons.storage_rounded;
      case 'wifi':
        return Icons.wifi_tethering_rounded;
      case 'palette':
        return Icons.palette_rounded;
      case 'build':
        return Icons.build_circle_rounded;
      default:
        return Icons.code_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _resolveIcon(widget.category.icon);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.surface.withValues(alpha: 0.9)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.surface,
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: icon + category name
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.category.name,
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Skill items with progress bars
              ...widget.category.items
                  .map((item) => _SkillBar(item: item, isHovered: _isHovered)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillBar extends StatefulWidget {
  final SkillItem item;
  final bool isHovered;

  const _SkillBar({required this.item, required this.isHovered});

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _barController;
  late Animation<double> _barAnimation;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _barAnimation = Tween<double>(begin: 0.0, end: widget.item.level / 100.0)
        .animate(CurvedAnimation(
      parent: _barController,
      curve: Curves.easeOutCubic,
    ));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _barController.forward();
    });
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.item.name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: widget.isHovered
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _barAnimation,
                builder: (context, child) {
                  return Text(
                    '${(_barAnimation.value * 100).round()}%',
                    style: GoogleFonts.firaCode(
                      color: AppColors.primary.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: AnimatedBuilder(
                animation: _barAnimation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Background track
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      // Filled portion with gradient
                      FractionallySizedBox(
                        widthFactor: _barAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.secondary,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
