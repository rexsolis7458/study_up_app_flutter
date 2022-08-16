import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget
{
  final String? currentUserId;

  HomeTab({Key? key, this.currentUserId}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.blue[550],
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              SizedBox(
                width: 30,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    contentPadding: EdgeInsets.all(14),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Search Topic or Group Name",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400])
                  ),
                )
              ),
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
          )
        ),
      ),
    );
  }
}