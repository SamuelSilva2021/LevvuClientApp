class UserRegisterModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String cpf;
  final String password;
  final String confirmPassword;
  final bool isClient;
  final bool isPartner;
  final bool acceptedTerm;
  final bool whatsappNotifications;
  final bool emailNotifications;

  UserRegisterModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.cpf,
    required this.password,
    required this.confirmPassword,
    this.isClient = true,
    this.isPartner = false,
    required this.acceptedTerm,
    this.whatsappNotifications = true,
    this.emailNotifications = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'cpf': cpf,
      'password': password,
      'confirmPassword': confirmPassword,
      'isClient': isClient,
      'isPartner': isPartner,
      'acceptedTerm': acceptedTerm,
      'whatsappNotifications': whatsappNotifications,
      'emailNotifications': emailNotifications,
    };
  }

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      cpf: json['cpf'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      isClient: json['isClient'] ?? true,
      isPartner: json['isPartner'] ?? false,
      acceptedTerm: json['acceptedTerm'] ?? false,
      whatsappNotifications: json['whatsappNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
    );
  }
}
