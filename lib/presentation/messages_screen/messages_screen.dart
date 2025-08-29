import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/conversation_card_widget.dart';
import './widgets/empty_messages_widget.dart';
import './widgets/message_templates_widget.dart';
import './widgets/search_bar_widget.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with TickerProviderStateMixin {
  final GlobalKey<SearchBarWidgetState> _searchBarKey =
      GlobalKey<SearchBarWidgetState>();
  late TabController _tabController;
  List<Map<String, dynamic>> _allConversations = [];
  List<Map<String, dynamic>> _filteredConversations = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadConversations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadConversations() {
    // Mock conversation data
    _allConversations = [
      {
        'id': 1,
        'name': 'Sarah Johnson',
        'company': 'Google Inc.',
        'avatar':
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'lastMessage':
            'Thank you for your interest in the Senior Flutter Developer position. We\'d like to schedule an interview.',
        'timestamp': '2 min ago',
        'unreadCount': 2,
        'isOnline': true,
        'isPinned': true,
        'category': 'all',
      },
      {
        'id': 2,
        'name': 'Michael Chen',
        'company': 'Microsoft Corporation',
        'avatar':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'lastMessage':
            'Your portfolio looks impressive! Can we discuss the Mobile App Developer role further?',
        'timestamp': '1 hour ago',
        'unreadCount': 1,
        'isOnline': false,
        'isPinned': false,
        'category': 'all',
      },
      {
        'id': 3,
        'name': 'Emily Rodriguez',
        'company': 'Apple Inc.',
        'avatar':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        'lastMessage':
            'We received your application for the iOS Developer position. Our team will review it shortly.',
        'timestamp': '3 hours ago',
        'unreadCount': 0,
        'isOnline': true,
        'isPinned': false,
        'category': 'all',
      },
      {
        'id': 4,
        'name': 'David Kim',
        'company': 'Meta Platforms',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        'lastMessage':
            'Hi! I saw your profile and think you\'d be a great fit for our React Native team.',
        'timestamp': 'Yesterday',
        'unreadCount': 3,
        'isOnline': false,
        'isPinned': true,
        'category': 'all',
      },
      {
        'id': 5,
        'name': 'Lisa Thompson',
        'company': 'Amazon Web Services',
        'avatar':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
        'lastMessage':
            'Congratulations! We\'d like to extend an offer for the Cloud Solutions Architect position.',
        'timestamp': '2 days ago',
        'unreadCount': 0,
        'isOnline': true,
        'isPinned': false,
        'category': 'all',
      },
      {
        'id': 6,
        'name': 'James Wilson',
        'company': 'Netflix Inc.',
        'avatar':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        'lastMessage':
            'Thanks for applying to the Full Stack Engineer role. We\'ll be in touch soon.',
        'timestamp': '3 days ago',
        'unreadCount': 0,
        'isOnline': false,
        'isPinned': false,
        'category': 'archived',
      },
    ];

    setState(() {
      _filteredConversations = _getFilteredConversations();
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> _getFilteredConversations() {
    List<Map<String, dynamic>> conversations = List.from(_allConversations);

    // Filter by tab
    String currentTab = _getCurrentTabFilter();
    if (currentTab != 'all') {
      conversations =
          conversations
              .where(
                (conv) =>
                    conv['category'] == currentTab ||
                    (currentTab == 'unread' &&
                        (conv['unreadCount'] as int) > 0) ||
                    (currentTab == 'pinned' && (conv['isPinned'] as bool)),
              )
              .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      conversations =
          conversations.where((conv) {
            final name = (conv['name'] as String).toLowerCase();
            final company = (conv['company'] as String).toLowerCase();
            final message = (conv['lastMessage'] as String).toLowerCase();
            final query = _searchQuery.toLowerCase();

            return name.contains(query) ||
                company.contains(query) ||
                message.contains(query);
          }).toList();
    }

    // Sort: pinned first, then by timestamp
    conversations.sort((a, b) {
      final aPinned = a['isPinned'] as bool;
      final bPinned = b['isPinned'] as bool;

      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;

      // For demo purposes, we'll use a simple timestamp comparison
      return (a['id'] as int).compareTo(b['id'] as int);
    });

    return conversations;
  }

  String _getCurrentTabFilter() {
    switch (_tabController.index) {
      case 0:
        return 'all';
      case 1:
        return 'unread';
      case 2:
        return 'archived';
      default:
        return 'all';
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredConversations = _getFilteredConversations();
    });
  }

  void _onClearSearch() {
    setState(() {
      _searchQuery = '';
      _filteredConversations = _getFilteredConversations();
    });
  }

  void _onConversationTap(Map<String, dynamic> conversation) {
    // Navigate to chat screen (would be implemented separately)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${conversation['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onPin(Map<String, dynamic> conversation) {
    setState(() {
      final index = _allConversations.indexWhere(
        (c) => c['id'] == conversation['id'],
      );
      if (index != -1) {
        _allConversations[index]['isPinned'] =
            !(conversation['isPinned'] as bool);
        _filteredConversations = _getFilteredConversations();
      }
    });

    final isPinned = !(conversation['isPinned'] as bool);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isPinned ? 'Conversation pinned' : 'Conversation unpinned',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onMute(Map<String, dynamic> conversation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation with ${conversation['name']} muted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onArchive(Map<String, dynamic> conversation) {
    setState(() {
      final index = _allConversations.indexWhere(
        (c) => c['id'] == conversation['id'],
      );
      if (index != -1) {
        _allConversations[index]['category'] = 'archived';
        _filteredConversations = _getFilteredConversations();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              final index = _allConversations.indexWhere(
                (c) => c['id'] == conversation['id'],
              );
              if (index != -1) {
                _allConversations[index]['category'] = 'all';
                _filteredConversations = _getFilteredConversations();
              }
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onDelete(Map<String, dynamic> conversation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Conversation',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete this conversation with ${conversation['name']}? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _allConversations.removeWhere(
                    (c) => c['id'] == conversation['id'],
                  );
                  _filteredConversations = _getFilteredConversations();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Conversation deleted'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onStartNetworking() {
    Navigator.pushNamed(context, '/home-screen');
  }

  void _onTemplateSelected(String template) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Template selected: ${template.substring(0, 50)}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _loadConversations();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conversations refreshed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _searchBarKey.currentState?.toggleSearch();
            },
            icon: CustomIconWidget(
              iconName: 'search',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to profile or settings
              Navigator.pushNamed(context, '/profile-screen');
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl:
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12.h),
          child: Column(
            children: [
              SearchBarWidget(
                key: _searchBarKey,
                onSearchChanged: _onSearchChanged,
                onClearSearch: _onClearSearch,
              ),
              Container(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                child: TabBar(
                  controller: _tabController,
                  onTap: (index) {
                    setState(() {
                      _filteredConversations = _getFilteredConversations();
                    });
                  },
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'chat',
                            size: 16,
                            color:
                                _tabController.index == 0
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme
                                        .lightTheme
                                        .colorScheme
                                        .onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text('All'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'circle',
                            size: 16,
                            color:
                                _tabController.index == 1
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme
                                        .lightTheme
                                        .colorScheme
                                        .onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text('Unread'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'archive',
                            size: 16,
                            color:
                                _tabController.index == 2
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme
                                        .lightTheme
                                        .colorScheme
                                        .onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text('Archived'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              )
              : Column(
                children: [
                  if (_filteredConversations.isNotEmpty &&
                      _tabController.index == 0)
                    MessageTemplatesWidget(
                      onTemplateSelected: _onTemplateSelected,
                    ),
                  Expanded(
                    child:
                        _filteredConversations.isEmpty
                            ? EmptyMessagesWidget(
                              onStartNetworking: _onStartNetworking,
                            )
                            : RefreshIndicator(
                              onRefresh: _onRefresh,
                              color: AppTheme.lightTheme.colorScheme.primary,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildConversationsList(),
                                  _buildConversationsList(),
                                  _buildConversationsList(),
                                ],
                              ),
                            ),
                  ),
                ],
              ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Messages tab is active
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-screen');
              break;
            case 1:
              // Already on messages screen
              break;
            case 2:
              // Navigate to applications screen (not implemented)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Applications screen coming soon'),
                  duration: Duration(seconds: 1),
                ),
              );
              break;
            case 3:
              Navigator.pushNamed(context, '/profile-screen');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'assignment',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'assignment',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
      itemCount: _filteredConversations.length,
      itemBuilder: (context, index) {
        final conversation = _filteredConversations[index];
        return ConversationCardWidget(
          conversation: conversation,
          onTap: () => _onConversationTap(conversation),
          onPin: () => _onPin(conversation),
          onMute: () => _onMute(conversation),
          onArchive: () => _onArchive(conversation),
          onDelete: () => _onDelete(conversation),
        );
      },
    );
  }
}