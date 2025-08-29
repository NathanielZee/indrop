import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_recommendation_card_widget.dart';
import './widgets/app_header_widget.dart';
import './widgets/expandable_fab_widget.dart';
import './widgets/job_card_widget.dart';
import './widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicator = RefreshIndicator(
    onRefresh: () async {},
    child: Container(),
  );

  int _currentBottomNavIndex = 0;
  bool _isLoading = false;
  bool _hasMoreJobs = true;

  // Mock job data
  final List<Map<String, dynamic>> _jobsList = [
    {
      "id": 1,
      "title": "Senior Flutter Developer",
      "company": "Google",
      "location": "Mountain View, CA",
      "salary": "\$120,000 - \$180,000",
      "type": "Full-time",
      "companyLogo":
          "https://images.unsplash.com/photo-1573804633927-bfcbcd909acd?w=100&h=100&fit=crop",
      "postedDate": "2 days ago",
    },
    {
      "id": 2,
      "title": "Mobile App Developer",
      "company": "Microsoft",
      "location": "Seattle, WA",
      "salary": "\$100,000 - \$150,000",
      "type": "Full-time",
      "companyLogo":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=100&h=100&fit=crop",
      "postedDate": "1 day ago",
    },
    {
      "id": 3,
      "title": "iOS Developer",
      "company": "Apple",
      "location": "Cupertino, CA",
      "salary": "\$130,000 - \$200,000",
      "type": "Full-time",
      "companyLogo":
          "https://images.unsplash.com/photo-1621768216002-5ac171876625?w=100&h=100&fit=crop",
      "postedDate": "3 days ago",
    },
    {
      "id": 4,
      "title": "Frontend Developer",
      "company": "Meta",
      "location": "Menlo Park, CA",
      "salary": "\$110,000 - \$170,000",
      "type": "Full-time",
      "companyLogo":
          "https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=100&h=100&fit=crop",
      "postedDate": "1 week ago",
    },
    {
      "id": 5,
      "title": "Software Engineer",
      "company": "Amazon",
      "location": "Seattle, WA",
      "salary": "\$115,000 - \$175,000",
      "type": "Full-time",
      "companyLogo":
          "https://images.unsplash.com/photo-1523474253046-8cd2748b5fd2?w=100&h=100&fit=crop",
      "postedDate": "4 days ago",
    },
  ];

  // Mock AI recommendations
  final List<Map<String, dynamic>> _aiRecommendations = [
    {
      "id": 1,
      "title": "React Native Developer",
      "company": "Netflix",
      "companyLogo":
          "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=100&h=100&fit=crop",
      "matchScore": 92,
      "reason":
          "Your Flutter experience translates perfectly to React Native development",
    },
    {
      "id": 2,
      "title": "Mobile Team Lead",
      "company": "Spotify",
      "companyLogo":
          "https://images.unsplash.com/photo-1611339555312-e607c8352fd7?w=100&h=100&fit=crop",
      "matchScore": 88,
      "reason":
          "Your leadership skills and mobile expertise make you ideal for this role",
    },
  ];

  List<Map<String, dynamic>> _displayedJobs = [];
  List<Map<String, dynamic>> _displayedRecommendations = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    setState(() {
      _displayedJobs = List.from(_jobsList);
      _displayedRecommendations = List.from(_aiRecommendations);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreJobs();
    }
  }

  Future<void> _loadMoreJobs() async {
    if (_isLoading || !_hasMoreJobs) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Add more jobs (simulated)
      _displayedJobs.addAll(_jobsList.map((job) => {
            ...job,
            "id": job["id"] + _displayedJobs.length,
          }));
      _isLoading = false;

      // Simulate end of data after 20 jobs
      if (_displayedJobs.length >= 20) {
        _hasMoreJobs = false;
      }
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    _loadInitialData();
  }

  void _onJobTap(Map<String, dynamic> jobData) {
    Navigator.pushNamed(context, '/job-detail-screen');
  }

  void _onJobApply(Map<String, dynamic> jobData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Applied to ${jobData["title"]} at ${jobData["company"]}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onJobSave(Map<String, dynamic> jobData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved ${jobData["title"]}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onJobShare(Map<String, dynamic> jobData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shared ${jobData["title"]}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSimilarJobs(Map<String, dynamic> jobData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Finding similar jobs to ${jobData["title"]}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSearch(String query) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for: $query'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSuggestionTap(String suggestion) {
    _onSearch(suggestion);
  }

  void _onRecommendationTap(Map<String, dynamic> recommendation) {
    Navigator.pushNamed(context, '/job-detail-screen');
  }

  void _onRecommendationDismiss(Map<String, dynamic> recommendation) {
    setState(() {
      _displayedRecommendations
          .removeWhere((item) => item["id"] == recommendation["id"]);
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/messages-screen');
        break;
      case 2:
        // Navigate to Applications screen (not implemented)
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-screen');
        break;
    }
  }

  void _onProfileTap() {
    Navigator.pushNamed(context, '/profile-screen');
  }

  void _onCreateResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Resume Builder...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onUploadResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening File Picker...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onFindJobs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Job Search...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onAIAdvice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening AI Career Advisor...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildJobFeed() {
    List<Widget> feedItems = [];

    for (int i = 0; i < _displayedJobs.length; i++) {
      // Add AI recommendation after every 3 jobs
      if (i > 0 && i % 3 == 0 && _displayedRecommendations.isNotEmpty) {
        final recommendationIndex =
            (i ~/ 3 - 1) % _displayedRecommendations.length;
        feedItems.add(
          AIRecommendationCardWidget(
            recommendationData: _displayedRecommendations[recommendationIndex],
            onTap: () => _onRecommendationTap(
                _displayedRecommendations[recommendationIndex]),
            onDismiss: () => _onRecommendationDismiss(
                _displayedRecommendations[recommendationIndex]),
          ),
        );
      }

      feedItems.add(
        JobCardWidget(
          jobData: _displayedJobs[i],
          onTap: () => _onJobTap(_displayedJobs[i]),
          onApply: () => _onJobApply(_displayedJobs[i]),
          onSave: () => _onJobSave(_displayedJobs[i]),
          onShare: () => _onJobShare(_displayedJobs[i]),
          onSimilar: () => _onSimilarJobs(_displayedJobs[i]),
        ),
      );
    }

    if (_isLoading) {
      feedItems.add(
        Container(
          padding: EdgeInsets.all(4.w),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (!_hasMoreJobs && _displayedJobs.isNotEmpty) {
      feedItems.add(
        Container(
          padding: EdgeInsets.all(4.w),
          child: Center(
            child: Text(
              'You\'ve reached the end!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return feedItems.isEmpty
        ? _buildEmptyState()
        : ListView(
            controller: _scrollController,
            children: feedItems,
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'work_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No jobs found',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search criteria',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _onFindJobs,
            child: const Text('Explore Jobs'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeaderWidget(
            onProfileTap: _onProfileTap,
          ),
          SearchBarWidget(
            onSearch: _onSearch,
            onSuggestionTap: _onSuggestionTap,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _buildJobFeed(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  index: 0,
                  iconName: 'home_outlined',
                  activeIconName: 'home',
                  label: 'Home',
                ),
                _buildNavItem(
                  index: 1,
                  iconName: 'chat_bubble_outline',
                  activeIconName: 'chat_bubble',
                  label: 'Messages',
                ),
                _buildNavItem(
                  index: 2,
                  iconName: 'description_outlined',
                  activeIconName: 'description',
                  label: 'Applications',
                ),
                _buildNavItem(
                  index: 3,
                  iconName: 'person_outline',
                  activeIconName: 'person',
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ExpandableFabWidget(
        onCreateResume: _onCreateResume,
        onUploadResume: _onUploadResume,
        onFindJobs: _onFindJobs,
        onAIAdvice: _onAIAdvice,
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconName,
    required String activeIconName,
    required String label,
  }) {
    final bool isSelected = _currentBottomNavIndex == index;

    return GestureDetector(
      onTap: () => _onBottomNavTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: isSelected ? activeIconName : iconName,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            SizedBox(height: 0.3.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
