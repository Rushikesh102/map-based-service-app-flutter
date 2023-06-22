import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:customer_app/widgets/showSheet.dart';
class ConfirmButton extends StatelessWidget {
  Map<String, dynamic> address = {};
  TextEditingController sType = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  LatLng current_marker = LatLng(0,0);
  bool isAvailable = false;

  ConfirmButton({
  required this.address,
  required this.name,
  required this.phone,
  required this.sType,
  required this.current_marker,
  required this.isAvailable,
});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              ElevatedButton(
                onPressed: !isAvailable
                    ? null
                    : () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return ShowSheet(
                          current_marker: current_marker,
                          sType: sType,
                          phone: phone,
                          name: name,
                          address: address,
                        );
                      });
                },
                style: ButtonStyle(),
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Confirm Booking Spot",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
