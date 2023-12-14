import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../models/groups.dart';
import '../models/products.dart';
import 'buttom_sheet.dart';

class GroupProductPage extends ConsumerWidget {
  const GroupProductPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String tableName = 'Группы_товаров';
    List<Group> groupsProducts = [];
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
                            showBottom(context,tableName);
                          },
                          child: const Text('Добавить'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: Container(
                      child: ref.watch(selectDataFromTable(tableName)).when(
                          data: (data) {
                            groupsProducts = Groups.fromListOfLists(data!).groupsList;
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
                                  DataColumn(label: Text('Характеристика')),
                                  DataColumn(label: Text(''), numeric: true),
                                ],
                                rows: groupsProducts.map((groupProduct) {
                                  return DataRow(cells: [
                                    DataCell(Text(groupProduct.id)),
                                    DataCell(Text(groupProduct.property)),
                                    DataCell(IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        ref.watch(deleteDataFromTable([tableName, groupProduct.id]));
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
