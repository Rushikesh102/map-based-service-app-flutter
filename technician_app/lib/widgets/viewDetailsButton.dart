import 'package:flutter/material.dart';
import 'package:technician_app/pages/details.dart';
class ViewDetailsButton extends StatelessWidget {

  bool isRadSet = false,isNight = false;
  List<Map<String, dynamic>> bookings = [];
  List ind = [];

  ViewDetailsButton({
  required this.bookings,
  required this.isRadSet,
  required this.ind,
  required this.isNight,
});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewDetails(
                i: ind,
                bookings: bookings,
                isNight: isNight,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "View Details",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
