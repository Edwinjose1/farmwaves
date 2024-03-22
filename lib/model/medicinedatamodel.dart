class Medicine {
  final String name;
  final double price;
  final String company;
  bool isInCart;
  int quantity; // Add quantity property

  Medicine({
    required this.name,
    required this.price,
    required this.company,
    this.isInCart = false, // Default value is false
    this.quantity = 1, // Default quantity is 1
  });
}
