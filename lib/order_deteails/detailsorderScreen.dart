import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_application_0/order_deteails/addresssection.dart';
import 'package:flutter_application_0/order_deteails/medicineitems.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ItemDetailsPage extends StatefulWidget {
  final List<Medicine> medicalDetails; // Accept medical details
  final double totalAmount; // Accept total amount
  final String selectedAddress; // Define selectedAddress here
  ItemDetailsPage({
    required this.medicalDetails,
    required this.totalAmount,
    required this.selectedAddress,
  }); // Constructor

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late Razorpay _razorpay;
  double tipAmount = 0.0; // Initialize tip amount

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
    print("Payment Success: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print("Payment Error: ${response.code.toString()} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print("External Wallet: ${response.walletName}");
  }

  void openCheckout() {
    if (_razorpay != null) {
      var options = {
        'key': 'rzp_test_X9hAUDDX3tQpM4', // Replace with your Razorpay API key
        'amount': ((widget.totalAmount + tipAmount) * 100).toInt(),
        'name': 'Your App Name',
        'description': 'Payment for items',
        'prefill': {'contact': '', 'email': ''},
        'external': {'wallets': ['paytm']}
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            AddressSection(widget.selectedAddress),

            _buildSectionContainer(
              'Medicine Details',
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.medicalDetails.length,
                itemBuilder: (context, index) {
                  final med = widget.medicalDetails[index];
                  return MedicineItem(name: med.name, quantity: med.quantity);
                },
              ),
            ),
            SizedBox(height: 10), // Add some spacing between sections
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Give tip for Delivery partner',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTipDialog(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Pallete.darkgreenColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Add Tip',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            _buildSectionContainer(
              'Bill Details',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBillItem('Total Amount', 'Rs. ${widget.totalAmount.toStringAsFixed(2)}'),
                  Divider(),
                  _buildBillItem('GST', 'Rs. ${(widget.totalAmount * 0.18).toStringAsFixed(2)}'), // Assuming GST is 18%
                  Divider(),
                  _buildBillItem('Tip Amount', 'Rs. ${tipAmount.toStringAsFixed(2)}'), // Display tip amount
                  Divider(),
                  _buildBillItem('To Pay', 'Rs. ${(widget.totalAmount + tipAmount).toStringAsFixed(2)}'), // Display total amount with tip
                  // Add your other bill details here if needed
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Pallete.darkgreenColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Amount: Rs. ${(widget.totalAmount + tipAmount).toStringAsFixed(2)}', // Display total amount with tip
              style: TextStyle(fontSize: 18.0, color: Colors.white,fontWeight: FontWeight.w800),
            ),
            ElevatedButton(
              onPressed: () {
                openCheckout();
              },
              child: Text('Proceed to Pay', style: TextStyle()),
            ),
          ],
        ),
      ),
    );
  }

  void _showTipDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Tip"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter Tip Amount"),
                onChanged: (value) {
                  setState(() {
                    tipAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionContainer(String heading, Widget content) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10.0),
          content,
        ],
      ),
    );
  }

  Widget _buildBillItem(String label, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
