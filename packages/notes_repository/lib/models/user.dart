import 'dart:convert';

class User {
  final String id;
  final String? username;
  final String? email;
  final String? password;
  final String? imageAsBase64;
  final String? interestId;
  User({
    required this.id,
    this.username,
    this.email,
    this.password,
    this.imageAsBase64,
    this.interestId,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? imageAsBase64,
    String? interestId,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      imageAsBase64: imageAsBase64 ?? this.imageAsBase64,
      interestId: interestId ?? this.interestId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'imageAsBase64': imageAsBase64,
      'intrestId': interestId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      imageAsBase64:
          map['imageAsBase64'] != null ? map['imageAsBase64'] as String : null,
      interestId: map['intrestId'] != null ? map['intrestId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, password: $password, imageAsBase64: $imageAsBase64, interestId: $interestId)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.email == email &&
        other.password == password &&
        other.imageAsBase64 == imageAsBase64 &&
        other.interestId == interestId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        password.hashCode ^
        imageAsBase64.hashCode ^
        interestId.hashCode;
  }
}
