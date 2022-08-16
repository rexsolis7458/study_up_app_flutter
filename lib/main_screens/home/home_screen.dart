import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/group/group_tab.dart';
import 'package:study_up_app/main_screens/home/home_tab.dart';
import 'package:study_up_app/main_screens/profile/profile_tab.dart';
import 'package:study_up_app/main_screens/search_tab.dart';


class HomeScreen extends StatefulWidget 
{
  final String? currentUserId;

  HomeScreen({Key? key, this.currentUserId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: [
        HomeTab(
        currentUserId: widget.currentUserId,
        ),
        SearchTab(
          currentUserId: widget.currentUserId,
        ),
        GroupTab(
          currentUserId: widget.currentUserId,
        ),
        ProfileTab(
          currentUserId: widget.currentUserId, email: '',
        )
      ].elementAt(_selectedTab),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: KTweeterColor,
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.group)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}