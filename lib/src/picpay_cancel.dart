import 'dart:convert';
import 'package:http/http.dart' as http;

/// Utilize este endereço para solicitar o cancelamento/estorno de um pedido
class PicPayCancelPayment {
  /// token gerado e fornecido pelo PicPay.
  final String token;

  /// Identificador único do seu pedido ue será cancelado.
  final String referenceId;

  /// ID da autorização que seu e-commerce recebeu na notificação de
  /// pedido pago. Caso o pedido não esteja pago, não é necessário
  /// enviar este parâmetro.
  final String authorizationId;

  /// Retorna se a requisição foi feita com sucesso
  bool get isRequestSuccess => _isRequestSuccess;

  /// Conteúdo do QR Code
  String get requestErrorMessage =>
      'code: $_requestCode , message: $_requestErrorMessage.';

  bool _isRequestSuccess;
  int _requestCode;
  String _requestErrorMessage;

  /// Utilize este endereço para solicitar o cancelamento/estorno de um pedido
  PicPayCancelPayment(this.token, this.referenceId, [this.authorizationId]);

  /// Envia a Requisição De Cancelamento ao Picpay
  Future<bool> makeRequest() async {
    try {
      var uri = Uri.https('appws.picpay.com',
          '/ecommerce/public/payments/$referenceId/cancellations');

      var requestBody = jsonEncode({
        'authorizationId': authorizationId,
      });

      var response = await http.post(
        uri.toString(),
        headers: {
          'x-picpay-token': token,
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      _requestCode = response.statusCode;
      _isRequestSuccess = response.statusCode == 200 ? true : false;
      _requestErrorMessage =
          _isRequestSuccess == true ? null : response.body.toString();

      return response.statusCode == 200 ? true : false;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  /// Utilize este endereço para solicitar o cancelamento/estorno de um pedido
  static Future<PicPayCancelPayment> create(String _token, String _referenceId,
      [String _authorizationId]) async {
    var data = PicPayCancelPayment(_token, _referenceId, _authorizationId);
    await data.makeRequest();
    return data;
  }
}
