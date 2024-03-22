import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';


class User {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;

  User({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });
}

class Order {
  final String orderNumber;
  final String status;

  Order({required this.orderNumber, required this.status});
}

class ProfilePage extends StatelessWidget {
  final User user = User(
    name: 'John Doe',
    email: 'john.doe@example.com',
    phoneNumber: '+1234567890',
    address: '123 Main Street, City, Country',
  );

  final List<Order> orders = [
    Order(orderNumber: 'Order #1234', status: 'Delivered'),
    Order(orderNumber: 'Order #5678', status: 'Processing'),
    Order(orderNumber: 'Order #9012', status: 'Cancelled'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

          appBar: AppBar(
  backgroundColor: Pallete.whiteColor,
  leading: GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0), // Adjust padding as needed
      child: Icon(
        Icons.arrow_back_ios, // Use the Cupertino-style back button icon
        color: Colors.black,
      ),
    ),
  ),
),
        
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPersonalInfoSection(),
              SizedBox(height: 20.0),
              _buildOrderHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        ListTile(
          leading: Icon(Icons.person),
          title: Text(user.name),
          subtitle: Text(user.email),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(user.phoneNumber),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text(user.address),
        ),
      ],
    );
  }

  Widget _buildOrderHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Orders',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Column(
          children: orders.map((order) {
            return _buildOrderItem(order);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOrderItem(Order order) {
    return ListTile(
      title: Text(order.orderNumber),
      subtitle: Text('Status: ${order.status}'),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        // Navigate to order details page
      },
    );
  }
}
