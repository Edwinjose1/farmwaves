import 'package:flutter/material.dart';
import 'package:flutter_application_0/myorder/models/models.dart';

class Orderitems extends StatelessWidget {
  const Orderitems({
    super.key,
    required this.order,
  });

  final OrderTileData order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Ordered Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Price')),
              ],
              rows: order.items
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text(item.name, style: const TextStyle(fontSize: 10))),
                        DataCell(Text(item.quantity.toString(), style: const TextStyle(fontSize: 10))),
                        DataCell(Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 10))),
                             
                        
                      ],
                    ),
                  )                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

