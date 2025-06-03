import 'package:levvu_client/core/models/jwt_claim_types.dart';
import 'package:levvu_client/core/models/user_login_response_model.dart';
import 'package:levvu_client/core/models/user_enum.dart';
import 'package:levvu_client/core/services/jwt/jwt_service.dart';

class JwtPayloadConverter {
  static UserLoginResponseModel convertToUser(Map<String, dynamic> payload) {
    final id =
        JwtService.getClaimValue(payload, JwtClaimTypes.nameIdentifier.value);
    if (id == null) {
      throw const FormatException('Claim nameIdentifier não encontrado no token');
    }

    final email =
        JwtService.getClaimValue(payload, JwtClaimTypes.emailAddress.value);
    if (email == null) {
      throw const FormatException('Claim emailAddress não encontrado no token');
    }

    final fullName =
        JwtService.getClaimValue(payload, JwtClaimTypes.name.value);
    if (fullName == null) {
      throw const FormatException('Claim name não encontrado no token');
    }

    return UserLoginResponseModel(
      id: id,
      email: email,
      fullName: fullName,
      phoneNumber: '', // Não disponível no token
      userType: EUserType.client, // Valor padrão
      acceptedTerm: true, // Valor padrão
      whatsappNotifications: true, // Valor padrão
      emailNotifications: true, // Valor padrão
      status: EUserStatusTypes.active, // Valor padrão
      profileId: '', // Não disponível no token
    );
  }
}
