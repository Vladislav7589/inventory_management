import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../buttom_sheet.dart';

class BottomSheetSuppliers extends ConsumerStatefulWidget {
  final String tableName;

  const BottomSheetSuppliers(this.tableName, {Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _BottomSheetSuppliersState();
}

class _BottomSheetSuppliersState extends ConsumerState<BottomSheetSuppliers> {
  late TextEditingController firstNameController;
  late TextEditingController secondNameController;
  late TextEditingController thirdNameController;


  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    secondNameController = TextEditingController();
    thirdNameController = TextEditingController();

  }

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    thirdNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'Название': '',
      'Адрес': '',
      'Почта': '',

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
          ElevatedButton(
            child: const Text('Добавить'),
            onPressed: () {
              data['Название'] = firstNameController.text;
              data['Адрес'] = secondNameController.text;
              data['Почта'] = thirdNameController.text;

              ref.watch(insertDataFromTable([widget.tableName, data]));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}