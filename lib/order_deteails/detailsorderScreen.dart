// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/order_deteails/bloc/item_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_application_0/Screens/orderprocessingpage.dart';
// import 'package:flutter_application_0/constants/pallete.dart';
// import 'package:flutter_application_0/model/medicinedatamodel.dart';
// import 'package:flutter_application_0/order_deteails/addresssection.dart';
// import 'package:flutter_application_0/order_deteails/medicineitems.dart';
// import 'package:flutter_application_0/order_deteails/widget/Widgets.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:http/http.dart' as http;

// class ItemDetailsPage extends StatefulWidget {
//   final List<Medicine> medicalDetails;
//   final double totalAmount;
//   final String selectedAddress;

//   ItemDetailsPage({
//     required this.medicalDetails,
//     required this.totalAmount,
//     required this.selectedAddress,
//   });

//   @override
//   _ItemDetailsPageState createState() => _ItemDetailsPageState();
// }

// class _ItemDetailsPageState extends State<ItemDetailsPage> {
//   late Razorpay _razorpay;
//   double tipAmount = 0.0;

//   late WebSocketChannel channel;

//   Map<String, dynamic> orderData = {}; // Store order data

//   @override
//   void dispose() {
//     channel.sink.close(); // Close WebSocket connection
//     super.dispose();
//     _razorpay.clear();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Establish WebSocket connection to your server
//     try {
//       // Establish WebSocket connection
//       channel = IOWebSocketChannel.connect('ws://192.168.1.44:8080');
//     } catch (e) {
//       print('Error connecting to WebSocket: $e');
//       // Handle the error (e.g., display an error message to the user)
//     }

//     channel.stream.listen((message) {
//       // Handle incoming WebSocket messages
//       print('Received message: $message');
//       setState(() {
//         orderData = json.decode(message);
//       });
//     });
//   }

//   bool showBottomNavigationBar = true;

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     bool enablePayment = true;

//     return BlocProvider(
//       create: (context) => ItemdetailsBloc(),
//       child: Scaffold(
//           backgroundColor: Colors.white,
//           body: SingleChildScrollView(
//             padding: EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 AddressSection(widget.selectedAddress),
//                 Buildsection(
//                   heading: 'Medicine Details',
//                   content: ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: widget.medicalDetails.length,
//                     itemBuilder: (context, index) {
//                       final med = widget.medicalDetails[index];
//                       return MedicineItem(
//                         name: med.name,
//                         quantity: med.quantity,
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Give tip for Delivery partner',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           _showTipDialog(context);
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 12.0, vertical: 8.0),
//                           decoration: BoxDecoration(
//                             color: Pallete.darkgreenColor,
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child: Text(
//                             'Add Tip',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Buildsection(
//                   heading: 'Bill Details',
//                   content: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BillItem(
//                         label: 'Total Amount',
//                         amount: 'Rs. ${widget.totalAmount.toStringAsFixed(2)}',
//                       ),
//                       Divider(),
//                       BillItem(
//                         label: 'GST',
//                         amount:
//                             'Rs. ${(widget.totalAmount * 0.18).toStringAsFixed(2)}',
//                       ),
//                       Divider(),
//                       BillItem(
//                         label: 'Tip Amount',
//                         amount: 'Rs. ${tipAmount.toStringAsFixed(2)}',
//                       ),
//                       Divider(),
//                       BillItem(
//                         label: 'To Pay',
//                         amount:
//                             'Rs. ${(widget.totalAmount + tipAmount).toStringAsFixed(2)}',
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: buildBottomNavigationBar()),
//     );
//   }

//   void _showTipDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Add Tip"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: "Enter Tip Amount"),
//                 onChanged: (value) {
//                   setState(() {
//                     tipAmount = double.tryParse(value) ?? 0.0;
//                   });
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget buildBottomNavigationBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Pallete.darkgreenColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10.0),
//           topRight: Radius.circular(10.0),
//         ),
//       ),
//       padding: EdgeInsets.all(20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Amount: Rs. ${(widget.totalAmount + tipAmount).toStringAsFixed(2)}',
//             style: TextStyle(
//                 fontSize: 18.0,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w800),
//           ),
//           ElevatedButton(
//             style: ButtonStyle(
//               backgroundColor: MaterialStatePropertyAll(
//                 Color.fromARGB(255, 184, 142, 15),
//               ),
//             ),
//             onPressed: () async {
//               Map<String, dynamic> orderData = constructOrderData();
//               sendOrderData(orderData);
//               print(orderData);
//               // Call the bloc to post order details

//               // Navigate to the next page
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => OrderProcessingPage()),
//               );
//               setState(() {
//                 showBottomNavigationBar = false;
//               });
//             },
//             child: Text(
//               'Continue',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Function to construct the JSON object
//   Map<String, dynamic> constructOrderData() {
//     List<Map<String, dynamic>> items = [];

//     // Construct the items list
//     for (var med in widget.medicalDetails) {
//       items.add({
//         'id': med.id, // Add medicine ID
//         'name': med.name,
//         'quantity': med.quantity,
//         'price': med.price,
//       });
//     }

//     // Construct the order data
//     Map<String, dynamic> orderData = {
//       'user': 2,
//       'status': 'false',
//       'total_price': widget.totalAmount,
//       'delivery_address': widget.selectedAddress,
//       'payment_method': 'Credit Card',
//       'items': items,
//     };

//     return orderData;
//   }
// }
// Future<int?> sendOrderData(Map<String, dynamic> orderData) async {
//   try {
//     final response = await http.post(
//       Uri.parse('http://192.168.1.44:8000/api/orders/'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(orderData),
//     );

//     if (response.statusCode == 201) {
//       // Parse the response body to extract the order ID
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       final int orderId = responseData['id'];
      
//       // Handle success response
//       print('Order data sent successfully. Order ID: $orderId');
      
//       // Return the order ID
//       return orderId;
//     } else {
//       // Handle error response
//       print('Failed to send order data: ${response.statusCode}');
//       return null; // Return null indicating failure
//     }
//   } catch (e) {
//     print('Error sending order data: $e');
//     return null; // Return null indicating failure
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/otpscreen.dart';
import 'package:flutter_application_0/order_deteails/bloc/item_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_0/Screens/orderprocessingpage.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_application_0/order_deteails/addresssection.dart';
import 'package:flutter_application_0/order_deteails/medicineitems.dart';
import 'package:flutter_application_0/order_deteails/widget/Widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class ItemDetailsPage extends StatefulWidget {
  final List<Medicine> medicalDetails;
  final double totalAmount;
  final String selectedAddress;

  ItemDetailsPage({
    required this.medicalDetails,
    required this.totalAmount,
    required this.selectedAddress,
  });

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late Razorpay _razorpay;
  double tipAmount = 0.0;

  late WebSocketChannel channel;

  Map<String, dynamic> orderData = {}; // Store order data

  @override
  void dispose() {
    channel.sink.close(); // Close WebSocket connection
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    // Establish WebSocket connection to your server
    try {
      // Establish WebSocket connection
      channel = IOWebSocketChannel.connect('ws://192.168.1.44:8080');
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      // Handle the error (e.g., display an error message to the user)
    }

    channel.stream.listen((message) {
      // Handle incoming WebSocket messages
      print('Received message: $message');
      setState(() {
        orderData = json.decode(message);
      });
    });
  }

  bool showBottomNavigationBar = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool enablePayment = true;

    return BlocProvider(
      create: (context) => ItemdetailsBloc(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                AddressSection(widget.selectedAddress),
                Buildsection(
                  heading: 'Medicine Details',
                  content: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.medicalDetails.length,
                    itemBuilder: (context, index) {
                      final med = widget.medicalDetails[index];
                      return MedicineItem(
                        name: med.name,
                        quantity: med.quantity,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Give tip for Delivery partner',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showTipDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Pallete.darkgreenColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            'Add Tip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Buildsection(
                  heading: 'Bill Details',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BillItem(
                        label: 'Total Amount',
                        amount: 'Rs. ${widget.totalAmount.toStringAsFixed(2)}',
                      ),
                      Divider(),
                      BillItem(
                        label: 'GST',
                        amount:
                            'Rs. ${(widget.totalAmount * 0.18).toStringAsFixed(2)}',
                      ),
                      Divider(),
                      BillItem(
                        label: 'Tip Amount',
                        amount: 'Rs. ${tipAmount.toStringAsFixed(2)}',
                      ),
                      Divider(),
                      BillItem(
                        label: 'To Pay',
                        amount:
                            'Rs. ${(widget.totalAmount + tipAmount).toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: showBottomNavigationBar
              ? buildBottomNavigationBar()
              : SizedBox()), // Hide bottom navigation bar when needed
    );
  }

  void _showTipDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Tip"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter Tip Amount"),
                onChanged: (value) {
                  setState(() {
                    tipAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Pallete.darkgreenColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Amount: Rs. ${(widget.totalAmount + tipAmount).toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w800),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 184, 142, 15),
              ),
            ),
            onPressed:() {
               Map<String, dynamic> orderData = constructOrderData();
              sendOrderData(orderData);
              _continueButtonPressed();
              print(orderData);
            }, // Call the method here
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Function to construct the JSON object
  Map<String, dynamic> constructOrderData() {
    List<Map<String, dynamic>> items = [];

    // Construct the items list
    for (var med in widget.medicalDetails) {
      items.add({
        'id': med.id, // Add medicine ID
        'name': med.name,
        'quantity': med.quantity,
        'price': med.price,
      });
    }

    // Construct the order data
    Map<String, dynamic> orderData = {
      'user': 2,
      'status': 'false',
      'total_price': widget.totalAmount,
      'delivery_address': widget.selectedAddress,
      'payment_method': 'Credit Card',
      'items': items,
    };

    return orderData;
  }

Future<void> _continueButtonPressed() async {
  Map<String, dynamic> orderData = constructOrderData();
  int? orderId = await sendOrderData(orderData);
  if (orderId != null) {
    // Navigate to the next page with the order ID
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OTPScreen(orderId: orderId,)),
    );

    // Update the state to hide the bottom navigation bar
    setState(() {
      showBottomNavigationBar = false;
    });
  } else {
    // Handle error
    // Show a snackbar or an error message to the user
  }
}

}

Future<int?> sendOrderData(Map<String, dynamic> orderData) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.44:8000/api/orders/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      print(response.body);
      // Parse the response body to extract the order ID
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final int orderId = responseData['order_id'];
      
      // Handle success response
      print('Order data sent successfully. Order ID: $orderId');
      
      // Return the order ID
      return orderId;
    } else {
      // Handle error response
      print('Failed to send order data: ${response.statusCode}');
      return null; // Return null indicating failure
    }
  } catch (e) {
    print('Error sending order data: $e');
    return null; // Return null indicating failure
  }
}


