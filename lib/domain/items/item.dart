import 'package:geek_collection/domain/categories/categories.dart';

class Item {
  int id;
  String name;
  Category category;
  String description;
  String condition;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.condition,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    Item item = Item(
      id: json['id'],
      name: json['name'],
      category: Category.fromJson(json['category']),
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
      'category': category.toJson(),
      'description': description,
      'condition': condition,
    };
  }
}
