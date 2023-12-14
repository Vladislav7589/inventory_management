import 'package:env_flutter/env_flutter.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/src/models/product.dart';
import 'package:inventory_management/src/widgets/table_widget.dart';
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 125, 183, 58)),
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
  List<Product> products = [];

  Future<List<List<dynamic>>> fetchDataFromDB() async {
    final connection = await Connection.open(
      Endpoint(
        host: '192.168.0.103',
        database: 'складской_учет',
        username: 'postgres',
        password: dotenv.env['password']!,
      ),
      // The postgres server hosted locally doesn't have SSL by default. If you're
      // accessing a postgres server over the Internet, the server should support
      // SSL and you should swap out the mode with `SslMode.verifyFull`.
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    try {
      final results =
          await connection.execute(Sql.named('SELECT * FROM Товары'));
      return results;
    } catch (e) {
      return [];
    } finally {
      await connection.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Склад'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Загрузка данных из базы данных
          final data = await fetchDataFromDB();
          setState(() {
            // Обновление списка products
            products = Products.fromListOfLists(data).productList;
          });
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height, // Устанавливаем ограничение по высоте
            child: Column(
              children: [
                const Text(
                  'Товары',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25, // Размер шрифта заголовка
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TableWigget(products: products),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
