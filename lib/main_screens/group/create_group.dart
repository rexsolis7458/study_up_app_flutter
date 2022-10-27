import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/group.dart';


class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  @override
  Widget build(BuildContext context) =>
      DefaultTabController(length: 4, child: Scaffold(appBar: AppBar()));

  

}
