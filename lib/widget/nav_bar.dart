import 'package:flutter/material.dart';
import 'package:gym_project/screens/common/login-screen.dart';
import 'package:motion_tab_bar/MotionTabController.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  MotionTabController _tabController;
  int _selectedIndex = 0;

  final _pages = [
    {
      'page': Login(),
      'title': 'Your Favorite',
    },
    {
      'page': Material(),
      'title': 'Your Favorite',
    },
    {
      'page': Material(),
      'title': 'Your Favorite',
    },
    {
      'page': Material(),
      'title': 'Your Favorite',
    },
  ];
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFFFCE2B),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'School',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'School',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'School',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }
}
