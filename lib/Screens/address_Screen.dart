import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/change_address.dart';
import 'package:flutter_application_0/Screens/location.dart';
import 'package:flutter_application_0/constants/pallete.dart';

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
  bool isHomeSelected = false; // Track selection for Home
  bool isWorkSelected = false; // Track selection for Work

  Map<String, double>? selectedLocationData; // Track selected location data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(8.0), // Adjust padding as needed
            child: Icon(
              Icons.arrow_back_ios, // Use the Cupertino-style back button icon
              color: Colors.white,
            ),
          ),
        ),
      ),
      // Set background color to white
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainHeading('Contact Details',
                  const Color.fromARGB(255, 45, 44, 44)), // Change heading background color
              SizedBox(height: 10.0),
              _buildTextField('Name', nameController),
              SizedBox(height: 10.0),
              _buildTextField('Mobile Number', mobileController),
              SizedBox(height: 20.0),
              _buildMainHeading(
                  'Address', Color.fromARGB(255, 45, 44, 44)), // Change heading background color
              SizedBox(height: 10.0),
              _buildTextField('Pincode', pincodeController),
              SizedBox(height: 10.0),
              _buildTextField('House No', addressController),
              SizedBox(height: 10.0),
              _buildTextField('Locality/Town', localityController),
              SizedBox(height: 20.0),
              _buildMainHeading('Save Address as',
                Color.fromARGB(255, 45, 44, 44)
                  ), // Change heading background color
              SizedBox(height: 10.0),  
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
                    child: Text(
                      'Home',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white), // Change button text color
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: isHomeSelected ? Pallete.darkgreenColor : Colors.grey,
                      minimumSize: Size(100.0, 40.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isWorkSelected = true;
                        isHomeSelected = false;
                      });
                    },
                    child: Text(
                      'Work',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white), // Change button text color
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: isWorkSelected ? Pallete.darkgreenColor : Colors.grey,
                      minimumSize: Size(100.0, 40.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Checkbox(
                    value: makeDefault,
                    onChanged: (value) {
                      setState(() {
                        makeDefault = value!;
                      });
                    },
                  ),
                  Text('Make this my default address',
                      style: TextStyle(fontSize: 14.0, color: Colors.white)),
                ],
              ),
              SizedBox(height: 20.0),
              _buildMainHeading(' Select Delivery Location',
                  Color.fromARGB(255, 45, 44, 44)), // Change heading background color
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  ).then((value) {
                    if (value != null) {
                      double latitude = value['latitude'];
                      double longitude = value['longitude'];
                      setState(() {
                        selectedLocationData = {
                          'latitude': latitude,
                          'longitude': longitude
                        };
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Pallete.darkgreenColor,
                  minimumSize: Size(double.infinity, 40.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Select Location',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            // Get entered values
            Address newAddress = Address(
              name: nameController.text,
              address1: addressController.text,
              address2:
                  "", // You can add logic to get the second address line if needed
              city: "", // Add logic to get city
              state: "", // Add logic to get state
              zipCode: pincodeController.text,
            );

            // Return new address to previous page
            Navigator.of(context).pop(newAddress);
          },
          child: Text('Save',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white)), // Change button text color
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            minimumSize: Size(double.infinity, 50.0),
          ),
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
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
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
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
