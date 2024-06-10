// my_orders_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_0/myorder/bloc/order_bloc.dart';
import 'package:flutter_application_0/myorder/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_application_0/myorder/blocs/order_bloc.dart';
import 'package:flutter_application_0/myorder/widgets/orderDetailpage.dart';

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderInitial) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderLoaded) {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(orderId: state.orders[index].id),
                        ),
                      );
                    },
                    child: OrderTile(order: state.orders[index]),
                  );
                },
              );
            } else if (state is OrderError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Container(); // Default empty container
            }
          },
        ),
      ),
    );
  }
}







class OrderTile extends StatelessWidget {
  final OrderTileData order;

  // ignore: use_key_in_widget_constructors
  const OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    IconData icon;
    switch (order.status) {
      case 'approved':
        dotColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Pending':
        dotColor = Colors.yellow;
        icon = Icons.info;
        break;
      case 'reject open':
        dotColor = Colors.blue;
        icon = Icons.cancel;
        break;
      case 'reject close':
      case 'cancelled':
      // case 'Cancelled by User':
        dotColor = Colors.red;
        icon = Icons.cancel;
        break;
         case 'delivered':
      // case 'Cancelled by User':
        dotColor = const Color.fromARGB(255, 111, 88, 4);
        icon = Icons.cancel;
        break;
         case 'Cancelled by User':
      // case 'Cancelled by User':
        dotColor = const Color.fromARGB(255, 0, 0, 0);
        icon = Icons.cancel;
        break;
        
      default:
        dotColor = const Color.fromARGB(255, 173, 255, 85);
        icon = Icons.help_outline;
        break;
    }

    // Additional case for delivery status 'complete'
    if (order.deliveryStatus == 'complete') {
      dotColor = Colors.blue; // Change color for complete status
      icon = Icons.done; // Change icon for complete status
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white, // Set a stable color for the tile background
      child: ListTile(
        leading: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        title: Text(
          'Order ID: QM-0024-${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Delivery Address: ${order.deliveryAddress}\nTotal Price: ${order.totalPrice}',
          style: TextStyle(color: Colors.grey[700]),
        ),
        trailing: Text(order.status),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(orderId: order.id)
            ),
          );
        },
      ),
    );
  }
}
