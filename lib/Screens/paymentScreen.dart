import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final int orderId;

  PaymentScreen({required this.orderId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  double tipAmount = 0.0;
  double _totalAmount = 100.0; // Initial total amount
  double _gst = 0.18; // GST rate (18% in this case)
  double _shippingCharge = 0.0; // Initial shipping charge
  late bool _isPaymentEnabled;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _isPaymentEnabled = false; // Initially payment is disabled
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // Start a timer to poll the server for updates every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      fetchOrderStatus(); // Fetch order status periodically
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    _timer.cancel(); // Cancel the timer when the screen is disposed
  }

  void fetchOrderStatus() async {
    try {
      // Perform an HTTP GET request to fetch the order status
      final response = await http.get(Uri.parse('http://192.168.1.44:8000/api/orders/status/${widget.orderId}/'));
      if (response.statusCode == 200) {
        // Handle the response
        final data = jsonDecode(response.body);
        setState(() {
          _isPaymentEnabled = data['isPaymentEnabled'];
          _shippingCharge = data['shippingCharge'];
        });
      } else {
        // Handle error response
        print('Failed to fetch order status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error fetching order status: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code.toString()} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void openCheckout() {
    if (_razorpay != null) {
      var options = {
        'key': 'rzp_test_X9hAUDDX3tQpM4',
        'amount': ((_totalAmount + tipAmount) * 100).toInt(),
        'name': 'Your App Name',
        'description': 'Payment for items',
        'prefill': {'contact': '', 'email': ''},
        'external': {
          'wallets': ['paytm']
        }
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint('Error: ${e.toString()}');
      }
    } else {
      debugPrint("Razorpay is not initialized");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animation/customersupport.json',
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.width / 1.5,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 30),
              Text(
                _isPaymentEnabled ? "Proceed with Payment" : "Processing Your Order",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              // Bill details
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bill Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount:",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "\$$_totalAmount",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GST (18%):",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "\$${(_totalAmount * _gst).toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    _shippingCharge != 0.0 ? SizedBox(height: 10) : Container(),
                    _shippingCharge != 0.0
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping Charge:",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "\$$_shippingCharge",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                        : Container(),
                    Divider(), // Divider for visual separation
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        openCheckout();
                      },
                      // onPressed: _isPaymentEnabled
                      //     ? () {
                      //   print(widget.orderId);
                        
                      // }
                      //     : null,
                      style: ElevatedButton.styleFrom(
                        primary: _isPaymentEnabled ? Colors.green : Colors.grey,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Proceed to Pay',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
