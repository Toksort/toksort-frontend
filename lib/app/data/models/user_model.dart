class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? phone;

  UserModel({this.id, this.name, this.email, this.role, this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"]?.toString() ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      phone: json["phone"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
      };
}

class UserProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? phone;
  final String? avatar;
  final bool? isActive;
  final bool? isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.avatar,
    this.isActive,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  // Membuat JSON hanya dengan field yang valid (tidak null atau kosong)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (name != null && name!.isNotEmpty) data['name'] = name;
    if (email != null && email!.isNotEmpty) data['email'] = email;
    if (role != null && role!.isNotEmpty) data['role'] = role;
    if (phone != null && phone!.isNotEmpty) data['phone'] = phone;
    if (avatar != null && avatar!.isNotEmpty) data['avatar'] = avatar;
    if (isActive != null) data['isActive'] = isActive;
    if (isVerified != null) data['isVerified'] = isVerified;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }

  // Factory untuk parsing dari JSON (jika perlu)
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool?,
      isVerified: json['isVerified'] as bool?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  UserProfileModel? get data => null;
}

class UpdateProfileModel {
  final String? id;
  final String? name;
  final String? email;

  UpdateProfileModel({
    this.id,
    this.name,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (name != null && name!.isNotEmpty) data['name'] = name;
    if (email != null && email!.isNotEmpty) data['email'] = email;
    return data;
  }

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
    );
  }
}

class UpdateAvatarModel {
  final String? id;
  final String? avatarBase64; // atau url/file sesuai backend

  UpdateAvatarModel({this.id, this.avatarBase64});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (avatarBase64 != null && avatarBase64!.isNotEmpty)
      data['avatar'] = avatarBase64;
    return data;
  }

  // ✨ copyWith untuk update field tanpa membuat object baru dari awal
  UpdateAvatarModel copyWith({
    String? id,
    String? avatarBase64,
  }) {
    return UpdateAvatarModel(
      id: id ?? this.id,
      avatarBase64: avatarBase64 ?? this.avatarBase64,
    );
  }
}
