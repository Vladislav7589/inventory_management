import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../models/products.dart';
import '../models/suppliers.dart';
import 'buttom_sheet.dart';

class SuppliersPage extends ConsumerWidget {
  const SuppliersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String tableName = 'Поставщики';
    List<Supplier> suppliers = [];
    int currentSortColumn = 0;
    bool isAscending = true;
    return  RefreshIndicator(
          onRefresh: () async {
            return ref.refresh(selectDataFromTable(tableName).future);
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height, // Устанавливаем ограничение по высоте
              child: Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          tableName,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30, // Размер шрифта заголовка
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showBottom(context);
                          },
                          child: Text('Добавить'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: Container(
                      child: ref.watch(selectDataFromTable(tableName)).when(
                          data: (data) {
                            suppliers = Suppliers.fromListOfLists(data!).supplierList;
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
                                  DataColumn(label: Text('Адрес'), numeric: true),
                                  DataColumn(label: Text('Почта'), numeric: true),
                                  DataColumn(label: Text(''), numeric: true),
                                ],
                                rows: suppliers.map((supplier) {
                                  return DataRow(cells: [
                                    DataCell(Text(supplier.id)),
                                    DataCell(Text(supplier.name)),
                                    DataCell(Text(supplier.address)),
                                    DataCell(Text(supplier.email)),
                                    DataCell(IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        ref.watch(deleteDataFromTable([tableName, supplier.id]));
                                      },
                                    ))
                                  ]);
                                }).toList(),
                              ),
                            );
                          },
                          error: (error, stack) => const Center(child: Text('Ошибка',style: TextStyle(fontSize: 30),)),
                          loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ))

                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
  }
}
