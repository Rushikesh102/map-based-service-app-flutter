import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
class RecenterButton extends StatefulWidget {
  MapController mapController=MapController();
  LatLng user_location=LatLng(0, 0);
  LatLng current_marker=LatLng(0, 0);
  RecenterButton({
    required this.mapController,
    required this.user_location,
    required this.current_marker,
});
  @override
  State<RecenterButton> createState() => _RecenterButtonState();
}

class _RecenterButtonState extends State<RecenterButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: Wrap(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.mapController.move(widget.user_location, 17);
                          });
                        },
                        icon: Icon(Icons.gps_fixed),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.mapController.move(widget.current_marker, 17);
                          });
                        },
                        icon: Icon(Icons.location_pin,color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
