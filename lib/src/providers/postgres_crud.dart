import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../database/postgre_database.dart';

final postgresDatabaseProvider = Provider<PostgresDatabase>(
  (ref) => PostgresDatabase(),
);

final selectDataFromTable = FutureProvider.family<List<List<dynamic>>?, String>((ref, tableName) async {
try {
  final postgresDatabase = ref.watch(postgresDatabaseProvider);
  if (postgresDatabase.connection == null) {
    await postgresDatabase.connectToPostgres();
  }
  return await postgresDatabase.getAllFromTable(tableName);
} catch (error) {
  scaffoldKey.currentState?.showSnackBar(showSnackBar("$error"));
  // Обработка ошибки удаления данных
}
});

final deleteDataFromTable = FutureProvider.family<void, List<String>>((ref, tableNameAndId) async {
  try {
    await ref.watch(postgresDatabaseProvider).deleteData(tableNameAndId[0], tableNameAndId[1]);
    // Обновляем только данные таблицы после удаления записи
    await ref.read(selectDataFromTable(tableNameAndId[0]).future);
  } catch (error) {
    scaffoldKey.currentState?.showSnackBar(showSnackBar("$error"));
    // Обработка ошибки удаления данных
  }
});

final insertDataFromTable = FutureProvider.family<void, List<dynamic>>((ref, tableNameAndData) async {
try {
   await ref.watch(postgresDatabaseProvider).insertData(
      tableNameAndData[0], tableNameAndData[1] as Map<String, dynamic>);
   await ref.refresh(selectDataFromTable(tableNameAndData[0]).future);
} catch (error) {
  scaffoldKey.currentState?.showSnackBar(showSnackBar("$error"));
}
});
final updateDataFromTable = FutureProvider.family<void, List<dynamic>>((ref, tableColumnId) async {
  try {
    await ref.watch(postgresDatabaseProvider).updateData(tableColumnId[0], tableColumnId[1],tableColumnId[2],tableColumnId[3]);
    await ref.refresh(selectDataFromTable(tableColumnId[0]).future);
  } catch (error) {
    scaffoldKey.currentState?.showSnackBar(showSnackBar("$error"));
  }
});
