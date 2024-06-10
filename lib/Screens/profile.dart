// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/authentication/ui/signup_screen.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/myorder/screen/myorders.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails {
  final int id;
  final String firstName;
  final String lastName;
  final String address1;
  final String address2;
  final String phoneNumber;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.address2,
    required this.phoneNumber,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address1: json['address1'],
      address2: json['address2'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'address1': address1,
      'address2': address2,
      'phone_number': phoneNumber,
    };
  }
}

class ApiService {
  static const String baseUrl = 'http://${Pallete.ipaddress}:8000/api/user/';

  static Future<UserDetails> fetchUserDetails(int userId) async {
    final response = await http.get(Uri.parse('${baseUrl}details/$userId/'));

    if (response.statusCode == 200) {
      print(response.body);
      return UserDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  static Future<void> updateUserDetails(
      Map<String, dynamic> userDetails, int userId) async {
    final Map<String, dynamic> requestBody = {
      'user_id': userId.toString(),
      ...userDetails,
    };

    final response = await http.put(
      Uri.parse('${baseUrl}update/'),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to update user details');
    }
  }
}

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late Future<UserDetails> _futureUserDetails;
  UserDetails? _userDetails;
  int userId = 4;

  @override
  void initState() {
    super.initState();
    _initializeUserDetails();
  }

  Future<void> _initializeUserDetails() async {
    await _loadUserId();
    setState(() {
      _futureUserDetails = ApiService.fetchUserDetails(userId);
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');
    print(userIdString);
    if (userIdString != null) {
      userId = int.tryParse(userIdString) ?? 0;
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignupScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<UserDetails>(
        future: _futureUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _userDetails = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPersonalInfoSection(_userDetails!),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user details found.'));
          }
        },
      ),
    );
  }

  Widget _buildPersonalInfoSection(UserDetails userDetails) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            _buildDetailItem('Full Name', '${userDetails.firstName} '),
            _buildDetailItem('Pin Code', userDetails.lastName),
            _buildDetailItem('Phone Number', userDetails.phoneNumber),
            _buildDetailItem('Address', userDetails.address1),
            _buildDetailItem('Locality', userDetails.address2),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _showEditDialog(userDetails);
                },
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  void _showEditDialog(UserDetails userDetails) {
    TextEditingController firstNameController =
        TextEditingController(text: userDetails.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: userDetails.lastName);
    TextEditingController address1Controller =
        TextEditingController(text: userDetails.address1);
    TextEditingController address2Controller =
        TextEditingController(text: userDetails.address2);
    TextEditingController phoneNumberController =
        TextEditingController(text: userDetails.phoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User Details'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  _buildEditTextField(
                      firstNameController, 'First Name', 'Enter first name'),
                  _buildEditTextField(
                      lastNameController, 'Pin Code', 'Enter Pin code'),
                  _buildEditTextField(
                      address1Controller, 'House No', 'Enter House No'),
                  _buildEditTextField(address2Controller, 'Address', ''),
                  _buildEditTextField(phoneNumberController, 'Phone Number',
                      'Enter phone number'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_validateInputs([
                  firstNameController,
                  lastNameController,
                  address1Controller,
                  phoneNumberController
                ])) {
                  Map<String, dynamic> updatedUserDetails = {
                    'first_name': firstNameController.text,
                    'last_name': lastNameController.text,
                    'address1': address1Controller.text,
                    'address2': address2Controller.text,
                    'phone_number': phoneNumberController.text,
                  };
                  await ApiService.updateUserDetails(
                      updatedUserDetails, userId);
                  setState(() {
                    _futureUserDetails = ApiService.fetchUserDetails(userId);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditTextField(
      TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  bool _validateInputs(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields.'),
        ));
        return false;
      }
    }
    return true;
  }
}
