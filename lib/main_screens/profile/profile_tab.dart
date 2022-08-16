import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/controller/auth_controller.dart';

class ProfileTab extends StatefulWidget
{
  final String? currentUserId;
  String email;
  
  ProfileTab({Key? key, this.currentUserId, required this.email}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
{
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: SizedBox (
                  width: 100,
                  height: 95,
                  child: ClipOval(
                    child: Image.asset("assets/logo.png"),
                  ),
                ),
              ),
            ),
            Container(
              height: 30,
            ),
            ListTile(
              title: Text('About Us'),
              leading: Icon(Icons.info_rounded),
              onTap: () {},
            ),
            ListTile(
              title: Text('Help'),
              leading: Icon(Icons.help),
              onTap: () {},
            ),
            ListTile(
              title: Text('Sign out'),
              leading: Icon(Icons.logout),
              onTap: () {
                AuthController.instance.logOut();
              },
            ),
          ],
        )
      ),
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.blue[550],
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          child: Row(
            children: [
              SizedBox(
                width: 110,
              ),
              Center(
                child: Text('Profile'),
              ),
            ],
          ),
        )
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
              Positioned(
                top: 0.1,
                right: 150,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 4),
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 3,
                      ),
                    ]
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text('NAME'),
          SizedBox(
            height: 5,
          ),
          Text(widget.email),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.lock_open,
                    size: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('REVEALS LEFT'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.person,
                    size: 40,),
                    SizedBox(
                      height: 10,
                    ),
                    Text('REPUTATION'),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
            child: Container
            (
              height: 50,
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.message
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Text('Create Group',
                  style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
            child: Container
            (
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.file_copy,
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Text('My Documents',
                  style: TextStyle(
                    fontSize: 17
                  ),),
                  SizedBox(
                    width: 140,
                  ),
                  Text('0',
                  style:  TextStyle(
                    fontSize: 17
                  ),),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0
          ),
          child: Container(
            height: 50,
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.message
                ),
                SizedBox(
                  width: 32,
                ),
                Text('My Questions',
                style: TextStyle(
                  fontSize: 17
                ),),
                SizedBox(
                  width: 150,
                ),
                Text('0',
                style: TextStyle(
                  fontSize: 17
                ),),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}