import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/address_Screen.dart';
import 'package:flutter_application_0/authentication/ui/signup_screen.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/model/cartitemmodel.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_application_0/myorder/widgets/orderDetailpage.dart';
import 'package:flutter_application_0/order_deteails/details_of_order_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddressPage extends StatefulWidget {
  final List<Medicine> medicalDetails;

  const AddressPage({super.key, required this.medicalDetails});
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late Future<List<AddressDetails>> _futureAddressDetails;
  late int userId;
  int selectedAddressId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      setState(() {
        _futureAddressDetails = _loadAddressDetails();
      });
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');
    if (userIdString != null) {
      userId = int.tryParse(userIdString) ?? 0;
    } else {
      userId = 0;
    }
  }

  Future<List<AddressDetails>> _loadAddressDetails() async {
    return ApiService.fetchAddressDetails(userId);
  }

  void _returnSelectedAddress(AddressDetails addressDetails) {
    Navigator.pop(context, addressDetails);
  }

  void _editAddress(AddressDetails addressDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressScreen(
          addressDetails: addressDetails,
          onUpdate: () {
            setState(() {
              _futureAddressDetails = _loadAddressDetails();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 239, 245),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressFormFields()),
                );
                if (result == true) {
                  setState(() {
                    _futureAddressDetails = _loadAddressDetails();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 168, 36),
                shadowColor: const Color.fromARGB(255, 52, 52, 52),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Add new address',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Select Address:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AddressDetails>>(
              future: _futureAddressDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final addressDetailsList = snapshot.data!;
                  return ListView.builder(
                    itemCount: addressDetailsList.length,
                    itemBuilder: (context, index) {
                      final addressDetails = addressDetailsList[index];
                      return _buildAddressContainer(addressDetails);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressContainer(AddressDetails addressDetails) {
    final address =
        '${addressDetails.houseNo}, ${addressDetails.locality}, ${addressDetails.pincode}';
    return GestureDetector(
      onTap: () async {
        saveAddress(addressDetails);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${addressDetails.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Address: ${addressDetails.locality}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'House no: ${addressDetails.houseNo}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Pin code: ${addressDetails.pincode}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    address,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Phone: ${addressDetails.phone}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editAddress(addressDetails),
            ),
          ],
        ),
      ),
    );
  }

  void saveAddress(AddressDetails addressDetails) async {
// update/
// 'http://${Pallete.ipaddress}:8000/api/user/';
    final url = Uri.parse('http://${Pallete.ipaddress}:8000/api/user/update/');
    Map<String, dynamic> userData = {
      'user_id': addressDetails.userId,
      'first_name': addressDetails.name,
      'last_name': addressDetails.phone,
      'address1': addressDetails.pincode,
      'address2': addressDetails.locality,
      'phone_number': addressDetails.houseNo,
    };

    final response = await http.put(
      url,
      body: json.encode(userData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ItemDetailsPage(medicalDetails: widget.medicalDetails)));
              
     
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to save address'),
      ));
    }
  }
}

class ApiService {
  static Future<List<AddressDetails>> fetchAddressDetails(int userId) async {
    final response = await http.get(Uri.parse(
        'http://${Pallete.ipaddress}:8000/api/orders/delivery/address/$userId/'));
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> responseList = jsonDecode(response.body);
      return responseList.map((json) => AddressDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load address details');
    }
  }

  static Future<void> updateAddressDetails(
      Map<String, dynamic> addressDetails, int userId) async {
    final url = Uri.parse(
        'http://${Pallete.ipaddress}:8000/api/orders/delivery/address/$userId/');
    try {
      final response = await http.put(
        url,
        body: jsonEncode(addressDetails),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Address details updated successfully
        print('Address details updated successfully');
      } else {
        // Handle HTTP error response
        print(
            'Failed to update address details. Status Code: ${response.statusCode}');
        throw Exception('Failed to update address details');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error updating address details: $e');
      throw Exception('Failed to update address details');
    }
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
      (route) => false,
    );
  }
}

class EditAddressScreen extends StatefulWidget {
  final AddressDetails addressDetails;
  final Function onUpdate;

  EditAddressScreen({
    required this.addressDetails,
    required this.onUpdate,
  });

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _pincodeController;
  late TextEditingController _houseNoController;
  late TextEditingController _localityController;
  late bool _type;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.addressDetails.name);
    _phoneController = TextEditingController(text: widget.addressDetails.phone);
    _pincodeController =
        TextEditingController(text: widget.addressDetails.pincode);
    _houseNoController =
        TextEditingController(text: widget.addressDetails.houseNo);
    _localityController =
        TextEditingController(text: widget.addressDetails.locality);
    _type = widget.addressDetails.type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _pincodeController,
              decoration: const InputDecoration(labelText: 'Pincode'),
            ),
            TextField(
              controller: _houseNoController,
              decoration: const InputDecoration(labelText: 'House No'),
            ),
            TextField(
              controller: _localityController,
              decoration: const InputDecoration(labelText: 'Locality'),
            ),
            SwitchListTile(
              title: const Text('Type'),
              value: _type,
              onChanged: (bool value) {
                setState(() {
                  _type = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedAddressDetails = AddressDetails(
                  userId: widget.addressDetails.userId,
                  name: _nameController.text,
                  phone: _phoneController.text,
                  pincode: _pincodeController.text,
                  houseNo: _houseNoController.text,
                  locality: _localityController.text,
                  type: _type,
                );
                await ApiService.updateAddressDetails(
                    updatedAddressDetails.toJson(),
                    updatedAddressDetails.userId);
                widget.onUpdate();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressDetails {
  final int userId;
  final String name;
  final String phone;
  final String pincode;
  final String houseNo;
  final String locality;
  final bool type;

  AddressDetails({
    required this.userId,
    required this.name,
    required this.phone,
    required this.pincode,
    required this.houseNo,
    required this.locality,
    required this.type,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    final addressDetails = json['address_details'] ?? {};
    return AddressDetails(
      userId: json['user_id'] ?? 0,
      name: addressDetails['name'] ?? '',
      phone: addressDetails['phone'] ?? '',
      pincode: addressDetails['pincode'] ?? '',
      houseNo: addressDetails['house_no'] ?? '',
      locality: addressDetails['locality'] ?? '',
      type: addressDetails['type'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'address_details': {
        'name': name,
        'phone': phone,
        'pincode': pincode,
        'house_no': houseNo,
        'locality': locality,
        'type': type,
      }
    };
  }
}
