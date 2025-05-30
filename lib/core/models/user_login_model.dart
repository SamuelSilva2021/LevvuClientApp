class UserLoginModel {
  final String email;
  final String password;

  UserLoginModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
