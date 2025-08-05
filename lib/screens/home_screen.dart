import 'package:cofi/screens/tabs/collections_tab.dart';
import 'package:cofi/screens/tabs/profile_tab.dart';
import 'package:cofi/utils/colors.dart';
import 'package:cofi/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'tabs/explore_tab.dart';
import 'tabs/community_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    ExploreTab(),
    CommunityTab(),
    // Placeholder widgets for Collections and Profile
    CollectionsTab(),
    ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _currentIndex != 0
          ? null
          : FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: primary,
              onPressed: () {
                Navigator.pushNamed(context, '/mapView');
              },
              label: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/mapView');
                },
                label: TextWidget(
                    text: 'Map', fontSize: 16, color: white, isBold: true),
                icon: Icon(
                  FontAwesomeIcons.map,
                  color: white,
                ),
              ),
            ),
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: _tabs[_currentIndex],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.red[700],
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Collections',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (i) {
        setState(() {
          _currentIndex = i;
        });
      },
    );
  }
}
