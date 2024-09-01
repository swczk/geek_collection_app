import 'package:geek_collection/domain/users/user.dart';

class Share {
  int id;
  User user;

  Share({
    required this.id,
    required this.user,
  });

  factory Share.fromJson(Map<String, dynamic> json) {
    Share share = Share(
      id: json['id'],
      user: User.fromJson(json['user']),
    );
    print("Share => ${share.toJson()}");
    return share;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
    };
  }
}
