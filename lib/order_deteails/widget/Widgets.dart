import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  // ignore: use_key_in_widget_constructors
  const PaymentButton({required this.onPressed, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: enabled
          ? const Color.fromARGB(255, 41, 163, 57)
          : const Color.fromARGB(255, 150, 146, 146),
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(enabled
              ? const Color.fromARGB(255, 166, 186, 169)
              : const Color.fromARGB(255, 71, 72, 71)),
        ),
        onPressed: enabled
            ? onPressed
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'You can make payment after the confirmation call'),
                  ),
                );
              },
        child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
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
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(16.0),
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
            style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(height: 10.0),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
      color: const Color.fromARGB(255, 230, 230, 230),
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 184, 142, 15))),
        onPressed: () {
          // Action to perform when payment button is pressed
        },
        child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

