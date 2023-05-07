import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/group/groupList.dart';
import 'package:study_up_app/main_screens/group/group_tab.dart';
import 'package:study_up_app/main_screens/profile/profile_tab.dart';
import 'package:study_up_app/main_screens/recommend.dart';
import 'package:study_up_app/main_screens/search_tab.dart';

import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  final String? currentUserId;

  HomeScreen({Key? key, this.currentUserId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: [
        HomeTab(),
        // SearchTab(
        //   currentUserId: widget.currentUserId,
        // ),
        const AllPost(),
        // GroupRecommendationPage(),
        GroupTab(
          // distanceBetween: 0, subChildren: [],
          currentUserId: widget.currentUserId,
        ),
        RecommendScreen(),
        ProfileTab(),
      ].elementAt(_selectedTab),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: MainColor,
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.group)),
          BottomNavigationBarItem(icon: Icon(Icons.abc)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
