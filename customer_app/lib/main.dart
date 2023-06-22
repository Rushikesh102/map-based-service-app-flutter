import 'package:customer_app/widgets/confirm.dart';
import 'package:customer_app/widgets/recenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:customer_app/widgets/locatrioniq.dart';

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
      14.484244, 78.815853); // can also be taken from the device location
  LatLng current_marker = LatLng(
      14.484244, 78.815853); // used to store location of the current marker
  bool isNight = false; //variable for night mode
  bool isAvailable = false;
  TextEditingController sType = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController searchController = TextEditingController();
  MapController mapController = MapController();
  Map<String, dynamic> address = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Container(
          // Add padding around the search bar
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          // Use a Material design search bar
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (s) async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (searchController.text != "") {
                      try {
                        var locationIQ = LocationIQ();
                        Future<LatLng> coord =
                            locationIQ.getLatLng(searchController.text);
                        LatLng ll = await coord;
                        setState(() {
                          current_marker = ll; //updating current marker
                          mapController.move(current_marker, 17);
                        });
                      } catch (e) {
                        throw e;
                      }
                    }
                    ;
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.blue),

                    // Add a search icon or button to the search bar
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (searchController.text != "") {
                          try {
                            var locationIQ = LocationIQ();
                            Future<LatLng> coord =
                            locationIQ.getLatLng(searchController.text);
                            LatLng ll = await coord;
                            setState(() {
                              current_marker = ll;
                              mapController.move(current_marker, 17);
                            });
                          }catch (e) {
                            throw e;
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),

              // Add a clear button to the search bar
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.blue,
                ),
                onPressed: () => searchController.clear(),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Help"),
                  content: Text("Long press on a map location to add marker."),
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
      ),
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
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
                center: current_marker,
                zoom: 17.0,
                onTap: (TapPosition, latlng) async {
                  // current_marker = latlng;
                  var locationIQ = LocationIQ();
                  Future<Map<String, dynamic>> a = locationIQ.getAddress(
                      latlng.latitude.toString(), latlng.longitude.toString());
                  address = await a;
                  print(address);
                  String pin = address['address']['postcode'];
                  // print(pin);
                  setState(() {
                    current_marker = latlng;
                    mapController.move(current_marker, 17);

                    if (pin != '516001') {
                      isAvailable = false;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Attention"),
                          content: Text(
                              "We apologize, but our services are not yet available in the selected location. Please choose another area for service."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      isAvailable = true;
                    }
                  });
                }),
            children: [
              TileLayer(
                urlTemplate: (isNight == false) ? NavDay : NavNight,
                userAgentPackageName: 'com.example.app',
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoicnVzaGlrZXNoMTMiLCJhIjoiY2xqMWJlMzUwMTRpYzNycWh0aTZmaGtmOCJ9.d7GiHYEFpcOFMozLto0_cQ',
                  'id': 'mapbox.mapbox-streets-v8'
                },
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: current_marker,
                    builder: (ctx) => Container(
                      child: (user_location != current_marker)
                          ? Icon(
                              Icons.location_pin,
                              size: 50,
                              color: Colors.redAccent,
                            )
                          : Text(""),
                    ),
                  ),
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
                ],
              ),
            ],
          ),
          RecenterButton(
            mapController: mapController,
            user_location: user_location,
            current_marker: current_marker,
          ),
          ConfirmButton(
            address: address,
            name: name,
            phone: phone,
            sType: sType,
            current_marker: current_marker,
            isAvailable: isAvailable,
          ),
        ],
      ),
    );
  }
}
