import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget? child;

  const ShadowContainer({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(80.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(
                5.0,
                5.0,
              ),
            )
          ],
        ));
  }
}
