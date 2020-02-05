/// Objeto contendo as informações do comprador.
class PicPayBuyer {
  /// Primeiro nome do comprador.
  final String firstName;

  /// Sobrenome do comprador.
  final String lastName;

  /// CPF do comprador no formato 123.456.789-10
  final String document;

  /// E-mail do comprador.
  final String email;

  /// Numero de telefone do comprador no formato +55 27 12345-6789
  final String phone;

  /// Objeto contendo as informações do comprador.
  PicPayBuyer(
    this.firstName,
    this.lastName,
    this.document,
    this.email,
    this.phone,
  );

  /// Retorna o Json
  dynamic toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'document': document,
      'email': email,
      'phone': phone,
    };
  }
}
