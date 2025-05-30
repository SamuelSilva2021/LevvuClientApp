enum UserType { client, partner, admin }

enum UserStatus { active, inactive, blocked }

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String cpf;
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
    required this.cpf,
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
      'userType': userType.toString().split('.').last,
      'acceptedTerm': acceptedTerm,
      'whatsappNotifications': whatsappNotifications,
      'emailNotifications': emailNotifications,
      'status': status.toString().split('.').last,
      'profileId': profileId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      cpf: json['cpf']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      userType: _parseUserType(json['userType']),
      acceptedTerm: json['acceptedTerm'] ?? false,
      whatsappNotifications: json['whatsappNotifications'] ?? false,
      emailNotifications: json['emailNotifications'] ?? false,
      status: _parseUserStatus(json['status']),
      profileId: json['profileId']?.toString() ?? '',
    );
  }

  static UserType _parseUserType(dynamic value) {
    if (value == null) return UserType.client;
    final type = value.toString().toLowerCase();
    switch (type) {
      case 'partner':
        return UserType.partner;
      case 'admin':
        return UserType.admin;
      default:
        return UserType.client;
    }
  }

  static UserStatus _parseUserStatus(dynamic value) {
    if (value == null) return UserStatus.active;
    final status = value.toString().toLowerCase();
    switch (status) {
      case 'inactive':
        return UserStatus.inactive;
      case 'blocked':
        return UserStatus.blocked;
      default:
        return UserStatus.active;
    }
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
      cpf: cpf,
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
