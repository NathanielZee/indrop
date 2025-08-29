import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import './widgets/activity_tab_widget.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/overview_tab_widget.dart';
import './widgets/profile_completion_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_tabs_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/resume_tab_widget.dart';
import './widgets/skills_tab_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 3; // Profile tab is active
  final ImagePicker _imagePicker = ImagePicker();

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Sarah Johnson",
    "title": "Senior Software Engineer",
    "location": "San Francisco, CA",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "careerSummary":
        "Experienced software engineer with 8+ years in full-stack development. Passionate about creating scalable solutions and mentoring junior developers. Expertise in React, Node.js, and cloud technologies.",
    "resumeUrl": "https://example.com/resume.pdf",
  };

  final List<Map<String, dynamic>> experienceHighlights = [
    {
      "position": "Senior Software Engineer",
      "company": "TechCorp Inc.",
      "duration": "2021 - Present",
    },
    {
      "position": "Full Stack Developer",
      "company": "StartupXYZ",
      "duration": "2019 - 2021",
    },
    {
      "position": "Frontend Developer",
      "company": "WebSolutions",
      "duration": "2017 - 2019",
    },
  ];

  final List<Map<String, dynamic>> achievementBadges = [
    {"title": "Top Performer 2023"},
    {"title": "Innovation Award"},
    {"title": "Team Leader"},
    {"title": "Client Favorite"},
  ];

  final List<Map<String, dynamic>> skills = [
    {
      "name": "React.js",
      "level": "Expert",
      "proficiency": 95,
      "endorsements": 24,
    },
    {
      "name": "Node.js",
      "level": "Advanced",
      "proficiency": 88,
      "endorsements": 18,
    },
    {
      "name": "Python",
      "level": "Advanced",
      "proficiency": 82,
      "endorsements": 15,
    },
    {
      "name": "AWS",
      "level": "Intermediate",
      "proficiency": 75,
      "endorsements": 12,
    },
    {
      "name": "Docker",
      "level": "Intermediate",
      "proficiency": 70,
      "endorsements": 8,
    },
  ];

  final List<Map<String, dynamic>> activities = [
    {
      "type": "application",
      "title": "Applied to Senior Developer Role",
      "description": "Applied to Google for Senior Software Engineer position",
      "date": "2 hours ago",
      "status": "Pending",
    },
    {
      "type": "profile_view",
      "title": "Profile Viewed",
      "description": "Your profile was viewed by Microsoft recruiter",
      "date": "1 day ago",
      "status": null,
    },
    {
      "type": "achievement",
      "title": "New Achievement Unlocked",
      "description": "Earned 'Top Performer 2023' badge",
      "date": "3 days ago",
      "status": "Completed",
    },
    {
      "type": "skill_update",
      "title": "Skill Endorsed",
      "description": "React.js skill endorsed by 3 colleagues",
      "date": "1 week ago",
      "status": null,
    },
    {
      "type": "resume_update",
      "title": "Resume Updated",
      "description": "Updated work experience and skills section",
      "date": "2 weeks ago",
      "status": "Completed",
    },
  ];

  final List<String> tabs = ['Overview', 'Resume', 'Skills', 'Activity'];
  final List<String> missingElements = [
    'Add professional summary',
    'Upload portfolio projects',
    'Complete skills assessment',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleCameraPress() async {
    try {
      final PermissionStatus permission = await Permission.camera.request();

      if (permission.isGranted) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text('Take Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text('Choose from Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: "Camera permission is required to update profile picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error accessing camera",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        Fluttertoast.showToast(
          msg: "Profile picture updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error selecting image",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home-screen');
        break;
      case 1:
        Navigator.pushNamed(context, '/messages-screen');
        break;
      case 2:
        // Navigate to applications screen (not implemented)
        Fluttertoast.showToast(
          msg: "Applications screen coming soon",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        break;
      case 3:
        // Already on profile screen
        break;
    }
  }

  void _handleEditProfile() {
    Fluttertoast.showToast(
      msg: "Edit profile functionality coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleSettings() {
    Fluttertoast.showToast(
      msg: "Settings screen coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleEditResume() {
    Fluttertoast.showToast(
      msg: "Resume builder coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleDownloadResume() {
    Fluttertoast.showToast(
      msg: "Resume downloaded successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleShareResume() {
    Fluttertoast.showToast(
      msg: "Resume shared successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleAddSkill() {
    Fluttertoast.showToast(
      msg: "Add skill functionality coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleShareProfile() {
    Fluttertoast.showToast(
      msg: "Profile shared successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleCareerInsights() {
    Fluttertoast.showToast(
      msg: "Career insights coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            Fluttertoast.showToast(
              msg: "Profile refreshed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
          child: Column(
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userName: userData['name'] as String,
                professionalTitle: userData['title'] as String,
                location: userData['location'] as String,
                profileImageUrl: userData['profileImage'] as String,
                onEditProfile: _handleEditProfile,
                onSettings: _handleSettings,
                onCameraPressed: _handleCameraPress,
              ),

              // Profile Completion
              ProfileCompletionWidget(
                completionPercentage: 75,
                missingElements: missingElements,
              ),

              // Quick Actions
              QuickActionsWidget(
                onShareProfile: _handleShareProfile,
                onDownloadResume: _handleDownloadResume,
                onCareerInsights: _handleCareerInsights,
              ),

              // Profile Tabs
              ProfileTabsWidget(
                tabController: _tabController,
                tabs: tabs,
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    OverviewTabWidget(
                      careerSummary: userData['careerSummary'] as String,
                      experienceHighlights: experienceHighlights,
                      achievementBadges: achievementBadges,
                    ),
                    ResumeTabWidget(
                      resumeUrl: userData['resumeUrl'] as String,
                      onEditResume: _handleEditResume,
                      onDownloadResume: _handleDownloadResume,
                      onShareResume: _handleShareResume,
                    ),
                    SkillsTabWidget(
                      skills: skills,
                      onAddSkill: _handleAddSkill,
                    ),
                    ActivityTabWidget(
                      activities: activities,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}
