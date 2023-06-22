import 'package:flutter/material.dart';

class BarApp extends StatelessWidget implements PreferredSizeWidget {
  const BarApp({Key? key}) : super(key: key);
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.help),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Help"),
                content: Text("Select a suitable radius and click on 'Confirm Radius' button to filter bookings. Then Click 'View Details' button."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.blueAccent),
    );
  }
}
