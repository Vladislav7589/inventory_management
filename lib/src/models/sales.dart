
class Sales {
  final List<Sale> salesList;

  Sales(this.salesList);

  factory Sales.fromListOfLists(List<List<dynamic>> data) {
    final List<Sale> sales = data.map((list) => Sale.fromList(list)).toList();
    return Sales(sales);
  }
}

class Sale {
  final String id;
  final String data_time;
  final String code_employee;
  final String code_product;
  final String count;

  Sale({
    required this.id,
    required this.data_time,
    required this.code_employee,
    required this.code_product,
    required this.count,
  });

  factory Sale.fromList(List<dynamic> data) {
    return Sale(
      id: data[0].toString(),
      data_time: data[1].toString(),
      code_employee: data[2].toString(),
      code_product: data[3].toString(),
      count: data[4].toString(),
    );
  }
}