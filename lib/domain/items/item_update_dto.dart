import 'package:geek_collection/domain/categories/categories.dart';

class ItemUpdate {
  int id;
  String name;
  int categoryId;
  String description;
  String condition;

  ItemUpdate({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.condition,
  });

  factory ItemUpdate.fromJson(Map<String, dynamic> json) {
    ItemUpdate item = ItemUpdate(
      id: json['id'],
      name: json['name'],
      categoryId: json['categoryId'],
      description: json['description'],
      condition: json['condition'],
    );
	 print("Item => ${item.toJson()}");
	 return item;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'condition': condition,
    };
  }
}
