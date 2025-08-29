import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String) onSuggestionTap;

  const SearchBarWidget({
    Key? key,
    required this.onSearch,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  final List<Map<String, dynamic>> _suggestions = [
    {"text": "Flutter Developer", "type": "job"},
    {"text": "Google", "type": "company"},
    {"text": "Software Engineer", "type": "job"},
    {"text": "Microsoft", "type": "company"},
    {"text": "Product Manager", "type": "job"},
    {"text": "Apple", "type": "company"},
    {"text": "UI/UX Designer", "type": "job"},
    {"text": "Amazon", "type": "company"},
  ];

  List<Map<String, dynamic>> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions =
            _focusNode.hasFocus && _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterSuggestions(String query) {
    if (query.isEmpty) {
      _filteredSuggestions = [];
    } else {
      _filteredSuggestions = _suggestions
          .where((suggestion) => (suggestion["text"] as String)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .take(5)
          .toList();
    }
    setState(() {
      _showSuggestions = _filteredSuggestions.isNotEmpty && _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: (value) {
              _filterSuggestions(value);
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                widget.onSearch(value);
                _focusNode.unfocus();
              }
            },
            decoration: InputDecoration(
              hintText: 'Search jobs, companies...',
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _filterSuggestions('');
                        _focusNode.unfocus();
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppTheme.lightTheme.colorScheme.surface,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            ),
          ),
        ),
        if (_showSuggestions && _filteredSuggestions.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSuggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return ListTile(
                  leading: CustomIconWidget(
                    iconName: (suggestion["type"] as String) == "job"
                        ? 'work'
                        : 'business',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  title: Text(
                    suggestion["text"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    (suggestion["type"] as String) == "job"
                        ? "Job Title"
                        : "Company",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () {
                    widget.onSuggestionTap(suggestion["text"] as String);
                    _searchController.text = suggestion["text"] as String;
                    _focusNode.unfocus();
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
