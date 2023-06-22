import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationIQ{
  Future<Map<String, dynamic>> getAddress(lat, long) async {
    var key = "pk.31f9eac5cd472dddf39895b938ea994f";
    final response = await http.get(Uri.parse(
        'https://us1.locationiq.com/v1/reverse?key=' +
            key +
            '&lat=' +
            lat +
            '&lon=' +
            long +
            '&format=json')); //getting the response from locationiq api

    final decoded = json.decode(response.body)
    as Map<String, dynamic>; //converting it from json to key value pair
    // print(decoded);
    return (decoded);
  }

  Future<LatLng> getLatLng(search) async {
    var key = "pk.31f9eac5cd472dddf39895b938ea994f";
    final response = await http.get(Uri.parse(
        'https://us1.locationiq.com/v1/search?key=' +
            key +
            '&q=' +
            search +
            '&format=json')); //getting the response from location api

    final decoded = json.decode(response.body)
    as List<dynamic>; //converting it from json to key value pair
    double lat = double.parse(decoded[0]['lat']);
    double lon = double.parse(decoded[0]['lon']);
    LatLng coord = LatLng(lat, lon);
    return (coord);
  }
}