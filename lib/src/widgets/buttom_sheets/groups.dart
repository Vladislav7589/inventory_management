import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import '../buttom_sheet.dart';

class BottomSheetGroups extends ConsumerStatefulWidget {
  final String tableName;

  const BottomSheetGroups(this.tableName, {Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _BottomSheetGroupsState();
}

class _BottomSheetGroupsState extends ConsumerState<BottomSheetGroups> {
  late TextEditingController propertyController;


  @override
  void initState() {
    super.initState();
    propertyController = TextEditingController();

  }

  @override
  void dispose() {
    propertyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'Характеристика': '',
    };
    List<String> keysList = data.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: Column(
        children: [
          formField(propertyController, keysList[0]),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Добавить'),
            onPressed: () {
              data['Характеристика'] = propertyController.text;

              ref.watch(insertDataFromTable([widget.tableName, data]));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}