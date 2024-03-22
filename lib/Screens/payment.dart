import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ItemDetailsPage extends StatefulWidget {
  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  void openCheckout() {
    var options = {
      'key': 'YOUR_KEY_HERE', // Replace with your Razorpay API key
      'amount': 40000, // Amount in the smallest currency unit (in this case, paise)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your existing UI code here
      bottomNavigationBar: Container(
        // Your existing bottom navigation bar code here
        child: ElevatedButton(
          onPressed: () {
            openCheckout(); // Call this function when user clicks "Proceed to Pay"
          },
          child: Text('Proceed to Pay', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
