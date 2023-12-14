
import 'package:env_flutter/env_flutter.dart';
import 'package:postgres/postgres.dart';

class PostgresDatabase {
  Connection? connection;
  Future<void> connectToPostgres() async {
    connection = await Connection.open(
      Endpoint(
        host: '192.168.0.103',
        database: 'склад',
        username: 'postgres',
        password: dotenv.env['password']!,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
  }
  Future<void> closeConnection() async {
    await connection?.close();
  }
  Future<List<List<dynamic>>?> getAllFromTable(String tableName) async {
    return await connection?.execute(Sql.named('SELECT * FROM $tableName'));
  }
  Future<void> deleteData(String tableName, String id) async {
    await connection?.execute(Sql.named('DELETE FROM $tableName WHERE id=$id'));
  }
  Future<void> insertData(String tableName, Map<String, dynamic> data) async {
    final columns = data.keys.join(', ');
    final values = data.values.map((value) {
      if (value is String) {
        return "'$value'";
      }
      return value;
    }).join(', ');
    print(values);

/*    data = {
      'Наименование': 'Футбольный мяч',
      'Количество': 10,
      'Тип_товара': 5,
      'Цена': 700.00,
      'Код_поставщика': 25,
    };*/
    await connection?.execute(Sql.named('INSERT INTO $tableName ($columns) VALUES ($values)'));
  }
}