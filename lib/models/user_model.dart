class UserModel {
  final int? id;
  final String username;
  final String email;
  final String? token;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.token,
  });

  // Convertir JSON reçu du backend → UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      token: json['token'],
    );
  }

  // Convertir UserModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}