class CreateCollectionDTO {
  String name;
  String description;

  CreateCollectionDTO({
    required this.name,
    required this.description,
  });

  factory CreateCollectionDTO.fromJson(Map<String, dynamic> json) {
    return CreateCollectionDTO(
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}
