import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:technician_app/widgets/bar.dart';
import 'package:technician_app/widgets/fl_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:technician_app/widgets/recenter.dart';
import 'package:technician_app/widgets/viewDetailsButton.dart';
import 'package:technician_app/widgets/filterMarker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String NavDay =
      "https://api.mapbox.com/styles/v1/rushikesh13/clj1o50hp00t301qyhk651x1l/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnVzaGlrZXNoMTMiLCJhIjoiY2xqMWJlMzUwMTRpYzNycWh0aTZmaGtmOCJ9.d7GiHYEFpcOFMozLto0_cQ";
  String NavNight =
      "https://api.mapbox.com/styles/v1/rushikesh13/clj1o9gsc00dn01qq5ua8a0s9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnVzaGlrZXNoMTMiLCJhIjoiY2xqMWJlMzUwMTRpYzNycWh0aTZmaGtmOCJ9.d7GiHYEFpcOFMozLto0_cQ";
  LatLng user_location = LatLng(
      14.479399, 78.821649); // can also be taken from the device location
  bool isNight = false; //variable for night mode
  var sliderVal = 100.0;
  bool isRadSet = false;
  MapController mapController = MapController();
  List<Map<String, dynamic>> bookings = [];
  List ind = []; // for storing index
  late List<Marker> showMarker = [
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
  ];

  // Fetching the data from bookings collection from the Firestore
  Future<List<Map<String, dynamic>>> getData() async {
    await Firebase.initializeApp();
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("bookings").get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BarApp(),
      drawer: Drawer(
        backgroundColor: (isNight == false) ? Colors.white : Colors.black,
        child: ListView(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.blueAccent,
            ),
            TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("About"),
              ),
            ),
            ListTile(
              title: Text(
                "Night Mode",
                style: TextStyle(color: Colors.blueAccent),
              ),
              trailing: Switch(
                value: isNight,
                onChanged: (value) {
                  setState(() {
                    isNight = value;
                  });
                },
                activeTrackColor: Colors.blueAccent,
                activeColor: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          FlMap(
            mapController: mapController,
            showMarker: showMarker,
            sliderVal: sliderVal,
            user_location: user_location,
            NavNight: NavNight,
            NavDay: NavDay,
            isNight: isNight,
          ),
          // IconButton to recenter
          RecenterButton(
            mapController: mapController,
            user_location: user_location,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        (isRadSet)
                            ? ViewDetailsButton(
                                bookings: bookings,
                                isRadSet: isRadSet,
                                ind: ind,
                                isNight: isNight,
                              )
                            : Text(""),
                        Row(
                          children: [
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 10.0,
                                  trackShape: RectangularSliderTrackShape(),
                                ),
                                child: Slider(
                                  min: 100,
                                  max: 15000,
                                  divisions: 14900,
                                  value: sliderVal,
                                  label: sliderVal.round().toString() + " m",
                                  onChanged: (value) {
                                    setState(() {
                                      sliderVal = value;
                                    });
                                  },
                                ),
                              ),
                              flex: 1,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Future<List<Map<String, dynamic>>> res =
                                    getData();
                                bookings = await res;
                                ind = [];
                                var fObject = FilterMarker(
                                    user_location: user_location, ind: ind);
                                var fm = fObject.filterMarkers(
                                    bookings, user_location, sliderVal);
                                setState(() {
                                  showMarker = fm;
                                  isRadSet = true;
                                });
                              },
                              child: Text("Confirm Radius"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
