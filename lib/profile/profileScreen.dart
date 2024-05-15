// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/constants/pallete.dart';
// import 'package:flutter_application_0/home/ui/original_home_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _address1Controller = TextEditingController();
//   final TextEditingController _address2Controller = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();

//   void saveData() {
//     // Save user data
//     String firstName = _firstNameController.text;
//     String lastName = _lastNameController.text;
//     String address1 = _address1Controller.text;
//     String address2 = _address2Controller.text;
//     String phoneNumber = _phoneNumberController.text;

//     // Print or send data to backend
//     print('First Name: $firstName');
//     print('Last Name: $lastName');
//     print('Address 1: $address1');
//     print('Address 2: $address2');
//     print('Phone Number: $phoneNumber');
    
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   color: Pallete.greenColor,
//                   child: Center(),
//                 ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 20),
//                       _buildTextField('First Name', _firstNameController),
//                       SizedBox(height: 20), // Added space
//                       _buildTextField('Last Name', _lastNameController),
//                       SizedBox(height: 20), // Added space
//                       _buildHorizontalTextField(
//                           'Address 1',
//                           _address1Controller,
//                           'Address 2',
//                           _address2Controller),
//                       SizedBox(height: 20), // Added space
//                       _buildTextField('Phone Number', _phoneNumberController),
//                       SizedBox(height: 20), // Added space
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => Home1(),
//                                 ),
//                               );
//                             },
//                             child: Text('Skip',
//                                 style: TextStyle(color: Colors.white)),
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.grey,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed:() {
//                               saveData();
//                                Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => Home1(),
//                                 ),
//                               );
//                             },
//                             child: Text('Submit',
//                                 style: TextStyle(color: Colors.white)),
//                             style: ElevatedButton.styleFrom(
//                               primary: Pallete.greenColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             top: 50,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 5,
//                       blurRadius: 7,
//                       offset: Offset(0, 3), // changes position of shadow
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     'assets/images/prof.png', // Adjust with your image path
//                     width: 150,
//                     height: 150,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(String hint, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: hint,
//         labelStyle: TextStyle(color: Color(0xFF333333)), // Hash color
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.black),
//         ),
//         contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       ),
//     );
//   }

//   Widget _buildHorizontalTextField(
//       String hint1,
//       TextEditingController controller1,
//       String hint2,
//       TextEditingController controller2) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildTextField(hint1, controller1),
//         ),
//         SizedBox(width: 20),
//         Expanded(
//           child: _buildTextField(hint2, controller2),
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> saveData(BuildContext context) async {
    // Save user data
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String address1 = _address1Controller.text;
    String address2 = _address2Controller.text;
    String phoneNumber = _phoneNumberController.text;

    // Prepare the data to be sent
    Map<String, String> userData = {
      'first_name': firstName,
      'last_name': lastName,
      'address1': address1,
      'address2': address2,
      'phone_number': phoneNumber,
    };

    // Convert data to JSON
    String jsonData = jsonEncode(userData);

    // Define your API endpoint
    String apiUrl = 'http://192.168.1.44:8000/api/user/details/';

    try {
      // Make POST request to your API
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('User data saved successfully');
        // Navigate to the home screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home1(),
          ),
        );
      } else {
        print('Failed to save user data. Status code: ${response.statusCode}');
        // Handle error
      }
    } catch (error) {
      print('Error saving user data: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Pallete.greenColor,
                  child: Center(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      _buildTextField('First Name', _firstNameController),
                      SizedBox(height: 20), // Added space
                      _buildTextField('Last Name', _lastNameController),
                      SizedBox(height: 20), // Added space
                      _buildHorizontalTextField(
                          'Address 1',
                          _address1Controller,
                          'Address 2',
                          _address2Controller),
                      SizedBox(height: 20), // Added space
                      _buildTextField('Phone Number', _phoneNumberController),
                      SizedBox(height: 20), // Added space
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home1(),
                                ),
                              );
                            },
                            child: Text('Skip',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              saveData(context); // Call saveData with context
                            },
                            child: Text('Submit',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              primary: Pallete.greenColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/prof.png', // Adjust with your image path
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: Color(0xFF333333)), // Hash color
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildHorizontalTextField(
      String hint1,
      TextEditingController controller1,
      String hint2,
      TextEditingController controller2) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(hint1, controller1),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _buildTextField(hint2, controller2),
        ),
      ],
    );
  }
}
