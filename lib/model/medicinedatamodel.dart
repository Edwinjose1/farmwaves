class Medicine {
  final int id;
  final String name;
  final String company;
  final double price;
 int quantity;

  Medicine({
    required this.id,
    required this.name,
    required this.company,
    required this.price,
    this.quantity=1,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['product_name'],
      company: json['company'],
      price: double.parse(json['mrp']),
      
    );
  }
}
