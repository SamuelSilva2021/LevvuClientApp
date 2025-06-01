import 'package:levvu_client/core/models/user_enum.dart';

class UserLoginResponseModel {
  final String id;
  final String email;
  final String fullName;
  final String? cpf;
  final String phoneNumber;
  final EUserType userType;
  final bool acceptedTerm;
  final bool whatsappNotifications;
  final bool emailNotifications;
  final EUserStatusTypes status;
  final String profileId;

  UserLoginResponseModel({
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

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      cpf: json['cpf'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      userType: EUserType.values[json['userType'] as int],
      acceptedTerm: json['acceptedTerm'] as bool,
      whatsappNotifications: json['whatsappNotifications'] as bool,
      emailNotifications: json['emailNotifications'] as bool,
      status: EUserStatusTypes.values[json['status'] as int],
      profileId: json['profileId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'cpf': cpf,
      'phoneNumber': phoneNumber,
      'userType': userType.index,
      'acceptedTerm': acceptedTerm,
      'whatsappNotifications': whatsappNotifications,
      'emailNotifications': emailNotifications,
      'status': status.index,
      'profileId': profileId,
    };
  }
}
