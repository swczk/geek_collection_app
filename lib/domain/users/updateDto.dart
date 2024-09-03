class UpdateUserDto {
  String username;
  String email;
  String password;
  String profilePicture;

  UpdateUserDto({
    required this.username,
    required this.email,
    required this.password,
    required this.profilePicture,
  });

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) {
    return UpdateUserDto(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'profilePicture': profilePicture,
    };
  }
}
