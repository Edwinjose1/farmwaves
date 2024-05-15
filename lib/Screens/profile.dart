import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'address1': address1,
      'address2': address2,
      'phone_number': phoneNumber,
    };
  }
}

class ApiService {
  static const String baseUrl = 'http://192.168.1.44:8000/api/user/';

  static Future<UserDetails> fetchUserDetails(int userId) async {
    final response = await http.get(Uri.parse('http://192.168.1.44:8000/api/user/details/1/'));

    if (response.statusCode == 200) {
      print(response.body);
      return UserDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

 static Future<void> updateUserDetails(UserDetails userDetails) async {
  final Map<String, dynamic> requestBody = {
    'user_id': userDetails.id.toString(), // Include user_id in the request body
    ...userDetails.toJson(), // Include other user details
  };

  final response = await http.put(
    Uri.parse('http://192.168.1.44:8000/api/user/update/'),
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
  final int userId;

  UserDetailsScreen({required this.userId});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late Future<UserDetails> _futureUserDetails;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserDetails _userDetails;

  @override
  void initState() {
    super.initState();
    _futureUserDetails = ApiService.fetchUserDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: FutureBuilder<UserDetails>(
        future: _futureUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _userDetails = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPersonalInfoSection(_userDetails),
                  SizedBox(height: 20.0),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPersonalInfoSection(UserDetails userDetails) {
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
          title: Text('${userDetails.firstName  } ${userDetails.lastName}'),
         
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(userDetails.phoneNumber),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('${userDetails.address1}'),
           subtitle: Text("${userDetails.address2}"),
        ),
     
        ElevatedButton(
          onPressed: () {
            _showEditDialog(userDetails);
          },
          child: Text('Edit'),
        ),
      ],
    );
  }

  void _showEditDialog(UserDetails userDetails) {
    TextEditingController firstNameController = TextEditingController(text: userDetails.firstName);
    TextEditingController lastNameController = TextEditingController(text: userDetails.lastName);
    TextEditingController address1Controller = TextEditingController(text: userDetails.address1);
    TextEditingController address2Controller = TextEditingController(text: userDetails.address2);
    TextEditingController phoneNumberController = TextEditingController(text: userDetails.phoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User Details'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: address1Controller,
                    decoration: InputDecoration(labelText: 'Address 1'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: address2Controller,
                    decoration: InputDecoration(labelText: 'Address 2'),
                  ),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                print('hello');
                if (_formKey.currentState!.validate()) {
                  // Update user details
                  UserDetails updatedUserDetails = UserDetails(
                    id: userDetails.id,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    address1: address1Controller.text,
                    address2: address2Controller.text,
                    phoneNumber: phoneNumberController.text,
                  );
                  await ApiService.updateUserDetails(updatedUserDetails);
                  setState(() {
                    _futureUserDetails = ApiService.fetchUserDetails(widget.userId);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
