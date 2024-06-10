// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';
// import 'package:flutter_application_0/authentication/ui/login_screen1.dart';
// import 'package:flutter_application_0/constants/pallete.dart';
// import 'package:flutter_application_0/profile/profileScreen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class SignupScreen extends StatelessWidget {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   SignupScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Brightness brightness = Theme.of(context).brightness;
//     Color textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

// Future<void> sendNotificatio() async {
//   print("hai");
//   final String serverKey = 'AIzaSyCsJVvtKgSQoEzgpA7yCisa1ezTltKSLK0';
//   final String firebaseUrl = 'https://fcm.googleapis.com/v1/projects/pushnotifica-c39fa/messages:send';

//   final Map<String, dynamic> message = {
//     'message': {
//       'token': 'coglwMqPRaK9BQcXWv5QVd:APA91bGoI_FH-TfAVxEooPPKUoFqMCU-K_n7hf8-VBXTG-NBYMgpiQ-1o1zVf4_3w7YwxY3UcEP-_2okY63ri25Tdosvf2ykIeMgsmRURFlHwaQo2xPQkWz_rlVUH-FeevplQnxtZINE',
//       'notification': {
//         'title': 'Notification Title',
//         'body': 'Notification Body',
//       },
//     },
//   };

//   final http.Response response = await http.post(
//     Uri.parse(firebaseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $serverKey',
//     },
//     body: jsonEncode(message),
//   );

//   if (response.statusCode == 200) {
//     print('Notification sent successfully.');
//   } else {
//     print('Failed to send notification. Error: ${response.body}');
//   }
// }
//     return Scaffold(
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthFailure) {
//             print("Authentication failed");
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor: Colors.black,
//                 content: Text(
//                   state.error,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 duration: const Duration(seconds: 1),
//               ),
//             );
//           }

//           if (state is SignupSuccess) {
//             print("Signup success");
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => Profi()),
//               (route) => false,
//             );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: ListView(
//             children: [
//               const SizedBox(height: 0),
//               Center(
//                 child: Image.asset(
//                   "assets/images/quickmed.png",
//                   height: 80,
//                   width: 200,
//                   alignment: Alignment.center,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Sign Up',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const Text(
//                 'Create an account to get started',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w300,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 style: TextStyle(color: textColor),
//                 controller: usernameController,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(
//                     Icons.person,
//                     color: Colors.grey,
//                   ),
//                   labelText: "Username",
//                   enabledBorder: myInputBorder(),
//                   focusedBorder: myFocusBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 style: TextStyle(color: textColor),
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(
//                     Icons.email,
//                     color: Colors.grey,
//                   ),
//                   labelText: "Email",
//                   enabledBorder: myInputBorder(),
//                   focusedBorder: myFocusBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 style: TextStyle(color: textColor),
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(
//                     Icons.lock,
//                     color: Colors.grey,
//                   ),
//                   labelText: "Password",
//                   enabledBorder: myInputBorder(),
//                   focusedBorder: myFocusBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 style: TextStyle(color: textColor),
//                 controller: confirmPasswordController,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(
//                     Icons.lock,
//                     color: Colors.grey,
//                   ),
//                   labelText: "Confirm Password",
//                   enabledBorder: myInputBorder(),
//                   focusedBorder: myFocusBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   String username = usernameController.text.trim();
//                   String email = emailController.text.trim();
//                   String password = passwordController.text.trim();
//                   String confirmPassword = confirmPasswordController.text.trim();

//                   if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         backgroundColor: Colors.black,
//                         content: Text(
//                           'All fields are required.',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   } else {
//                     context.read<AuthBloc>().add(
//                       AuthSignupRequested(
//                         username: username,
//                         email: email,
//                         password: password,
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 15.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                   backgroundColor: Pallete.greenColor,
//                 ),
//                 child: const Text(
//                   'Sign up',
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Already have an account?',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const LoginScreen()),
//                       );
//                     },
//                     child: const Text(
//                       'Log in',
//                       style: TextStyle(
//                         color: Pallete.greenColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   OutlineInputBorder myInputBorder() {
//     return OutlineInputBorder(
//       borderSide: const BorderSide(
//         style: BorderStyle.solid,
//         color: Color.fromARGB(255, 193, 190, 190),
//         width: 1.3,
//       ),
//       borderRadius: BorderRadius.circular(30),
//     );
//   }

//   OutlineInputBorder myFocusBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(30),
//       borderSide: const BorderSide(
//         style: BorderStyle.solid,
//         color: Color.fromARGB(255, 193, 190, 190),
//         width: 1.3,
//       ),
//     );
//   }

// }

import 'package:flutter/material.dart';
import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';
import 'package:flutter_application_0/authentication/ui/login_screen1.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/profile/profileScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_phone_number_field/flutter_phone_number_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'otp_verification_screen.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    Color textColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.black,
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          }

          if (state is SignupSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Profi()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 0),
              Center(
                child: Image.asset(
                  "assets/images/quickmed.png",
                  height: 80,
                  width: 200,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Create an account to get started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: textColor),
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  labelText: "Username",
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: textColor),
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  labelText: "Email",
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: textColor),
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  labelText: "Password",
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: textColor),
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  labelText: "Confirm Password",
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  String username = usernameController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  String confirmPassword =
                      confirmPasswordController.text.trim();

                  if (username.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.black,
                        content: Text(
                          'All fields are required.',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    context.read<AuthBloc>().add(
                          AuthSignupRequested(
                            username: username,
                            email: email,
                            password: password,
                          ),
                        );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Pallete.greenColor,
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhoneNumberInputScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor:Pallete.darkgreenColor,
                ),
                child: const Text(
                  'Sign up with number',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Pallete.greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 193, 190, 190),
        width: 1.3,
      ),
      borderRadius: BorderRadius.circular(30),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 193, 190, 190),
        width: 1.3,
      ),
    );
  }
}

class PhoneNumberInputScreen extends StatefulWidget {
  @override
  _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number Input'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter your phone number',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Assuming FlutterPhoneNumberField is a widget you've defined elsewhere
                // Replace this with your actual phone number input widget
                FlutterPhoneNumberField(
                  controller: _phoneNumberController,
                  initialCountryCode: 'IN',
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  pickerDialogStyle: PickerDialogStyle(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Send OTP
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OTPInputScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo, // Set the background color
                    onPrimary: Colors.white, // Set the text color
                    elevation: 0, // Set the elevation for the button shadow
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Set the border radius
                    ),
                  ),
                  child: Text('Send OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OTPInputScreen extends StatefulWidget {
  @override
  _OTPInputScreenState createState() => _OTPInputScreenState();
}

class _OTPInputScreenState extends State<OTPInputScreen> {
  // Define your custom styles for the OTP fields
  List<TextStyle?> otpTextStyles = List.generate(6, (index) => null);

  // Define your accent purple color
  Color accentPurpleColor = Color.fromARGB(255, 12, 25, 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Input'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter your OTP',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Use the custom OtpTextField widget
                OtpTextField(
                  numberOfFields: 6, // Set the number of OTP fields
                  borderColor: accentPurpleColor, // Set the border color
                  focusedBorderColor:
                      accentPurpleColor, // Set the focused border color
                  styles: otpTextStyles, // Set the text styles for each field
                  showFieldAsBox:
                      true, // Set whether to show the fields as boxes
                  borderWidth: 4.0, // Set the border width
                  // Define what happens when the code changes
                  onCodeChanged: (String code) {
                    // Handle validation or checks here if necessary
                    print('Code changed: $code');
                  },
                  // Define what happens when the OTP is submitted
                  onSubmit: (String verificationCode) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Verify OTP
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Verify OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
