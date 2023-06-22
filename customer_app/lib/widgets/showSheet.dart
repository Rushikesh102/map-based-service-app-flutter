import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ShowSheet extends StatelessWidget {
  TextEditingController sType = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  LatLng current_marker = LatLng(14.484244, 78.815853);
  Map<String, dynamic> address = {};

  ShowSheet(
      {required this.current_marker,
      required this.sType,
      required this.phone,
      required this.name,
      required this.address});

  Future<void> uploadingData({
    required String userName,
    required String serviceType,
    required var lat,
    required var lng,
    required var num,
    required var date,
    required String address,
    required String status,
  }) async {
    // String doc_name=num+'/'+date+'/'+serviceType;
    await Firebase.initializeApp();
    await FirebaseFirestore.instance.collection("bookings").doc(num).set({
      'name': userName,
      'phone': num,
      'date': date,
      'serviceType': serviceType,
      'lat': lat,
      'lng': lng,
      'address': address,
      'status': status,
    });
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response, context) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response, context) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    String date = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());
    print(date);
    uploadingData(
        userName: name.text,
        serviceType: sType.text,
        lat: current_marker.latitude,
        lng: current_marker.longitude,
        num: phone.text,
        date: date,
        address: address['display_name'],
        status: "paid");
    name.clear();
    phone.clear();
    sType.clear();
    Navigator.pop(context);
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response, context) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  controller: name,
                  decoration: InputDecoration(
                      labelText: "Name", hintText: "Enter Your Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  controller: phone,
                  decoration: InputDecoration(
                      labelText: "Contact",
                      hintText: "Enter Your Contact Number"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  controller: sType,
                  decoration: InputDecoration(
                      labelText: "Type of Service",
                      hintText: "Enter the Type of Service."),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Amount : ₹500.00",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              if (name.text.isNotEmpty ||
                                  sType.text.isNotEmpty ||
                                  phone.text.isNotEmpty) {
                                Razorpay razorpay = Razorpay();
                                var options = {
                                  'key': 'rzp_live_ILgsfZCZoFIKMb',
                                  'amount': 100, // for demo amount is one rupee
                                  'name': 'Kagav Technologies LLP',
                                  'description': 'Service Cost',
                                  'retry': {'enabled': true, 'max_count': 1},
                                  'send_sms_hash': true,
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': 'test@razorpay.com'
                                  },
                                  'external': {
                                    'wallets': ['paytm']
                                  }
                                };
                                razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                    handlePaymentErrorResponse);
                                razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                    handlePaymentSuccessResponse);
                                razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                    handleExternalWalletSelected);
                                razorpay.open(options);
                              }
                              ;
                            },
                            child: Text(
                              "Pay using RazorPay",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              String date = DateFormat("dd-MM-yyyy HH:mm:ss")
                                  .format(DateTime.now());
                              print(date);
                              if (name.text.isNotEmpty ||
                                  sType.text.isNotEmpty ||
                                  phone.text.isNotEmpty) {
                                uploadingData(
                                    userName: name.text,
                                    serviceType: sType.text,
                                    lat: current_marker.latitude,
                                    lng: current_marker.longitude,
                                    num: phone.text,
                                    date: date,
                                    address: address['display_name'],
                                    status: "COD");
                              }
                              ;
                              name.clear();
                              phone.clear();
                              sType.clear();
                              Navigator.pop(context);
                              showAlertDialog(
                                  context, "Booking Successful", "Nearest technician will contact soon.");
                            },
                            child: Text(
                              "Pay COD",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
