import 'package:auth/src/domain/entities/auth_user.dart';

class AuthUserDto {
  final String id;
  final String email;
  final String name;

  const AuthUserDto({
    required this.id,
    required this.email,
    required this.name,
  });

  factory AuthUserDto.fromJson(Map<String, dynamic> json) => AuthUserDto(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};

  AuthUser toEntity() => AuthUser(id: id, email: email, name: name);
}
