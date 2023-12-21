
class Products {
  final List<Product> productList;

  Products(this.productList);

  factory Products.fromListOfLists(List<List<dynamic>> data) {
    final List<Product> products = data.map((list) => Product.fromList(list)).toList();
    return Products(products);
  }
}

class Product {
  final String id;
  final String name;
  final String quantity;
  final String productType;
  final String price;
  final String supplierCode;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.productType,
    required this.price,
    required this.supplierCode,
  });

  factory Product.fromList(List<dynamic> data) {
    return Product(
      id: data[0].toString(),
      name: data[1].toString(),
      quantity: data[2].toString(),
      productType: data[3].toString(),
      price: data[4].toString(),
      supplierCode: data[5].toString(),
    );
  }
}