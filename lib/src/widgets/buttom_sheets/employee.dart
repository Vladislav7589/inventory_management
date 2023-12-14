import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../buttom_sheet.dart';

class BottomSheetEmployees extends ConsumerStatefulWidget {
  final String tableName;

  const BottomSheetEmployees(this.tableName,  {Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _BottomSheetEmployeesState();
}

class _BottomSheetEmployeesState extends ConsumerState<BottomSheetEmployees> {
  late TextEditingController firstNameController;
  late TextEditingController secondNameController;
  late TextEditingController thirdNameController;
  late TextEditingController postController;
  late TextEditingController numberController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    secondNameController = TextEditingController();
    thirdNameController = TextEditingController();
    postController = TextEditingController();
    numberController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    thirdNameController.dispose();
    postController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'Имя': '',
      'Фамилия': '',
      'Отчество': '',
      'Должность': '',
      'Телефон': '',
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
          formField(numberController, keysList[4]),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Добавить'),
            onPressed: () {
              data['Имя'] = firstNameController.text;
              data['Фамилия'] = secondNameController.text;
              data['Отчество'] = thirdNameController.text;
              data['Должность'] = postController.text;
              data['Телефон'] = numberController.text;

              ref.watch(insertDataFromTable([widget.tableName, data]));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}