import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class JobDescriptionWidget extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const JobDescriptionWidget({
    Key? key,
    required this.jobData,
  }) : super(key: key);

  @override
  State<JobDescriptionWidget> createState() => _JobDescriptionWidgetState();
}

class _JobDescriptionWidgetState extends State<JobDescriptionWidget> {
  bool _isDescriptionExpanded = false;
  bool _isRequirementsExpanded = false;
  bool _isBenefitsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildExpandableSection(
          title: 'Job Description',
          content: widget.jobData['description'] as String? ??
              'No description available',
          isExpanded: _isDescriptionExpanded,
          onToggle: () =>
              setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
        ),
        SizedBox(height: 2.h),
        _buildExpandableSection(
          title: 'Requirements',
          content: widget.jobData['requirements'] as String? ??
              'No requirements listed',
          isExpanded: _isRequirementsExpanded,
          onToggle: () => setState(
              () => _isRequirementsExpanded = !_isRequirementsExpanded),
        ),
        SizedBox(height: 2.h),
        _buildExpandableSection(
          title: 'Benefits',
          content:
              widget.jobData['benefits'] as String? ?? 'No benefits listed',
          isExpanded: _isBenefitsExpanded,
          onToggle: () =>
              setState(() => _isBenefitsExpanded = !_isBenefitsExpanded),
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String content,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded
                        ? 'keyboard_arrow_up'
                        : 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          isExpanded
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                  child: Text(
                    content,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
