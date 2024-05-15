import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  PaymentButton({required this.onPressed, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: enabled
          ? Color.fromARGB(255, 41, 163, 57)
          : Color.fromARGB(255, 150, 146, 146),
      padding: EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(enabled
              ? Color.fromARGB(255, 166, 186, 169)
              : Color.fromARGB(255, 71, 72, 71)),
        ),
        onPressed: enabled
            ? onPressed
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'You can make payment after the confirmation call'),
                  ),
                );
              },
        child: Text('Pay Now', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class Buildsection extends StatelessWidget {
  const Buildsection({
    super.key,
    required this.heading,
    required this.content,
  });

  final String heading;
  final Widget content;

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: 10.0),
          content,
        ],
      ),
    );
  }
}

class BillItem extends StatelessWidget {
  const BillItem({
    super.key,
    required this.label,
    required this.amount,
  });

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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

class Paynow extends StatelessWidget {
  const Paynow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 230, 230, 230),
      padding: EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 184, 142, 15))),
        onPressed: () {
          // Action to perform when payment button is pressed
        },
        child: Text('Pay Now', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

