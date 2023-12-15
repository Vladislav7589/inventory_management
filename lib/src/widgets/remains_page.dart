import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/models/employee.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../../main.dart';
import '../models/products.dart';
import '../models/sales.dart';
import 'buttom_sheet.dart';

class RemainsPage extends ConsumerWidget {
  const RemainsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Sale> remains = [];
    int currentSortColumn = 0;
    bool isAscending = true;
    String tableName = 'Остаток';
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
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: Container(
                      child: ref.watch(selectDataFromTable(tableName)).when(
                          data: (data) {
                            remains = Sales.fromListOfLists(data!).salesList;
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
                                  DataColumn(label: Text('Наименование')),
                                  DataColumn(label: Text('Тип'), numeric: true),
                                  DataColumn(label: Text('Поставщик'), numeric: true),
                                  DataColumn(label: Text('Цена за шт.'), numeric: true),
                                  DataColumn(label: Text('Остаток'), numeric: true),
                                ],
                                rows: remains.map((remain) {
                                  return DataRow(cells: [
                                    DataCell(Text(remain.id)),
                                    DataCell(Text(remain.data_time)),
                                    DataCell(Text(remain.code_employee)),
                                    DataCell(Text(remain.code_product)),
                                    DataCell(Text(remain.count)),
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