enum EUserType {
  client,
  partner,
  backoffice,
  user,
}

enum EUserStatusTypes {
  /// Usuário pendente
  pending,

  /// Usuário ativo
  active,

  /// Usuário bloqueado
  blocked,

  /// Usuário excluído
  deleted,
}
