

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/postgre_database.dart';

final postgresDatabaseProvider = Provider<PostgresDatabase>((ref) => PostgresDatabase(),
);

final selectDataFromTable = FutureProvider.family<List<List<dynamic>>?, String>((ref, tableName) async {
  final postgresDatabase = ref.watch(postgresDatabaseProvider);
  if (postgresDatabase.connection == null) {

    await postgresDatabase.connectToPostgres();
  }
  var data = await postgresDatabase.getAllFromTable(tableName);
  return data;
});

final deleteDataFromTable = FutureProvider.family<void,List<String>>((ref, tableNameAndId) async {
  ref.watch(postgresDatabaseProvider).deleteData(tableNameAndId[0],tableNameAndId[1]);
  ref.refresh(selectDataFromTable(tableNameAndId[0]).future);

});

final insertDataFromTable = FutureProvider.family<void,Map<String, dynamic>>((ref, tableNameAndId) async {
  ref.watch(postgresDatabaseProvider).insertData(tableNameAndId[0],tableNameAndId[1]);
  ref.refresh(selectDataFromTable(tableNameAndId[0]).future);

});