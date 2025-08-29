import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/application_bottom_sheet.dart';
import './widgets/company_info_widget.dart';
import './widgets/job_description_widget.dart';
import './widgets/job_header_widget.dart';
import './widgets/match_score_widget.dart';
import './widgets/similar_jobs_widget.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({Key? key}) : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isJobSaved = false;
  bool _isLoading = true;

  // Mock job data
  final Map<String, dynamic> _jobData = {
    "id": 1,
    "title": "Senior Flutter Developer",
    "company": "TechCorp Solutions",
    "location": "San Francisco, CA",
    "salary": "\$120,000 - \$160,000",
    "companyLogo":
        "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop",
    "description":
        """We are seeking a highly skilled Senior Flutter Developer to join our dynamic mobile development team. You will be responsible for developing high-quality mobile applications using Flutter framework, collaborating with cross-functional teams, and mentoring junior developers.

Key Responsibilities:
• Design and develop mobile applications using Flutter and Dart
• Collaborate with UI/UX designers to implement pixel-perfect designs
• Write clean, maintainable, and efficient code
• Participate in code reviews and maintain coding standards
• Optimize application performance and ensure smooth user experience
• Stay updated with latest Flutter and mobile development trends""",
    "requirements": """• Bachelor's degree in Computer Science or related field
• 5+ years of experience in mobile app development
• 3+ years of hands-on experience with Flutter and Dart
• Strong understanding of mobile app architecture patterns (MVVM, BLoC, Provider)
• Experience with RESTful APIs and third-party integrations
• Knowledge of native Android and iOS development is a plus
• Experience with version control systems (Git)
• Strong problem-solving and debugging skills
• Excellent communication and teamwork abilities
• Experience with CI/CD pipelines and automated testing""",
    "benefits": """• Competitive salary and equity package
• Comprehensive health, dental, and vision insurance
• Flexible working hours and remote work options
• Professional development budget (\$3,000 annually)
• Latest MacBook Pro and development tools
• Catered meals and snacks in the office
• Gym membership reimbursement
• 25 days of paid time off plus holidays
• Parental leave and family support programs
• Stock options and performance bonuses""",
    "postedDate": "2025-08-25",
    "type": "Full-time",
    "experience": "Senior Level",
  };

  final Map<String, dynamic> _companyData = {
    "name": "TechCorp Solutions",
    "logo":
        "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop",
    "industry": "Technology & Software",
    "size": "500-1000 employees",
    "headquarters": "San Francisco, CA",
    "founded": "2015",
    "description":
        "TechCorp Solutions is a leading technology company specializing in innovative mobile and web solutions. We help businesses transform their digital presence through cutting-edge applications and user-centric design. Our team of passionate developers and designers work together to create exceptional digital experiences that drive business growth.",
  };

  final List<Map<String, dynamic>> _similarJobs = [
    {
      "id": 2,
      "title": "Mobile App Developer",
      "company": "InnovateTech",
      "location": "Remote",
      "salary": "\$90,000 - \$130,000",
      "companyLogo":
          "https://images.unsplash.com/photo-1549923746-c502d488b3ea?w=400&h=400&fit=crop",
    },
    {
      "id": 3,
      "title": "Flutter Engineer",
      "company": "StartupXYZ",
      "location": "New York, NY",
      "salary": "\$100,000 - \$140,000",
      "companyLogo":
          "https://images.unsplash.com/photo-1572021335469-31706a17aaef?w=400&h=400&fit=crop",
    },
    {
      "id": 4,
      "title": "Senior Mobile Developer",
      "company": "DigitalWave",
      "location": "Austin, TX",
      "salary": "\$110,000 - \$150,000",
      "companyLogo":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }

  Future<void> _loadJobDetails() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _isLoading ? _buildLoadingState() : _buildContent(),
      bottomNavigationBar: _isLoading ? null : _buildBottomBar(),
      floatingActionButton: _buildAskAIButton(),
    );
  }

  Widget _buildLoadingState() {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading job details...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  JobHeaderWidget(jobData: _jobData),
                  SizedBox(height: 3.h),
                  MatchScoreWidget(
                    matchScore: 85,
                    skillGaps: ['GraphQL', 'Firebase', 'CI/CD'],
                  ),
                  SizedBox(height: 3.h),
                  JobDescriptionWidget(jobData: _jobData),
                  SizedBox(height: 3.h),
                  CompanyInfoWidget(companyData: _companyData),
                  SizedBox(height: 3.h),
                  SimilarJobsWidget(similarJobs: _similarJobs),
                  SizedBox(height: 12.h), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          Text(
            'Job Details',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: _shareJob,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: _toggleSaveJob,
              icon: CustomIconWidget(
                iconName: _isJobSaved ? 'favorite' : 'favorite_border',
                color: _isJobSaved
                    ? Colors.red
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 28,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _showApplicationBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Now',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAskAIButton() {
    return FloatingActionButton.extended(
      onPressed: _askAI,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
      icon: CustomIconWidget(
        iconName: 'psychology',
        color: AppTheme.lightTheme.colorScheme.onSecondary,
        size: 20,
      ),
      label: Text(
        'Ask AI',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _toggleSaveJob() {
    setState(() {
      _isJobSaved = !_isJobSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isJobSaved ? 'Job saved successfully!' : 'Job removed from saved',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: _isJobSaved ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _shareJob() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Job shared successfully!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showApplicationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ApplicationBottomSheet(jobData: _jobData),
      ),
    );
  }

  void _askAI() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'AI Career Advice',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Based on your profile and this job posting, here are some insights:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✓ Strong match for your Flutter experience',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '⚠ Consider learning GraphQL and Firebase',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '💡 Highlight your mobile architecture knowledge',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
