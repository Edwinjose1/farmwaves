// ignore_for_file: use_build_context_synchronously, avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddressFormFields extends StatefulWidget {
  @override
  _AddressFormFieldsState createState() => _AddressFormFieldsState();
}

class _AddressFormFieldsState extends State<AddressFormFields> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController localityController = TextEditingController();

  bool makeDefault = false;
  bool isHomeSelected = false;
  bool isWorkSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainHeading(
                  'Contact Details', const Color.fromARGB(255, 45, 44, 44)),
              const SizedBox(height: 10.0),
              _buildTextField('Name', nameController),
              const SizedBox(height: 10.0),
              _buildTextField('Mobile Number', mobileController),
              const SizedBox(height: 20.0),
              _buildMainHeading('Address', const Color.fromARGB(255, 45, 44, 44)),
              const SizedBox(height: 10.0),
              _buildTextField('Pincode', pincodeController),
              const SizedBox(height: 10.0),
              _buildTextField('House No', addressController),
              const SizedBox(height: 10.0),
              _buildTextField('Locality/Town', localityController),
              const SizedBox(height: 20.0),
              _buildMainHeading(
                  'Save Address as', const Color.fromARGB(255, 45, 44, 44)),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isHomeSelected = true;
                        isWorkSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isHomeSelected ? Colors.green : Colors.grey,
                      minimumSize: const Size(100.0, 40.0),
                    ),
                    child: const Text(
                      'Home',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isWorkSelected = true;
                        isHomeSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isWorkSelected ? Colors.green : Colors.grey,
                      minimumSize: const Size(100.0, 40.0),
                    ),
                    child: const Text(
                      'Work',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: saveAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 50.0),
          ),
          child: const Text('Save',
              style: TextStyle(fontSize: 16.0, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildMainHeading(String title, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  void saveAddress() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? storedUserId = sharedPref.getString('user_id');

    final url = Uri.parse(
        'http://${Pallete.ipaddress}:8000/api/orders/delivery/address/');
    final Map<String, dynamic> data = {
      "user_id": storedUserId,
      "address_details": {
        "phone": mobileController.text,
        "name": nameController.text,
        "pincode": pincodeController.text,
        "house_no": addressController.text,
        "locality": localityController.text,
        "type": isHomeSelected
      }
    };

    final response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.body);

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Address saved successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to save address'),
      ));
    }
  }
}
