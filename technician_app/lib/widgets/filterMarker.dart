import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' show cos, sqrt, asin, sin;

class FilterMarker{
  LatLng user_location = LatLng(0, 0);
  List ind = []; // for storing index
  FilterMarker({
    required this.user_location,
    required this.ind,
});
  // Calculating distance between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Radius of the earth in meters
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    double distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

// Filter the markers based on distance from the center of the circle
  List<Marker> filterMarkers(
      List<Map<String, dynamic>> bookings, LatLng circleCenter, double radius) {
    List<Marker> filteredMarkers = [];
    for (var i = 0; i < bookings.length; i++) {
      double distance = calculateDistance(
        bookings[i]['lat'],
        bookings[i]['lng'],
        circleCenter.latitude,
        circleCenter.longitude,
      );
      if (distance <= radius) {
        print(LatLng(
          bookings[i]['lat'],
          bookings[i]['lng'],
        ));
        Marker marker = Marker(
          point: LatLng(
            bookings[i]['lat'],
            bookings[i]['lng'],
          ),
          builder: (ctx) => Container(
            child: Icon(
              Icons.location_pin,
              size: 50,
              color: Colors.redAccent,
            ),
          ),
        );
        filteredMarkers.add(marker);
        ind.add(i);
      }
    }
    // Add a marker for showing the user location
    filteredMarkers.add(
      Marker(
        point: user_location,
        builder: (ctx) => Container(
          child: Icon(
            Icons.location_history_outlined,
            size: 50,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
    print(ind);
    return filteredMarkers;
  }
}