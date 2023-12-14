import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/src/providers/postgres_crud.dart';

import 'buttom_sheets/employee.dart';
import 'buttom_sheets/groups.dart';
import 'buttom_sheets/products.dart';
import 'buttom_sheets/sales.dart';
import 'buttom_sheets/suppliers.dart';

Widget chooseWidgetBasedOnVariable(String value) {
  switch (value) {
    case 'Группы_товаров': return BottomSheetGroups(value);
    case 'Сотрудники': return BottomSheetEmployees(value);
    case 'Поставщики': return BottomSheetSuppliers(value);
    case 'Товары': return BottomSheetProducts(value);
    case 'Продажа': return BottomSheetSales(value);
    default: return SizedBox();
  }
}
class BottomSheet extends StatelessWidget {
  final String tableName;
  const BottomSheet({super.key, required this.tableName, });

  @override
  Widget build(BuildContext context) {
    Widget selectedBottomSheet = chooseWidgetBasedOnVariable(tableName);
    return selectedBottomSheet;
  }
}
TextFormField formField(TextEditingController controller, String name){
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.url,
    decoration: InputDecoration(
      hintText: name,
      labelText: name,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    validator: (text) {
      if (text == null || text.isEmpty) {
        return 'Ошибка';
      } else {
        return null;
      }
    },
  );
}

void showBottom(BuildContext ctx,String tableName) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    context: ctx,
    builder: (context) => SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black26,
                  ),
                ),
                BottomSheet(tableName: tableName,)
              ],
            ),
          ],
        ),
      ),
    ),
  );
}