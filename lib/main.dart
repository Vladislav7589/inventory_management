import 'package:env_flutter/env_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/models/products.dart';
import 'package:inventory_management/src/widgets/employee_page.dart';
import 'package:inventory_management/src/widgets/group_product_page.dart';

import 'package:inventory_management/src/widgets/product_page.dart';
import 'package:inventory_management/src/widgets/sales_page.dart';
import 'package:inventory_management/src/widgets/suppliers_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load();
  runApp(const  ProviderScope(child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Склад',style: TextStyle(fontWeight: FontWeight.bold),),
          bottom: const TabBar(
            isScrollable:true,
            labelStyle:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: "Товары",
              ),
              Tab(
                text: "Продажи",
              ),
              Tab(
                text: "Сотрудники",
              ),
              Tab(
                text: "Поставщики",
              ),
              Tab(
                text: "Группы товаров",
              )
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            ProductPage(),
            SalesPage(),
            EmployeePage(),
            SuppliersPage(),
            GroupProductPage()
          ],
        ),
      ),
    );
  }
}
