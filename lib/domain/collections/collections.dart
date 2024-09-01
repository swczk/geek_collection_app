import 'package:geek_collection/domain/items/item.dart';
import 'package:geek_collection/domain/shares/share.dart';
import 'package:geek_collection/domain/users/user.dart';

class Collection {
  int id;
  String name;
  String description;
  User owner;
  List<Share> shares;
  List<Item> items;

  Collection({
    required this.id,
    required this.name,
    required this.description,
	 required this.owner,
    required this.shares,
    required this.items,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    var sharesFromJson = json['shares'] as List;
    List<Share> sharesList =
        sharesFromJson.map((i) => Share.fromJson(i)).toList();

    var itemsFromJson = json['items'] as List;
    List<Item> itemsList = itemsFromJson.map((i) => Item.fromJson(i)).toList();

    var collection = Collection(
      id: json['id'],
      name: json['name'],
      description: json['description'],
		owner: User.fromJson(json['user']),
      shares: sharesList,
      items: itemsList,
    );
    print("Collection => ${collection.toJson()}");
    return collection;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
		'owner': owner.toJson(),
      'shares': shares.map((e) => e.toJson()).toList(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
