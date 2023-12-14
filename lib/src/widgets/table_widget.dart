
import 'package:flutter/material.dart';

import '../models/product.dart';

class TableWigget extends StatelessWidget {
  final List<Product> products;
  const TableWigget({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentSortColumn = 0;
    bool isAscending = true;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataRowHeight: 50,
        columnSpacing: 15,
        horizontalMargin: 0,
        sortColumnIndex: currentSortColumn,
        sortAscending: isAscending,
        showBottomBorder: true,
        headingTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          // Цвет текста заголовка
        ),
        columns: [
          DataColumn(
              label: const Text('ID'),
              numeric: true,
              onSort: (columnIndex, _) {

                  currentSortColumn = columnIndex;
                  if (isAscending == true) {
                    isAscending = false;
                    // sort the product list in Ascending, order by Price
                    products.sort((productA, productB) =>
                        productB.id.compareTo(productA.id));
                  } else {
                    isAscending = true;
                    // sort the product list in Descending, order by Price
                    products.sort((productA, productB) =>
                        productA.id.compareTo(productB.id));
                  }

              }),
          const DataColumn(label: Text('Наименование')),
          const DataColumn(label: Text('Количество'), numeric: true),
          const DataColumn(label: Text('Тип товара'), numeric: true),
          const DataColumn(label: Text('Цена'), numeric: true),
          const DataColumn(label: Text('Код поставщика'), numeric: true),
          const DataColumn(label: Text(''), numeric: true),
        ],
        rows: products.map((product) {
          return DataRow(
              cells: [
            DataCell(Text(product.id)),
            DataCell(Text(product.name)),
            DataCell(Text(product.quantity)),
            DataCell(Text(product.productType)),
            DataCell(Text(product.price)),
            DataCell(Text(product.supplierCode)),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {

                  },
                ))
          ]);
        }).toList(),
      ),
    );
  }
}