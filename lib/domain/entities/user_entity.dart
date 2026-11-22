class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
