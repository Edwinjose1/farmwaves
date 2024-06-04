// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_final_fields

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_application_0/Screens/ordersucess.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  double _shippingCharge = 10.0; // Initial shipping charge
  bool _isPaymentEnabled = false;
  bool _isLoading = true; // Flag to track whether data is loading
  Timer? _timer;
  TextEditingController _couponController = TextEditingController();
  String? _appliedCoupon;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchOrderStatus();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchOrderStatus();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    _timer?.cancel();
    _couponController.dispose();
    super.dispose();
  }

  Future<void> fetchOrderStatus() async {
    try {
      // Mocking the order status response for demonstration
      final response = await Future.delayed(const Duration(seconds: 1), () {
        return {
          'status': 'approved',
          'shippingCharge': _shippingCharge,
        };
      });

      setState(() {
        _isPaymentEnabled = response['status'] == 'approved';
        _shippingCharge = response['shippingCharge'] as double? ?? 0.0;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching order status: $e');
    }
  }

  Future<int?> updatePaymentStatus(int orderId) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://${Pallete.ipaddress}:8000/api/orders/status/update/$orderId/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': 'payment success'}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('Payment status updated successfully for order ID: $orderId');
        return orderId;
      } else {
        print('Failed to update payment status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating payment status: $e');
      return null;
    }
  }

  Future<int?> updateOrderPaymentMethod(
      int orderId, String paymentMethod) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://${Pallete.ipaddress}:8000/api/orders/payment/method/update/$orderId/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'payment_method': paymentMethod}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('Payment method updated successfully for order ID: $orderId');
        return orderId;
      } else {
        print('Failed to update payment method: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating payment method: $e');
      return null;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await updatePaymentStatus(widget.orderId);
    await updateOrderPaymentMethod(widget.orderId, 'online');
    print("Payment Success: ${response.paymentId}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Ordersuccesspage()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code.toString()} - ${response.message}");
    // Handle payment error, e.g., display error message to user
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
    // Handle external wallet payment, if needed
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_X9hAUDDX3tQpM4',
      'amount': ((_totalAmount + tipAmount) * 100).toInt(),
      'name': 'Quick Med',
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

  void applyCoupon(String couponCode) {
    if (couponCode == "QUICKMED200") {
      _appliedCoupon = couponCode;
      setState(() {
        _totalAmount -= 20; // Assuming a discount of 200
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Coupon'),
          content: const Text('The coupon code you entered is invalid.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _couponController,
                            decoration: const InputDecoration(
                              labelText: 'Apply Coupon',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            applyCoupon(_couponController.text);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20), // Added spacing
                            // Added spacing
                            _buildItemRow('Product Name 1', '₹100.00'),
                            const SizedBox(height: 10), // Added spacing
                            _buildItemRow('Product Name 2', '₹20.00'),
                            const SizedBox(height: 10), // Added spacing
                            _buildItemRow('Product Name 3', '₹300.00'),
                            const SizedBox(height: 20), // Added spacing
                            const Divider(),
                            const SizedBox(height: 20), // Added spacing
                            _buildPriceRow('Subtotal', '₹600.00'),
                            const SizedBox(height: 10), // Added spacing
                            _buildPriceRow('Shipping Charge',
                                '₹${_shippingCharge.toStringAsFixed(2)}'),
                            const SizedBox(height: 10), // Added spacing
                            _buildPriceRow('GST (18%)',
                                '₹${(_totalAmount * _gst).toStringAsFixed(2)}'),
                            if (_appliedCoupon != null) ...[
                              const SizedBox(height: 10), // Added spacing
                              _buildPriceRow(
                                'Coupon Discount',
                                '-₹20.00', // Assuming discount amount
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                            const SizedBox(height: 20), // Added spacing
                            _buildPriceRow(
                              'Total',
                              '₹${(_totalAmount + _shippingCharge + (_totalAmount * _gst)).toStringAsFixed(2)}',
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isPaymentEnabled
                          ? () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Choose Payment Method'),
                                  content: const Text('Select Payment Method'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await updatePaymentStatus(
                                            widget.orderId);
                                        await updateOrderPaymentMethod(
                                            widget.orderId, 'cash');
                                        // Navigator.pop(context);
                                        // await updateOrderPaymentMethod(widget.orderId, 'cash on delivery');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Ordersuccesspage(),
                                          ),
                                        );
                                      },
                                      child: const Text('Cash on Delivery'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        openCheckout();
                                      },
                                      child: const Text('Online Payment'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                       backgroundColor: _isPaymentEnabled ? Colors.green : Colors.grey,
                        shadowColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Pay',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildItemRow(String itemName, String itemPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(itemName),
        Text(itemPrice),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {FontWeight? fontWeight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
