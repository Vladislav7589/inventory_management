import 'package:env_flutter/env_flutter.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 125, 183, 58)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<dynamic>> data = [];
  Future<List<List<dynamic>>> fetchDataFromDB() async {
    final connection = await Connection.open(
      Endpoint(
        host: dotenv.env['host']!,
        database: dotenv.env['database']!,
        username: dotenv.env['username']!,
        password: dotenv.env['password']!,
      ),
      // The postgres server hosted locally doesn't have SSL by default. If you're
      // accessing a postgres server over the Internet, the server should support
      // SSL and you should swap out the mode with `SslMode.verifyFull`.
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
    print('has connection!');

    try {
      final results = await connection.execute(Sql.named('SELECT * FROM Товары'));
      print(results);
      return results;
    } catch (e) {
      print('Error: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PostgreSQL в Flutter'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                data = await fetchDataFromDB();
                setState(() {});
              },
              child: Text('Загрузить данные'),
            ),
            data.isEmpty
                ? Text('Данные не загружены')
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Код товара')),
                  DataColumn(label: Text('Наименование')),
                  DataColumn(label: Text('Количество')),
                  DataColumn(label: Text('Тип товара')),
                  DataColumn(label: Text('Цена')),
                  DataColumn(label: Text('Код поставщика')),
                ],
                rows: data.map((row) {
                  return DataRow(
                    cells: row.map((cell) {
                      return DataCell(Text('$cell'));
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

}