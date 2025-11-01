
class Department {
  final String id;
  final String categoryId;
  final String name;

  Department({
    required this.id,
    required this.categoryId,
    required this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json['id'],
    categoryId: json['categoryId'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() =>
      {'id': id, 'categoryId': categoryId, 'name': name};
}