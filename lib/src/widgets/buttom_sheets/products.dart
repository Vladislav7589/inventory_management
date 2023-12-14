import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../buttom_sheet.dart';

class BottomSheetProducts extends ConsumerStatefulWidget {
  final String tableName;

  const BottomSheetProducts(this.tableName, {Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _BottomSheetProductsState();
}

class _BottomSheetProductsState extends ConsumerState<BottomSheetProducts> {
  late TextEditingController nameController;
  late TextEditingController countController;
  late TextEditingController groupController;
  late TextEditingController priceController;
  late TextEditingController supplierController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    countController = TextEditingController();
    groupController = TextEditingController();
    priceController = TextEditingController();
    supplierController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    countController.dispose();
    groupController.dispose();
    priceController.dispose();
    supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'Наименование': '',
      'Количество': '',
      'Тип_товара': '',
      'Цена': '',
      'Код_поставщика': '',
    };
    List<String> keysList = data.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: Column(
        children: [
          formField(nameController, keysList[0]),
          const SizedBox(height: 20),
          formField(countController, keysList[1]),
          const SizedBox(height: 20),
          formField(groupController, keysList[2]),
          const SizedBox(height: 20),
          formField(priceController, keysList[3]),
          const SizedBox(height: 20),
          formField(supplierController, keysList[4]),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Добавить'),
            onPressed: () {
              data['Наименование'] = nameController.text;
              data['Количество'] = countController.text;
              data['Тип_товара'] = groupController.text;
              data['Цена'] = priceController.text;
              data['Код_поставщика'] = supplierController.text;

              ref.watch(insertDataFromTable([widget.tableName, data]));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}