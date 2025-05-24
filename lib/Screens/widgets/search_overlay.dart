import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class SearchOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const SearchOverlay({
    super.key,
    required this.onClose,
  });

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Material(
        color: AppColors.surface,
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Back Button
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.primary,
                      onPressed: widget.onClose,
                    ),
                    
                    // Search TextField
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Search for abayas, hijabs...',
                          hintStyle: AppTextStyles.body.copyWith(
                            color: AppColors.textLight,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingS,
                          ),
                        ),
                        style: AppTextStyles.body,
                        onChanged: (value) {
                          // TODO: Implement search functionality
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Search Results will go here
              Expanded(
                child: Center(
                  child: Text(
                    'Start typing to search...',
                    style: AppTextStyles.subheadline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}