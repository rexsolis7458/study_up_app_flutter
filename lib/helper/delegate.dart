import 'package:flutter/material.dart';

class _MyLayoutDelegate extends MultiChildLayoutDelegate {

  @override
bool shouldRelayout(_MyLayoutDelegate oldDelegate) {
  // Return true if any of the layout parameters have changed
  return false;
}
  // Define the size of the layout
  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  // Position each child in the layout
  @override
  void performLayout(Size size) {
    // Determine the width and height of each child
    final double width = size.width;
    final double height = size.height;

    // Layout each child based on its ID
    if(hasChild(0)) { // Layout the first child with ID 0
      layoutChild(0, BoxConstraints.tight(size));
      positionChild(0, Offset.zero);
    }
  }
}