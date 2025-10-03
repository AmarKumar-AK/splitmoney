import 'package:flutter/material.dart';

import 'models/nav_item.dart';

import 'screens/home_screen.dart';
import 'screens/friend_screen.dart';
import 'screens/expense_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  // All nav items in a single list
  final List<NavItem> _navItems = const [
    NavItem(screen: HomeScreen(), icon: Icons.home, label: 'Home'),
    NavItem(screen: FriendScreen(), icon: Icons.people, label: 'Friends'),
    NavItem(screen: ExpenseScreen(), icon: Icons.attach_money, label: 'Expense'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navItems[_selectedIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
        items: _navItems
          .map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          ))
          .toList(),
      ),
    );
  }
}
