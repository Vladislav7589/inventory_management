import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/models/employee.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../../main.dart';
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
                            showBottom(context,tableName);
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
                                  DataColumn(label: Text('Фамилия')),
                                  DataColumn(label: Text('Имя'), numeric: true),
                                  DataColumn(label: Text('Отчество'), numeric: true),
                                  DataColumn(label: Text('Должность'), numeric: true),
                                  DataColumn(label: Text('Телефон'), numeric: true),

                                  DataColumn(label: Text('')),
                                ],
                                rows: employees.map((employee) {
                                  return DataRow(cells: [
                                    DataCell(Text(employee.id)),
                                    dataCell(tableName, 'Фамилия', employee.first_name, employee.id, ref),
                                    dataCell(tableName, 'Имя', employee.second_name, employee.id, ref),
                                    dataCell(tableName, 'Отчество', employee.third_name, employee.id, ref),
                                    dataCell(tableName, 'Должность', employee.post, employee.id, ref),
                                    dataCell(tableName, 'Телефон', employee.number_phone, employee.id, ref),
                                    DataCell(IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        ref.watch(deleteDataFromTable([tableName, employee.id]));
                                      },
                                    )),
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