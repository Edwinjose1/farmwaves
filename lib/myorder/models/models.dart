class OrderTileData {
  final int id;
  final DateTime orderDate;
  final String status;
  final String deliveryAddress;
  final String totalPrice;
  final String paymentMethod;
  final List<Medicinee> items;
  final String paymentStatus;
  final String deliveryStatus;
  final String remarks;

  OrderTileData({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.deliveryAddress,
    required this.totalPrice,
    required this.paymentMethod,
    required this.items,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.remarks,
  });

factory OrderTileData.fromJson(Map<String, dynamic> json) {
  try {
    // Parse the list of items
    List<Medicinee> itemList = _parseItems(json['items']);
    
    return OrderTileData(
      remarks: json['remarks'],
      id: json['order_id'],
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      deliveryAddress: json['delivery_address'] != null ? json['delivery_address']['locality'] : '', // Check if delivery_address is null
      totalPrice: json['total_price'], // Check if total_price is null
      deliveryStatus: json['delivery_status'],
      paymentMethod: json['payment_method'],
      items: itemList, // Assign the parsed list of items
      paymentStatus: json['payment_status'],
    );
  } catch (e) {
    // ignore: avoid_print
    print('Error parsing OrderTileData: $e');
    rethrow;
  }
}



  static List<Medicinee> _parseItems(dynamic itemsJson) {
    if (itemsJson is List) {
      return itemsJson.map((item) => Medicinee.fromJson(item)).toList();
    } else {
      // Handle case when itemsJson is not a List
      return [];
    }
  }
}

class Medicinee {
  final int id;
  final String name;
  final int quantity;
  final double price;

  Medicinee({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory Medicinee.fromJson(Map<String, dynamic> json) {
    return Medicinee(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
}
class Medicine1 {
  final int id;
  final String name;
  final String company;
  final double price;
 int quantity;

  Medicine1({
    required this.id,
    required this.name,
    required this.company,
    required this.price,
    this.quantity=1,
  });

  factory Medicine1.fromJson(Map<String, dynamic> json) {
    return Medicine1(
      id: json['id'],
      name: json['product_name'],
      company: json['company'],
      price: double.parse(json['mrp']),
      
    );
  }
}
