import 'package:flutter/material.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}
