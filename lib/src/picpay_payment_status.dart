import 'dart:convert';
import 'package:http/http.dart' as http;

/// Utilize o endpoint abaixo para consultar o status de uma transação.
class PicPayPaymentStatus {
  /// token gerado e fornecido pelo PicPay.
  final String token;

  /// Identificador único do seu pedido ue será cancelado.
  final String referenceId;

  /// Status do Pedido
  String status;

  /// Utilize o endpoint abaixo para consultar o status de uma transação.
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
      status = data['status'].toString();
      return response.statusCode == 200 ? true : false;
    } catch (e) {
      return false;
    }
  }

  /// Returna o objeto PicPayPaymentStatus
  static Future<PicPayPaymentStatus> create(
      String _token, String _status) async {
    var data = PicPayPaymentStatus(_token, _status);
    await data._makeRequest();
    return data;
  }
}
