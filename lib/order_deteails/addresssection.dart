import 'package:flutter/material.dart';

import 'package:flutter_application_0/Screens/change_address.dart'; // Import your address page file here

class AddressSection extends StatelessWidget {
  final String selectedAddress;

  AddressSection(this.selectedAddress);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: Row(
            children: [
              GestureDetector(
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
            ],
          ),
        ),
        SizedBox(height: 20),
        _buildSectionContainer(
          'Delivery Address',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedAddress,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Edit Address',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Change Address',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionContainer(String title, Widget content) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.0),
          content,
        ],
      ),
    );
  }
}
