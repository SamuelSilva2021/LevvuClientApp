enum JwtClaimTypes {
  nameIdentifier(
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'),
  emailAddress(
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'),
  name('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name');

  final String value;
  const JwtClaimTypes(this.value);
}
