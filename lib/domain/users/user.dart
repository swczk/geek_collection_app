class User {
  int id;
  String username;
  String email;
  String profilePicture;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profilePicture: json['profilePicture'],
    );
    print("User => ${user.toJson()}");
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}
