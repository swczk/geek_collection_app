class Category {
  int id;
  String name;
//   String description;

  Category({
    required this.id,
    required this.name,
   //  required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    Category category = Category(
      id: json['id'],
      name: json['name'],
      // description: json['description'],
    );
	 print("Category => ${category.toJson()}");
	 return category;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // 'description': description,
    };
  }
}
