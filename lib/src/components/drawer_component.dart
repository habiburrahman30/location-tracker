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
        borderSide: BorderSide.none,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFF7643), // Background color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40, // Profile image size
                  child: FlutterLogo(size: 40), // Replace with user's image
                ),
                SizedBox(height: 5), // Spacing
                Text(
                  'John Doe', // Replace with user's name
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: 5),
                Text(
                  'johndoe@email.com', // Replace with user's email
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                // SizedBox(height: 5),
                // Text(
                //   '123 Main Street, City, Country', // Replace with user's address
                //   style: TextStyle(
                //     color: Colors.white70,
                //     fontSize: 14,
                //   ),
                // ),
              ],
            ),
          ),
          ListTile(
            title: Text('Background Mode'),
            trailing: Switch(
              value: false,
              onChanged: (value) async {},
            ),
            onTap: () async {},
            dense: true,
          ),
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(
              value: false,
              onChanged: (value) async {},
            ),
            dense: true,
            onTap: () async {},
          ),
        ],
      ),
    );
  }
}
