import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../buttom_sheet.dart';

class BottomSheetSales extends ConsumerStatefulWidget {
  final String tableName;

  const BottomSheetSales(this.tableName, {Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _BottomSheetSalesState();
}

class _BottomSheetSalesState extends ConsumerState<BottomSheetSales> {
  late TextEditingController firstNameController;
  late TextEditingController secondNameController;
  late TextEditingController thirdNameController;
  late TextEditingController postController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    secondNameController = TextEditingController();
    thirdNameController = TextEditingController();
    postController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    thirdNameController.dispose();
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'Дата_и_время': '',
      'Код_сотрудника': '',
      'Код_товара': '',
      'Количество': '',
    };
    List<String> keysList = data.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: Column(
        children: [
          formField(firstNameController, keysList[0]),
          const SizedBox(height: 20),
          formField(secondNameController, keysList[1]),
          const SizedBox(height: 20),
          formField(thirdNameController, keysList[2]),
          const SizedBox(height: 20),
          formField(postController, keysList[3]),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Добавить'),
            onPressed: () {
              data['Дата_и_время'] = firstNameController.text;
              data['Код_сотрудника'] = secondNameController.text;
              data['Код_товара'] = thirdNameController.text;
              data['Количество'] = postController.text;

              ref.watch(insertDataFromTable([widget.tableName, data]));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}