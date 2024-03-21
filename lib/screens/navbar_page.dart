import 'package:flutter/material.dart';
import 'package:offering_collection_app/screens/church_details_page.dart';
import 'package:offering_collection_app/screens/home_page.dart';
import 'package:offering_collection_app/screens/profile_screen.dart';

class NewNav extends StatefulWidget {
   const NewNav({super.key});

  @override
  State<NewNav> createState() => _NewNavState();
}

class _NewNavState extends State<NewNav> {

  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomePage(),
    const ChurchDetailsPage(),
     ProfileScreen(),
  ];

  int _selectedIndex = 0;
  void _onPagechanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPagechanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        backgroundColor: const Color(0xFFEEF5FB),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Give'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ]
      ),
    );
  }
}
