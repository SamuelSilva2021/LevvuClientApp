enum UserType {
  client(0),
  partner(1),
  backoffice(2),
  user(3);

  final int value;
  const UserType(this.value);

  factory UserType.fromValue(int value) {
    return UserType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => UserType.client,
    );
  }
}

enum UserStatus {
  pending(0),
  active(1),
  blocked(2),
  deleted(3);

  final int value;
  const UserStatus(this.value);

  factory UserStatus.fromValue(int value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserStatus.pending,
    );
  }
}

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? cpf;
  final String phoneNumber;
  final UserType userType;
  final bool acceptedTerm;
  final bool whatsappNotifications;
  final bool emailNotifications;
  final UserStatus status;
  final String profileId;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.cpf,
    required this.phoneNumber,
    required this.userType,
    required this.acceptedTerm,
    required this.whatsappNotifications,
    required this.emailNotifications,
    required this.status,
    required this.profileId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'cpf': cpf,
      'phoneNumber': phoneNumber,
      'userType': userType.value,
      'acceptedTerm': acceptedTerm,
      'whatsappNotifications': whatsappNotifications,
      'emailNotifications': emailNotifications,
      'status': status.value,
      'profileId': profileId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      cpf: json['cpf'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      userType: UserType.values[json['userType'] as int],
      acceptedTerm: json['acceptedTerm'] as bool,
      whatsappNotifications: json['whatsappNotifications'] as bool,
      emailNotifications: json['emailNotifications'] as bool,
      status: UserStatus.values[json['status'] as int],
      profileId: json['profileId'] as String,
    );
  }

  // Criar uma cópia com campos atualizados
  UserModel copyWith({
    String? fullName,
    String? phoneNumber,
    bool? whatsappNotifications,
    bool? emailNotifications,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType,
      acceptedTerm: acceptedTerm,
      whatsappNotifications:
          whatsappNotifications ?? this.whatsappNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      status: status,
      profileId: profileId,
    );
  }
}
