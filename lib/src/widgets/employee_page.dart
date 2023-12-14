import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/models/employee.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../models/products.dart';
import 'buttom_sheet.dart';

class EmployeePage extends ConsumerWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Employee> employees = [];
    int currentSortColumn = 0;
    bool isAscending = true;
    String tableName = 'Сотрудники';
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
                            employees = Employees.fromListOfLists(data!).employeeList;
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
                                  DataColumn(label: Text('ID'), numeric: true,),
                                  DataColumn(label: Text('Имя')),
                                  DataColumn(label: Text('Фамилия'), numeric: true),
                                  DataColumn(label: Text('Отчество'), numeric: true),
                                  DataColumn(label: Text('Должность'), numeric: true),
                                  DataColumn(label: Text('Телефон'), numeric: true),
                                  DataColumn(label: Text(''), numeric: true),
                                ],
                                rows: employees.map((employee) {
                                  return DataRow(cells: [
                                    DataCell(Text(employee.id)),
                                    DataCell(Text(employee.first_name)),
                                    DataCell(Text(employee.second_name)),
                                    DataCell(Text(employee.third_name)),
                                    DataCell(Text(employee.post)),
                                    DataCell(Text(employee.number_phone)),
                                    DataCell(IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                          ref.watch(deleteDataFromTable([tableName, employee.id]));
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
