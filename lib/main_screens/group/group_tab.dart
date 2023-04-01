import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/createGroup.dart';
import 'package:study_up_app/main_screens/group/group.dart';
import '../../helper/const.dart';
import 'joinGroup.dart';
import 'dart:math' as math;

@immutable
class GroupTab extends StatefulWidget {
  const GroupTab({
    Key? key,
    this.currentUserId,
  }) : super(key: key);

  final String? currentUserId;

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static const _actionTitles = ['Create Post', 'Upload Photo'];
  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  void _goToCreate(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateGroup(),
        ));
  }

  void _goToJoin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const JoinGroup(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user!.uid;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: MainColor,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'My Groups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            Container(
              margin: const EdgeInsets.all(2),
              child: FloatingActionButton.extended(
                heroTag: 'create',
                onPressed: () => _goToCreate(context),
                label: const Text("Create Group"),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2),
              child: FloatingActionButton.extended(
                heroTag: 'join',
                onPressed: () => _goToJoin(context),
                label: const Text("Join Group"),
              ),
            ),
          ],
        ),
        // floatingActionButton: Wrap(
        //   direction: Axis.horizontal,
        //   children: <Widget>[
        //     Container(
        //       margin: const EdgeInsets.all(2),
        //       child: FloatingActionButton.extended(
        //         heroTag: 'create',
        //         onPressed: () => _goToCreate(context),
        //         label: const Text("Create Group"),
        //       ),
        //     ),
        //     Container(
        //       margin: const EdgeInsets.all(2),
        //       child: FloatingActionButton.extended(
        //         heroTag: 'join',
        //         onPressed: () => _goToJoin(context),
        //         label: const Text("Join Group"),
        //       ),
        //     ),
        //   ],
        // ),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("groups")
                  .where('members', arrayContains: uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        final group = snap[index];
                        return Card(
                          color: BGColor,
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              snap[index]['groupName'],
                            ),
                            leading: const Icon(
                              Icons.diversity_3,
                              size: 40,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Group(group)));
                              // Navigator.pushNamed(context, '/group', arguments: group);
                            },
                          ),
                        );
                      });
                } else {
                  return const SizedBox();
                }
              }),
        ));
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
