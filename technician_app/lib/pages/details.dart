import 'package:flutter/material.dart';

class ViewDetails extends StatelessWidget {
  List i = [];
  List<String> keys = [
    'name',
    'phone',
    'serviceType',
    'address',
    'date',
  ];
  List<Map<String, dynamic>> bookings = [];
  bool isNight = false;
  ViewDetails({required this.i, required this.bookings, required this.isNight});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: (i.length != 0)
          ? Container(
              height: double.infinity,
              color: (isNight) ? Colors.blueGrey : Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: i.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.blueAccent, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ExpansionTile(
                        leading: Text((index + 1).toString()),
                        title: Text(bookings[i[index]]['serviceType'] +
                            " ( " +
                            bookings[i[index]]['phone'] +
                            " )"),
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var k in keys)
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          k.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            bookings[i[index]][k].toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text("Schedule the visit"))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Text("NO BOOKINGS IN THIS AREA"),
            ),
    );
  }
}
