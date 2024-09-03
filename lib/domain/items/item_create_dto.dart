class ItemCreate {
  String name;
  int categoryId;
  String description;
  String condition;

  ItemCreate({
    required this.name,
    required this.categoryId,
    required this.description,
    required this.condition,
  });

  factory ItemCreate.fromJson(Map<String, dynamic> json) {
    ItemCreate item = ItemCreate(
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
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'condition': condition,
    };
  }
}
