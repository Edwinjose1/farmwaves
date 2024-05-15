
import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/address_Screen.dart';

class Address {
  String name;
  String address1;
  String address2;
  String city;
  String state;
  String zipCode;
  bool isSelected;

  Address({
    required this.name,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isSelected = false,
  });
}

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<Address> userAddresses = [
    Address(
      name: 'John Doe',
      address1: '123 Main St',
      address2: 'Apt 101',
      city: 'Cityville',
      state: 'Stateville',
      zipCode: '12345',
    ),
    Address(
      name: 'Jane Smith',
      address1: '456 Elm St',
      address2: 'Unit 202',
      city: 'Townville',
      state: 'Stateville',
      zipCode: '67890',
    ),

  ];

  int selectedAddressIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 239, 245),
      appBar: AppBar(
  backgroundColor: Colors.white,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Select Address:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                Address? newAddress = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressFormFields()),
                );
            
                // Check if a new address was returned
                if (newAddress != null) {
                  setState(() {
                    userAddresses.add(newAddress);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                textStyle: TextStyle(color: Colors.white),
              ),
              child: Text('Create New Address', style: TextStyle(color: Colors.white)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userAddresses.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${userAddresses[index].name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Address:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(userAddresses[index].address1,
                              style: TextStyle(color: Colors.black)),
                          Text(userAddresses[index].address2,
                              style: TextStyle(color: Colors.black)),
                          SizedBox(height: 5),
                          Text(
                            '${userAddresses[index].city}, ${userAddresses[index].state} ${userAddresses[index].zipCode}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Radio(
                        value: index,
                        groupValue: selectedAddressIndex,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            selectedAddressIndex = value as int;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
