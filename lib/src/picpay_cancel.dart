import 'package:http/http.dart' as http;
import 'dart:convert';

class PicPayCancelPayment {
  /// token gerado e fornecido pelo PicPay.
  final String token;

  /// Identificador único do seu pedido ue será cancelado.
  final String referenceId;

  /// ID da autorização que seu e-commerce recebeu na notificação de pedido pago. Caso o pedido não esteja pago, não é necessário enviar este parâmetro.
  final String authorizationId;

  PicPayCancelPayment(this.token, this.referenceId, this.authorizationId);

  Future<bool> cancelPayment() async {
    try {
      var uri = Uri.https('appws.picpay.com',
          '/ecommerce/public/payments/{$referenceId}/cancellations');

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

      return response.statusCode == 200 ? true : false;
    } catch (e) {
      return false;
    }
  }
}
