import 'package:env_flutter/env_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/models/product.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';
import 'package:inventory_management/src/widgets/table_widget.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const  ProviderScope(child: MyApp(),));
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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Склад',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Consumer(
        builder: (_, WidgetRef ref, __) {
          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(selectDataFromTable('Товары').future);
            },
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height, // Устанавливаем ограничение по высоте
                child: Column(
                  children: [
                    Divider(),
                    const Text(
                      'Товары',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30, // Размер шрифта заголовка
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: Container(
                        child: ref.watch(selectDataFromTable('Товары')).when(
                        data: (data) {
                            products = Products.fromListOfLists(data!).productList;
                            return TableWidget(products: products);
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
        },
      ),
    );
  }
}
