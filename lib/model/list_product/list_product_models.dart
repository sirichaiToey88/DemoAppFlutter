class Order {
  final String productName;
  final String imageUrl;
  final double price;
  int quantity;

  Order({
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}

final List<Order> orders = [
  Order(
    productName: "Product 1",
    imageUrl: "assets/images/icons/teamwork.png",
    price: 25.0,
  ),
  Order(
    productName: "Product 2",
    imageUrl: "assets/images/icons/teamwork.png",
    price: 30.0,
  ),
  // Add more sample orders here...
];
