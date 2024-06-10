// // ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print, unused_element, use_key_in_widget_constructor
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/constants/pallete.dart';
// import 'package:flutter_application_0/home/ui/original_home_screen.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class Profi extends StatefulWidget {
//   @override
//   _ProfiState createState() => _ProfiState();
// }

// class _ProfiState extends State<Profi> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController pincodeController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController localityController = TextEditingController();

//   bool makeDefault = false;
//   bool isHomeSelected = false;
//   bool isWorkSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//           child: Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(8.0),
//             child: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20.0),
//               const Center(
//                 child: CircleAvatar(
//                   backgroundImage: AssetImage('assets/images/man-user-circle-icon.png'), // Adjust the path as per your image location
//                   radius: 50.0,
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               _buildTextField('Name*', nameController),
//               const SizedBox(height: 10.0),
//               _buildTextField('Mobile Number*', mobileController),
//               const SizedBox(height: 20.0),
//               _buildTextField('Pincode*', pincodeController),
//               const SizedBox(height: 10.0),
//               _buildTextField('House No*', addressController),
//               const SizedBox(height: 10.0),
//               _buildTextField('Locality/Town*', localityController),
//               const SizedBox(height: 20.0),

//               const SizedBox(height: 10.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         isHomeSelected = true;
//                         isWorkSelected = false;
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isHomeSelected ? Colors.green : Pallete.darkgreenColor,
//                       minimumSize: const Size(100.0, 40.0),
//                     ),
//                     child: const Text(
//                       'Home',
//                       style: TextStyle(fontSize: 14.0, color: Colors.black),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         isWorkSelected = true;
//                         isHomeSelected = false;
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isWorkSelected ? Colors.green : Pallete.darkgreenColor,
//                       minimumSize: const Size(100.0, 40.0),
//                     ),
//                     child: const Text(
//                       'Work',
//                       style: TextStyle(fontSize: 14.0, color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         color: Colors.black,
//         padding: const EdgeInsets.all(20.0),
//         child: ElevatedButton(
//           onPressed: () async {
//             saveAddress();
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.orange,
//             minimumSize: const Size(double.infinity, 50.0),
//           ),
//           child: const Text('Save', style: TextStyle(fontSize: 16.0, color: Colors.black)),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainHeading(String title, Color color) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//       margin: const EdgeInsets.only(bottom: 10.0),
//       child: Center(
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15.0,
//             fontWeight: FontWeight.w300,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     bool isEmpty = controller.text.isEmpty;

//     return TextField(
//       controller: controller,
//       style: const TextStyle(color: Colors.black),
//       decoration: InputDecoration(
//         labelText: label + (isEmpty ? '*' : ''),
//         labelStyle: const TextStyle(color: Colors.black),
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: isEmpty ? Colors.red : Pallete.darkgreenColor),
//         ),
//       ),
//     );
//   }

//   void saveAddress() async {
//     SharedPreferences    sharedPref = await SharedPreferences.getInstance();
//     String? storedUserId = sharedPref.getString('user_id');

//      final url = Uri.parse(
//       'http://${Pallete.ipaddress}:8000/api/orders/delivery/address/');
//   final Map<String, dynamic> data = {
//     "user_id": storedUserId,
//     "address_details": {
//       "phone": mobileController.text,
//       "name": nameController.text,
//       "pincode": pincodeController.text,
//       "house_no": addressController.text,
//       "locality": localityController.text,

//     }
//   };
//     final response = await http.post(
//       url,
//       body: json.encode(data),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     );

//     print(response.body);
//     print(response.statusCode);

//     if (response.statusCode == 201) {
//       saveData(context);
//       // ignore: use_build_context_synchronously

//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Address saved successfully'),
//       ));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Failed to save address'),
//       ));
//     }
//   }

//   Future<void> saveData(BuildContext context) async {
//     String? stUserId = await _loadUserId(); // Load the user ID here
//     if (stUserId == null) {
//       print('User ID is null');
//       return;
//     }

//     // Save user data
//     String firstName = nameController.text;
//     String lastName = pincodeController.text;
//     String address1 = addressController.text;
//     String address2 = localityController.text;
//     String phoneNumber = mobileController.text;

//     // Prepare the data to be sent
//     Map<String, dynamic> userData = {
//       'user': stUserId,
//       'first_name': firstName,
//       'last_name': lastName,
//       'address1': address1,
//       'address2': address2,
//       'phone_number': phoneNumber,
//     };

//     // Convert data to JSON
//     String jsonData = jsonEncode(userData);

//     // Define your API endpoint
//     String apiUrl =
//         'http://${Pallete.ipaddress}:8000/api/user/details/form/';

//     try {
//       print(jsonData);
//       // Make POST request to your API
//       var response = await http.post(
//         Uri.parse(apiUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonData,
//       );

//       // Check if the request was successful
//       if (response.statusCode == 201) {
//         print('User data saved successfully');
//         // Navigate to the home screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const Home1(),
//           ),
//         );
//       } else {
//         print(
//             'Failed to save user data. Status code: ${response.statusCode}');
//         // Handle error
//       }
//     } catch (error) {
//       print('Error saving user data: $error');
//       // Handle error
//     }
//   }

//   Future<String?> _loadUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? storedUserId = prefs.getString('user_id');
//     return storedUserId;
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profi extends StatefulWidget {
  @override
  _ProfiState createState() => _ProfiState();
}

class _ProfiState extends State<Profi> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController localityController = TextEditingController();

  bool makeDefault = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                const Icon(
                  Icons.person,
                  size: 100.0,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Please fill in your details to continue',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildTextField('Name*', nameController),
                const SizedBox(height: 10.0),
                _buildTextField('Mobile Number*', mobileController),
                const SizedBox(height: 20.0),
                _buildTextField('Pincode', pincodeController),
                const SizedBox(height: 10.0),
                _buildTextField('House No', addressController),
                const SizedBox(height: 10.0),
                _buildTextField('Locality/Town', localityController),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home1()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.darkgreenColor,
                minimumSize: const Size(150.0, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    mobileController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Name and Mobile Number are required'),
                  ));
                } else {
                  saveAddress();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.greenColor,
                minimumSize: const Size(150.0, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Pallete.darkgreenColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Pallete.greenColor),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 241, 243, 244),
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
        "pincode": pincodeController.text.isEmpty ? '000000' : pincodeController.text,
        "house_no": addressController.text.isEmpty ? 'N/A' : addressController.text,
        "locality": localityController.text.isEmpty ? 'N/A' : localityController.text,
      }
    };
    final response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.statusCode);
    if (response.statusCode == 201) {
      saveData(context,storedUserId!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Address saved successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to save address'),
      ));
    }
  }

  Future<void> saveData(BuildContext context, String id) async {
    String firstName = nameController.text.isEmpty ? 'N/A':nameController.text;
    String lastName = pincodeController.text.isEmpty ? 'N/A' : pincodeController.text;
    String address1 = addressController.text.isEmpty ? 'N/A' : addressController.text;
    String address2 = localityController.text.isEmpty ? 'N/A' : localityController.text;
    String phoneNumber = mobileController.text.isEmpty? 'N/A':mobileController.text;

    Map<String, dynamic> userData = {
      'user':id,
      'first_name': firstName,
      'last_name': lastName,
      'address1': address1,
      'address2': address2,
      'phone_number': phoneNumber,
    };

    String jsonData = jsonEncode(userData);
    String apiUrl = 'http://${Pallete.ipaddress}:8000/api/user/details/form/';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home1(),
          ),
        );
      } else {
        print('Failed to save user data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error saving user data: $error');
    }
  }
}
