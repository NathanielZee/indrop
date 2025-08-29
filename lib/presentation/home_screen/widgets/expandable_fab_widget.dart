import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpandableFabWidget extends StatefulWidget {
  final VoidCallback onCreateResume;
  final VoidCallback onUploadResume;
  final VoidCallback onFindJobs;
  final VoidCallback onAIAdvice;

  const ExpandableFabWidget({
    Key? key,
    required this.onCreateResume,
    required this.onUploadResume,
    required this.onFindJobs,
    required this.onAIAdvice,
  }) : super(key: key);

  @override
  State<ExpandableFabWidget> createState() => _ExpandableFabWidgetState();
}

class _ExpandableFabWidgetState extends State<ExpandableFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Widget _buildFabOption({
    required String label,
    required String iconName,
    required VoidCallback onTap,
    required double offset,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -offset * _expandAnimation.value),
          child: Opacity(
            opacity: _expandAnimation.value,
            child: ScaleTransition(
              scale: _expandAnimation,
              child: Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        label,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: FloatingActionButton(
                        heroTag: label,
                        mini: true,
                        elevation: 4,
                        onPressed: () {
                          _toggleExpansion();
                          onTap();
                        },
                        backgroundColor: color,
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildFabOption(
          label: 'AI Career Advice',
          iconName: 'psychology',
          onTap: widget.onAIAdvice,
          offset: 70,
          color: const Color(0xFF8B5CF6), // Purple for AI
        ),
        _buildFabOption(
          label: 'Find Jobs',
          iconName: 'search',
          onTap: widget.onFindJobs,
          offset: 140,
          color: const Color(0xFF10B981), // Green for search
        ),
        _buildFabOption(
          label: 'Upload Resume',
          iconName: 'cloud_upload',
          onTap: widget.onUploadResume,
          offset: 210,
          color: const Color(0xFF3B82F6), // Blue for upload
        ),
        _buildFabOption(
          label: 'Create Resume',
          iconName: 'description',
          onTap: widget.onCreateResume,
          offset: 280,
          color: const Color(0xFFEF4444), // Red for create
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), // More rounded
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: _toggleExpansion,
                  elevation: 6,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  child: Transform.rotate(
                    angle: _rotateAnimation.value *
                        0.25 *
                        3.14159, // 45 degrees rotation
                    child: CustomIconWidget(
                      iconName: _isExpanded
                          ? 'close'
                          : 'edit', // Changed from 'add' to 'edit' (pencil icon)
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
