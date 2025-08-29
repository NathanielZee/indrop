import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityTabWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const ActivityTabWidget({
    Key? key,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Activity timeline
          ...(activities as List).asMap().entries.map<Widget>((entry) {
            final index = entry.key;
            final activity = entry.value as Map<String, dynamic>;
            final isLast = index == activities.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline indicator
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getActivityColor(activity['type'] as String),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 8.h,
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                  ],
                ),
                SizedBox(width: 3.w),

                // Activity content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 2.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName:
                                  _getActivityIcon(activity['type'] as String),
                              color:
                                  _getActivityColor(activity['type'] as String),
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                activity['title'] as String,
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          activity['description'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activity['date'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (activity['status'] != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                          activity['status'] as String)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  activity['status'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: _getStatusColor(
                                        activity['status'] as String),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'application':
        return 'send';
      case 'profile_view':
        return 'visibility';
      case 'achievement':
        return 'emoji_events';
      case 'skill_update':
        return 'school';
      case 'resume_update':
        return 'description';
      default:
        return 'info';
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'application':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'profile_view':
        return Colors.green;
      case 'achievement':
        return Colors.orange;
      case 'skill_update':
        return Colors.purple;
      case 'resume_update':
        return Colors.blue;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'completed':
        return Colors.green;
      case 'pending':
      case 'in progress':
        return Colors.orange;
      case 'rejected':
      case 'failed':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
