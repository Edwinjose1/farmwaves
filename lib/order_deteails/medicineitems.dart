
import 'package:flutter/material.dart';

class MedicineItem extends StatelessWidget {
  final String name;
  final int quantity;
  final VoidCallback onAddQuantity;
  final VoidCallback onRemoveQuantity; // New callback for removing quantity

  const MedicineItem({
    Key? key,
    required this.name,
    required this.quantity,
    required this.onAddQuantity,
    required this.onRemoveQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('Quantity: $quantity'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onRemoveQuantity, // Call onRemoveQuantity when tapped
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3), // Change color to red for remove
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.remove, // Icon for removing quantity
                  color: Colors.red,
                  size: 24.0,
                ),
              ),
            ),
            const SizedBox(width: 8.0), // Add spacing between buttons
            GestureDetector(
              onTap: onAddQuantity,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.add, // Icon for adding quantity
                  color: Colors.green,
                  size: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
