
import 'package:env_flutter/env_flutter.dart';
import 'package:postgres/postgres.dart';

class PostgresDatabase {
  late final Connection connection;
  Future<void> connectToPostgres() async {
    connection = await Connection.open(
      Endpoint(
        host: '192.168.0.103',
        database: 'складской_учет',
        username: 'postgres',
        password: dotenv.env['password']!,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
  }
  Future<void> closeConnection() async {
    await connection.close();
  }
  Future<List<List<dynamic>>> getAllFromTable(String tableName) async {
    return await connection.execute(Sql.named('SELECT * FROM $tableName'));
  }
  Future<void> deleteData(String tableName, String id) async {
    await connection.execute(Sql.named('DELETE FROM $tableName WHERE id=$id'));
  }
}