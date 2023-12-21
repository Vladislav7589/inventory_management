
class Groups {
  final List<Group> groupsList;

  Groups(this.groupsList);

  factory Groups.fromListOfLists(List<List<dynamic>> data) {
    final List<Group> groups = data.map((list) => Group.fromList(list)).toList();
    return Groups(groups);
  }
}

class Group {
  final String id;
  final String property;


  Group({
    required this.id,
    required this.property,

  });

  factory Group.fromList(List<dynamic> data) {
    return Group(
      id: data[0].toString(),
      property: data[1].toString(),

    );
  }
}