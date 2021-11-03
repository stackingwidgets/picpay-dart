import 'dart:convert';

import 'package:http/http.dart' as http;

/// Utilize o endpoint abaixo para consultar o status de uma transação.
class PicPayPaymentStatus {
  /// token gerado e fornecido pelo PicPay.
  final String token;

  /// Identificador único do seu pedido ue será cancelado.
  final String referenceId;

  /// Status do Pedido
  String? status;

  /// O Status atual é registro criado
  bool get isCreated => status == 'created' ? true : false;

  /// O Status atual é prazo para pagamento expirado
  bool get isExpired => status == 'expired' ? true : false;

  /// O Status atual é pago e em processo de análise anti-fraude
  bool get isAnalysis => status == 'analysis' ? true : false;

  /// O Status atual é pago
  bool get isPaid => status == 'paid' ? true : false;

  /// O Status atual é pago e saldo disponível
  bool get isCompleted => status == 'completed' ? true : false;

  /// O Status atual é pago e devolvido
  bool get isRefunded => status == 'refunded' ? true : false;

  /// O Status atual é pago e com chargeback
  bool get isChargeback => status == 'chargeback' ? true : false;

  /// Utilize o endpoint abaixo para consultar o status de uma transação.
  PicPayPaymentStatus(this.token, this.referenceId);

  Future<bool> _makeRequest() async {
    try {
      var uri = Uri.https(
          'appws.picpay.com', '/ecommerce/public/payments/$referenceId/status');
      var response = await http.get(
        uri,
        headers: {
          'x-picpay-token': token,
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      var data = jsonDecode(response.body.toString());
      status = data['status'].toString();
      return response.statusCode == 200 ? true : false;
    } on Exception catch (e) {
      print(e.toString());
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

  @override
  String toString() =>
      'PicPayPaymentStatus(token: $token, referenceId: $referenceId, status: $status)';
}
