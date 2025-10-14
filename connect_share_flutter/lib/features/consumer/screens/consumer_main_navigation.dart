import 'package:flutter/material.dart';
import '../../shared/screens/profile_screen.dart';
import 'consumer_dashboard_screen.dart';
import 'my_tokens_screen.dart';

class ConsumerMainNavigation extends StatefulWidget {
  const ConsumerMainNavigation({super.key});

  @override
  State<ConsumerMainNavigation> createState() => _ConsumerMainNavigationState();
}

class _ConsumerMainNavigationState extends State<ConsumerMainNavigation> {
  int _selectedIndex = 0;

  // Create navigator keys for each tab to maintain individual navigation stacks
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // Define tab configurations
  static const List<_TabConfig> _tabs = [
    _TabConfig(
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      label: 'Hotspots',
    ),
    _TabConfig(
      icon: Icons.vpn_key_outlined,
      activeIcon: Icons.vpn_key,
      label: 'My Tokens',
    ),
    _TabConfig(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  // Build navigator for each tab
  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _getScreenForIndex(index),
          settings: settings,
        );
      },
    );
  }

  // Get the appropriate screen for each index
  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const ConsumerDashboardScreen();
      case 1:
        return const MyTokensScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const ConsumerDashboardScreen();
    }
  }

  void _onTabTapped(int index) {
    if (_selectedIndex == index) {
      // Double tap current tab to pop to root
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Handle back button behavior
  // Future<bool> _onWillPop() async {
  //   final NavigatorState? currentNavigator =
  //       _navigatorKeys[_selectedIndex].currentState;

  //   if (currentNavigator != null && currentNavigator.canPop()) {
  //     currentNavigator.pop();
  //     return false;
  //   }

  //   // If we're not on the first tab, go to first tab instead of exiting
  //   if (_selectedIndex != 0) {
  //     setState(() {
  //       _selectedIndex = 0;
  //     });
  //     return false;
  //   }

  //   return true; // Allow app to exit
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final NavigatorState? currentNavigator =
          _navigatorKeys[_selectedIndex].currentState;

        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
          return;
        }

        if (_selectedIndex != 0) {
          setState(() {
        _selectedIndex = 0;
          });
          return;
        }

        await Navigator.of(context).maybePop();
      },
      child: Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(
        _tabs.length,
        (index) => _buildTabNavigator(index),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: _tabs
          .map((tab) => BottomNavigationBarItem(
            icon: Icon(tab.icon),
            activeIcon: Icon(tab.activeIcon),
            label: tab.label,
            ))
          .toList(),
      ),
      ),
    );
  }
}

// Configuration class for tab data
class _TabConfig {
  const _TabConfig({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
