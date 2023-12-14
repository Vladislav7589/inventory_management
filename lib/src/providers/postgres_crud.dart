import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../database/postgre_database.dart';

final postgresDatabaseProvider = Provider<PostgresDatabase>(
  (ref) => PostgresDatabase(),
);

final selectDataFromTable = FutureProvider.family<List<List<dynamic>>?, String>((ref, tableName) async {
  final postgresDatabase = ref.watch(postgresDatabaseProvider);
  if (postgresDatabase.connection == null) {
    await postgresDatabase.connectToPostgres();
  }
  return await postgresDatabase.getAllFromTable(tableName);
});

final deleteDataFromTable = FutureProvider.family<void, List<String>>((ref, tableNameAndId) async {
  try {
    await ref.watch(postgresDatabaseProvider).deleteData(tableNameAndId[0], tableNameAndId[1]);
    // Обновляем только данные таблицы после удаления записи
    await ref.read(selectDataFromTable(tableNameAndId[0]).future);
  } catch (error) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ошибка удаления:'),
          content: Text('$error'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ОК'),
            ),
          ],
        );
      },
    );
    // Обработка ошибки удаления данных
  }
});

final insertDataFromTable = FutureProvider.family<void, List<dynamic>>((ref, tableNameAndData) async {
  ref.watch(postgresDatabaseProvider).insertData(tableNameAndData[0], tableNameAndData[1] as Map<String, dynamic>);
  ref.refresh(selectDataFromTable(tableNameAndData[0]).future);
});
