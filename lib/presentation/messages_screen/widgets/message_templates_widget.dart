import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageTemplatesWidget extends StatelessWidget {
  final Function(String) onTemplateSelected;

  const MessageTemplatesWidget({
    Key? key,
    required this.onTemplateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> templates = [
      {
        'title': 'Thank You',
        'message':
            'Thank you for considering my application. I look forward to hearing from you.',
        'icon': 'favorite',
      },
      {
        'title': 'Follow Up',
        'message':
            'I wanted to follow up on my application for the [Position] role. Is there any additional information you need?',
        'icon': 'schedule',
      },
      {
        'title': 'Interest',
        'message':
            'I\'m very interested in this opportunity and would love to discuss how my skills align with your needs.',
        'icon': 'star',
      },
      {
        'title': 'Availability',
        'message':
            'I\'m available for an interview at your convenience. Please let me know what works best for you.',
        'icon': 'calendar_today',
      },
      {
        'title': 'Questions',
        'message':
            'I have a few questions about the role and company culture. Would you be available for a brief call?',
        'icon': 'help_outline',
      },
      {
        'title': 'Portfolio',
        'message':
            'I\'d be happy to share my portfolio and recent work samples that demonstrate my relevant experience.',
        'icon': 'work',
      },
    ];

    return Container(
      height: 25.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Text(
              'Quick Templates',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return Container(
                  width: 70.w,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () =>
                          onTemplateSelected(template['message'] as String),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: template['icon'] as String,
                                    size: 20,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    template['title'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Expanded(
                              child: Text(
                                template['message'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => onTemplateSelected(
                                    template['message'] as String),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 1.h,
                                  ),
                                ),
                                child: Text(
                                  'Use Template',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
