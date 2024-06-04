import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/myorder/models/models.dart';
import 'package:flutter_application_0/myorder/widgets/orderDetailpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: use_key_in_widget_constructors
class MyOrdersPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<OrderTileData> orders = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Introduce a 1 second delay before fetching orders
    Future.delayed(const Duration(seconds: 1), () {
      fetchOrders();
      // Start periodic timer to fetch orders every 5 seconds
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        fetchOrders();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> fetchOrders() async {
    setState(() {
      // isLoading = true; // Start loading
    });

    String? userId = await getUserIdFromSharedPreferences();

    final response = await http.get(Uri.parse('http://${Pallete.ipaddress}:8000/api/orders/user/$userId/'));

    if (response.statusCode == 200) {
      List<dynamic> orderList = json.decode(response.body);
      setState(() {
        orders = orderList.map((order) => OrderTileData.fromJson(order)).toList();
        // isLoading = false; // End loading
      });
    } else {
      setState(() {
        // isLoading = false; // End loading
      });
      throw Exception('Failed to load orders');
    }
  }

  Future<String?> getUserIdFromSharedPreferences() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? storedUserId = sharedPref.getString('user_id');

    return storedUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(orderId: orders[index].id),
                ),
              );
            },
            child: OrderTile(order: orders[index]),
          );
        },
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final OrderTileData order;

  // ignore: use_key_in_widget_constructors
  const OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    IconData icon;
    switch (order.status) {
      case 'approved':
        dotColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Pending':
        dotColor = Colors.yellow;
        icon = Icons.info;
        break;
      case 'reject open':
        dotColor = Colors.blue;
        icon = Icons.cancel;
        break;
      case 'reject close':
      case 'cancelled':
      // case 'Cancelled by User':
        dotColor = Colors.red;
        icon = Icons.cancel;
        break;
         case 'delivered':
      // case 'Cancelled by User':
        dotColor = const Color.fromARGB(255, 111, 88, 4);
        icon = Icons.cancel;
        break;
         case 'Cancelled by User':
      // case 'Cancelled by User':
        dotColor = const Color.fromARGB(255, 0, 0, 0);
        icon = Icons.cancel;
        break;
        
      default:
        dotColor = const Color.fromARGB(255, 173, 255, 85);
        icon = Icons.help_outline;
        break;
    }

    // Additional case for delivery status 'complete'
    if (order.deliveryStatus == 'complete') {
      dotColor = Colors.blue; // Change color for complete status
      icon = Icons.done; // Change icon for complete status
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white, // Set a stable color for the tile background
      child: ListTile(
        leading: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        title: Text(
          'Order ID: QM-0024-${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Delivery Address: ${order.deliveryAddress}\nTotal Price: ${order.totalPrice}',
          style: TextStyle(color: Colors.grey[700]),
        ),
        trailing: Text(order.status),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(orderId: order.id)
            ),
          );
        },
      ),
    );
  }
}
