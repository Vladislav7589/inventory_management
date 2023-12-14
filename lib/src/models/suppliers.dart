
class Suppliers {
  final List<Supplier> supplierList;

  Suppliers(this.supplierList);

  factory Suppliers.fromListOfLists(List<List<dynamic>> data) {
    final List<Supplier> suppliers = data.map((list) => Supplier.fromList(list)).toList();
    return Suppliers(suppliers);
  }
}

class Supplier {
  final String id;
  final String name;
  final String address;
  final String email;


  Supplier({
    required this.id,
    required this.name,
    required this.address,
    required this.email,

  });

  factory Supplier.fromList(List<dynamic> data) {
    return Supplier(
      id: data[0].toString(),
      name: data[1].toString(),
      address: data[2].toString(),
      email: data[3].toString(),

    );
  }
}