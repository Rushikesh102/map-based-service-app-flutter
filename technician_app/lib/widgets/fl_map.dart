import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
class FlMap extends StatefulWidget {
  MapController mapController = MapController();
  LatLng user_location=LatLng(0, 0);
  late List<Marker> showMarker = [];
  var sliderVal = 100.0;
  String NavDay =
      "https://api.mapbox.com/styles/v1/rushikesh13/clj1o50hp00t301qyhk651x1l/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnVzaGlrZXNoMTMiLCJhIjoiY2xqMWJlMzUwMTRpYzNycWh0aTZmaGtmOCJ9.d7GiHYEFpcOFMozLto0_cQ";
  String NavNight =
      "https://api.mapbox.com/styles/v1/rushikesh13/clj1o9gsc00dn01qq5ua8a0s9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnVzaGlrZXNoMTMiLCJhIjoiY2xqMWJlMzUwMTRpYzNycWh0aTZmaGtmOCJ9.d7GiHYEFpcOFMozLto0_cQ";
  bool isNight = false;
  FlMap({
    required this.mapController,
  required this.showMarker,
  required this.sliderVal,
  required this.user_location,
  required this.NavNight,
  required this.NavDay,
  required this.isNight
});

  @override
  State<FlMap> createState() => _FlMapState();
}

class _FlMapState extends State<FlMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        center: widget.user_location,
        zoom: 17.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: (widget.isNight == false) ? widget.NavDay : widget.NavNight,
          userAgentPackageName: 'com.example.app',
          additionalOptions: {
            'accessToken':
            'pk.eyJ1IjoicnVzaGlrZXNoMTMiLCJhIjoiY2xqMWJlMzUwMTRpYzNycWh0aTZmaGtmOCJ9.d7GiHYEFpcOFMozLto0_cQ',
            'id': 'mapbox.mapbox-streets-v8'
          },
        ),
        MarkerLayer(
          markers: widget.showMarker,
        ),
        CircleLayer(
          circles: [
            CircleMarker(
                point: widget.user_location,
                color: Colors.blue.withOpacity(0.3),
                borderStrokeWidth: 3.0,
                borderColor: Colors.blue,
                useRadiusInMeter: true,
                radius: widget.sliderVal //radius
            ),
          ],
        ),
      ],
    );
  }
}
