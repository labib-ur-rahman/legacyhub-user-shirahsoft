import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Main Header Controller - Manages the main screen tabs, header state, inbox and drawer
///
/// Features:
/// - Tab controller for 5 main tabs (Home, Projects, Shop, Activities, Profile)
/// - Screen title management based on active tab or special screens (Inbox)
/// - Tab state tracking with reactive updates
/// - Header collapse/expand on scroll with animations
/// - Inbox screen overlay management
/// - Custom drawer visibility control
///
/// Usage:
/// ```dart
/// final controller = MainHeaderController.instance;
/// controller.changeTab(2); // Switch to Shop tab
/// controller.showInbox(); // Show inbox screen
/// controller.openDrawer(); // Open settings drawer
/// ```
class MainHeaderController extends GetxController
    with GetTickerProviderStateMixin {
  /// Static instance accessor
  static MainHeaderController get instance => Get.find<MainHeaderController>();

  // ==================== Tab Controller ====================

  /// Tab controller for main navigation
  late TabController tabController;

  /// Number of tabs in the main navigation
  static const int tabCount = 5;

  // ==================== Animation Controller ====================

  /// Animation controller for header collapse/expand
  late AnimationController headerAnimationController;

  /// Animation for header height (1.0 = expanded, 0.0 = collapsed)
  late Animation<double> headerAnimation;

  /// Animation for curve radius (1.0 = curved, 0.0 = straight)
  late Animation<double> curveAnimation;

  /// Animation controller for drawer slide
  late AnimationController drawerAnimationController;

  /// Animation for drawer slide (0.0 = closed, 1.0 = open)
  late Animation<double> drawerSlideAnimation;

  /// Animation for drawer overlay opacity
  late Animation<double> drawerOverlayAnimation;

  // ==================== Scroll State ====================

  /// Whether header is currently expanded
  final RxBool _isHeaderExpanded = true.obs;

  /// Get header expanded state
  bool get isHeaderExpanded => _isHeaderExpanded.value;

  /// Previous scroll position for direction detection
  double _previousScrollOffset = 0.0;

  /// Scroll threshold to trigger collapse/expand
  static const double scrollThreshold = 10.0;

  // ==================== Inbox State ====================

  /// Whether inbox screen is currently visible
  final RxBool _isInboxVisible = false.obs;

  /// Get inbox visibility state
  bool get isInboxVisible => _isInboxVisible.value;

  // ==================== Drawer State ====================

  /// Whether drawer is currently open
  final RxBool _isDrawerOpen = false.obs;

  /// Get drawer open state
  bool get isDrawerOpen => _isDrawerOpen.value;

  // ==================== Reactive State ====================

  /// Current active tab index (0-4)
  final RxInt _currentTabIndex = 0.obs;

  /// Get current tab index
  int get currentTabIndex => _currentTabIndex.value;

  /// Screen title based on current tab or special screen
  String get screenTitle {
    // If inbox is visible, show "Inbox"
    if (_isInboxVisible.value) {
      return 'Inbox';
    }

    switch (_currentTabIndex.value) {
      case 0:
        return 'Home';
      case 1:
        return 'Projects';
      case 2:
        return 'Shop';
      case 3:
        return 'Activities';
      case 4:
        return 'Profile';
      default:
        return 'Home';
    }
  }

  // ==================== Lifecycle ====================

  @override
  void onInit() {
    super.onInit();
    _initializeTabController();
    _initializeAnimations();
    _initializeDrawerAnimations();
  }

  @override
  void onClose() {
    tabController.dispose();
    headerAnimationController.dispose();
    drawerAnimationController.dispose();
    super.onClose();
  }

  // ==================== Private Methods ====================

  /// Initialize the tab controller
  void _initializeTabController() {
    tabController = TabController(length: tabCount, vsync: this);
    tabController.addListener(_onTabChanged);
  }

  /// Initialize header animations
  void _initializeAnimations() {
    headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // Header height animation (1.0 = full height, 0.0 = collapsed)
    headerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: headerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Curve radius animation (1.0 = curved, 0.0 = straight)
    curveAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: headerAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Initialize drawer animations
  void _initializeDrawerAnimations() {
    drawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Drawer slide animation (right to left)
    drawerSlideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: drawerAnimationController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    // Overlay opacity animation
    drawerOverlayAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: drawerAnimationController, curve: Curves.easeOut),
    );
  }

  /// Called when tab changes via swipe or animation
  void _onTabChanged() {
    if (!tabController.indexIsChanging) {
      _currentTabIndex.value = tabController.index;
      // Hide inbox when switching tabs
      if (_isInboxVisible.value) {
        _isInboxVisible.value = false;
      }
    }
  }

  // ==================== Public Methods ====================

  /// Handle scroll notifications from child screens
  bool handleScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final currentOffset = notification.metrics.pixels;
      final delta = currentOffset - _previousScrollOffset;

      // Only trigger if scroll exceeds threshold
      if (delta.abs() > scrollThreshold) {
        if (delta > 0 && currentOffset > 50) {
          // Scrolling down - collapse header
          collapseHeader();
        } else if (delta < 0) {
          // Scrolling up - expand header
          expandHeader();
        }
        _previousScrollOffset = currentOffset;
      }
    }

    // Reset scroll position when scroll ends at top
    if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels <= 0) {
        expandHeader();
        _previousScrollOffset = 0.0;
      }
    }

    return false; // Allow notification to continue bubbling
  }

  /// Collapse the header (hide header content, show only tabs)
  void collapseHeader() {
    if (_isHeaderExpanded.value) {
      _isHeaderExpanded.value = false;
      headerAnimationController.forward();
    }
  }

  /// Expand the header (show header content and tabs)
  void expandHeader() {
    if (!_isHeaderExpanded.value) {
      _isHeaderExpanded.value = true;
      headerAnimationController.reverse();
    }
  }

  /// Change to a specific tab
  void changeTab(int index) {
    if (index >= 0 && index < tabCount) {
      _currentTabIndex.value = index;
      tabController.animateTo(index);
      // Hide inbox when changing to a tab
      if (_isInboxVisible.value) {
        _isInboxVisible.value = false;
      }
    }
  }

  /// Check if a specific tab is active
  bool isTabActive(int index) =>
      _currentTabIndex.value == index && !_isInboxVisible.value;

  // ==================== Inbox Methods ====================

  /// Show inbox screen
  void showInbox() {
    _isInboxVisible.value = true;
    // Expand header when showing inbox
    expandHeader();
  }

  /// Hide inbox screen and return to previous tab
  void hideInbox() {
    _isInboxVisible.value = false;
  }

  /// Toggle inbox visibility
  void toggleInbox() {
    if (_isInboxVisible.value) {
      hideInbox();
    } else {
      showInbox();
    }
  }

  // ==================== Drawer Methods ====================

  /// Open the drawer
  void openDrawer() {
    _isDrawerOpen.value = true;
    drawerAnimationController.forward();
  }

  /// Close the drawer
  void closeDrawer() {
    drawerAnimationController.reverse().then((_) {
      _isDrawerOpen.value = false;
    });
  }

  /// Toggle drawer visibility
  void toggleDrawer() {
    if (_isDrawerOpen.value) {
      closeDrawer();
    } else {
      openDrawer();
    }
  }

  /// Get tab icon path based on active state
  String getTabIconPath(
    int index, {
    required String selected,
    required String unselected,
  }) {
    return isTabActive(index) ? selected : unselected;
  }
}
