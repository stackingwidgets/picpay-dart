import 'package:http/http.dart' as http;
import 'dart:convert';

/// Utilize o endpoint abaixo para consultar o status de uma transação.
class PicPayPaymentStatus {
  /// token gerado e fornecido pelo PicPay.
  final String token;

  /// Identificador único do seu pedido ue será cancelado.
  final String referenceId;

  /// Status do Pedido
  String status;

  PicPayPaymentStatus(this.token, this.referenceId);

  Future<bool> _makeRequest() async {
    try {
      var uri = Uri.https(
          'appws.picpay.com', '/ecommerce/public/payments/$referenceId/status');
      var response = await http.get(
        uri.toString(),
        headers: {
          'x-picpay-token': token,
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      var data = jsonDecode(response.body.toString());
      this.status = data['status'];
      return response.statusCode == 200 ? true : false;
    } catch (e) {
      return false;
    }
  }

  static Future<PicPayPaymentStatus> create(
      String _token, String _status) async {
    var data = PicPayPaymentStatus(_token, _status);
    await data._makeRequest();
    return data;
  }
}
