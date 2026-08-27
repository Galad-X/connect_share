// lib/features/provider/screens/provider_main_navigation.dart
import 'package:flutter/material.dart';

import '../../shared/screens/profile_screen.dart';
import 'earnings_screen.dart';
import 'provider_dashboard_screen.dart';

class ProviderMainNavigation extends StatefulWidget {
  const ProviderMainNavigation({super.key});

  @override
  State<ProviderMainNavigation> createState() => _ProviderMainNavigationState();
}

class _ProviderMainNavigationState extends State<ProviderMainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ProviderDashboardScreen(), // Tab 1: My Hotspots
    EarningsScreen(), // Tab 2: Earnings
    ProfileScreen(), // Tab 3: Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi_tethering_outlined),
            activeIcon: Icon(Icons.wifi_tethering),
            label: 'My Hotspots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            activeIcon: Icon(Icons.monetization_on),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
