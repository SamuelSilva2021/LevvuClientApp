class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String cpf;
  final bool isClient;
  final bool isPartner;
  final bool whatsappNotifications;
  final bool emailNotifications;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.cpf,
    this.isClient = true,
    this.isPartner = false,
    this.whatsappNotifications = true,
    this.emailNotifications = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      cpf: json['cpf'] ?? '',
      isClient: json['isClient'] ?? true,
      isPartner: json['isPartner'] ?? false,
      whatsappNotifications: json['whatsappNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'cpf': cpf,
      'isClient': isClient,
      'isPartner': isPartner,
      'whatsappNotifications': whatsappNotifications,
      'emailNotifications': emailNotifications,
    };
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
      isClient: isClient,
      isPartner: isPartner,
      whatsappNotifications: whatsappNotifications ?? this.whatsappNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
    );
  }
}
