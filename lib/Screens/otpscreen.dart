import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/orderprocessingpage.dart';

class OTPScreen extends StatefulWidget {
  final int orderId; // Define orderId as a parameter

  OTPScreen({required this.orderId}); // Constructor to receive orderId
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    if (value.length != 4) {
      return 'OTP must be a 4-digit number';
    }
    return null;
  }

  Future<void> verifyOTPWithBackend() async {
    
    String otp = _otpControllers.map((controller) => controller.text).join();
    // Here you should implement the logic to send the OTP to your Django backend for verification
    // For example, you can use HTTP package to make a POST request to your Django backend API
    // You can replace this with your actual backend integration code
    print('Verifying OTP with backend: $otp');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  OrderProcessingPage(orderId:widget.orderId,)),
    );
    // Example:
    // final response = await http.post(
    //   'your_backend_url/verify_otp',
    //   body: {'otp': otp},
    // );
    // if (response.statusCode == 200) {
    //   // OTP verification successful, handle accordingly
    // } else {
    //   // OTP verification failed, handle accordingly
    // }
  }

  void resendOTP() {
    // Implement your logic to resend OTP here
    print('Resending OTP...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal[100],
                        border: Border.all(
                          color: Colors.teal,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: _otpControllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.length == 1 &&
                              index < _otpControllers.length - 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is validated, now you can proceed with OTP verification
                    verifyOTPWithBackend();
                  }
                },
                child: Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: resendOTP,
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}


