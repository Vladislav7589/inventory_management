
class Employees {
  final List<Employee> employeeList;

  Employees(this.employeeList);

  factory Employees.fromListOfLists(List<List<dynamic>> data) {
    final List<Employee> employees = data.map((list) => Employee.fromList(list)).toList();
    return Employees(employees);
  }
}

class Employee {
  final String id;
  final String first_name;
  final String second_name;
  final String third_name;
  final String post;
  final String number_phone;

  Employee({
    required this.id,
    required this.first_name,
    required this.second_name,
    required this.third_name,
    required this.post,
    required this.number_phone,
  });

  factory Employee.fromList(List<dynamic> data) {
    return Employee(
      id: data[0].toString(),
      first_name: data[1].toString(),
      second_name: data[2].toString(),
      third_name: data[3].toString(),
      post: data[4].toString(),
      number_phone: data[5].toString(),
    );
  }
}