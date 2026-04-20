class Product {
  final String productName;
  final String variation;
  final int quantity;
  final String productCategory;
  final String shippingStatus;

  Product({
    required this.productName,
    required this.variation,
    required this.quantity,
    required this.productCategory,
    required this.shippingStatus,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['product_name'] ?? '',
      variation: json['variation'] ?? '',
      quantity: json['quantity'] ?? 0,
      productCategory: json['product_category'] ?? '',
      shippingStatus: json['shipping_status'] ?? '',
    );
  }
}