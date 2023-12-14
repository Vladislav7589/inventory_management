import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../models/product.dart';

class TableWidget extends ConsumerWidget {
  final List<Product> products;

  const TableWidget({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentSortColumn = 0;
    bool isAscending = true;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataRowHeight: 50,
        columnSpacing: 15,
        horizontalMargin: 10,
        sortColumnIndex: currentSortColumn,
        sortAscending: isAscending,
        showBottomBorder: true,
        headingTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          // Цвет текста заголовка
        ),
        columns: const [
          DataColumn(
            label: Text('ID'),
            numeric: true,
          ),
          DataColumn(label: Text('Наименование')),
          DataColumn(label: Text('Количество'), numeric: true),
          DataColumn(label: Text('Тип товара'), numeric: true),
          DataColumn(label: Text('Цена'), numeric: true),
          DataColumn(label: Text('Код поставщика'), numeric: true),
          DataColumn(label: Text(''), numeric: true),
        ],
        rows: products.map((product) {
          return DataRow(cells: [
            DataCell(Text(product.id)),
            DataCell(Text(product.name)),
            DataCell(Text(product.quantity)),
            DataCell(Text(product.productType)),
            DataCell(Text(product.price)),
            DataCell(Text(product.supplierCode)),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.watch(deleteDataFromTable(['Товары', product.id]));
              },
            ))
          ]);
        }).toList(),
      ),
    );
  }
}
