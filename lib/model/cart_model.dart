class CartModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image_url;
  int quantity;
  double total;

  CartModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image_url,
    required this.quantity,
    required this.total,
  });

  CartModel copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image_url,
    int? quantity,
    double? total,
  }) {
    return CartModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image_url: image_url ?? this.image_url,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }
}
