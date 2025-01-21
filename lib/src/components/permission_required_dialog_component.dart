import 'package:flutter/material.dart';

class PermissionRequiredDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onGrantPermission;

  const PermissionRequiredDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onGrantPermission,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      actionsPadding: EdgeInsets.only(bottom: 0),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onGrantPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Button color
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 15,
              ),
            ),
            child: Text(
              "Grant permission",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
