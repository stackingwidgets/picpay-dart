import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:picpay/src/picpay_buyer.dart';

/// Requisição De Pagamento
///
/// Seu e-commerce irá solicitar o pagamento de um pedido através do PicPay na finalização do carrinho de compras. Após a requisição http, o cliente deverá ser redirecionado para o endereço informada no campo [paymentUrl] para que o mesmo possa finalizar o pagamento.
///
/// Assim que o pagamento for concluído o cliente será redirecionado para o endereço informada no campo [returnUrl] do json enviado pelo seu e-commerce no momento da requisição. Se não informado, nada acontecerá (o cliente permanecerá em nossa página de checkout).
///
/// Caso seja identificado que seu cliente também é cliente PicPay, iremos enviar um push notification e uma notificação dentro do aplicativo PicPay avisando sobre o pagamento pendente. Para todos os casos iremos enviar um e-mail de pagamento pendente contendo o link de nossa página de checkout.
class PicPayPayment {
  /// token gerado e fornecido pelo PicPay
  final String token;

  /// Identificador único do seu pedido. Este campo precisa ter um valor diferente a cada requisição.
  final String referenceId;

  /// Url para o qual o PicPay irá retornar a situação do pagamento.
  final String callbackUrl;

  /// Url para a qual o cliente será redirecionado após o pagamento.
  final String returnUrl;

  /// Valor do pagamento em reais.
  final double value;

  /// Quando a ordem de pagamento irá expirar.
  final DateTime expiresAt;

  /// Informações do comprador.
  final PicPayBuyer buyer;

  String _paymentUrl;
  String _qrcodeImage;
  String _qrcodeContent;
  bool _isRequestSuccess;
  int _requestCode;
  String _requestErrorMessage;

  /// URL na qual sua loja deve redirecionar o cliente para conclusão do pagamento.
  String get paymentUrl => _paymentUrl;

  /// Imagem do QR Code em formato base 64 (válido para exibir no frontend sem depender de plugins externos)
  String get qrcodeImage => _qrcodeImage;

  /// Conteúdo do QR Code
  String get qrcodeContent => _qrcodeContent;

  /// Retorna se a requisição foi feita com sucesso
  bool get isRequestSuccess => _isRequestSuccess;

  /// Conteúdo do QR Code
  String get requestErrorMessage =>
      "code: ${_requestCode} , message: ${_requestErrorMessage}.";

  PicPayPayment(
    this.token,
    this.referenceId,
    this.callbackUrl,
    this.value,
    this.buyer, {
    this.expiresAt,
    this.returnUrl,
  });

  Future<bool> makeRequest() async {
    try {
      var uri = Uri.https('appws.picpay.com', '/ecommerce/public/payments');

      var requestBody = jsonEncode({
        'referenceId': referenceId,
        'callbackUrl': callbackUrl,
        'value': value,
        'expiresAt': expiresAt,
        'returnUrl': returnUrl,
        'buyer': {
          'firstName': buyer.firstName,
          'lastName': buyer.lastName,
          'document': buyer.document,
          'email': buyer.email,
          'phone': buyer.phone,
        },
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

      print("Status: " + response.statusCode.toString());

      print("Body: " + response.body.toString());

      print("Data: " + requestBody.toString());

      this._requestCode = response.statusCode;
      this._isRequestSuccess = response.statusCode == 200 ? true : false;
      this._requestErrorMessage =
          _isRequestSuccess == true ? null : response.body.toString();

      if (_isRequestSuccess) {
        var data = jsonDecode(response.body);
        this._paymentUrl = data['_paymentUrl'];
        this._qrcodeContent = data['qrcode']['content'];
        this._qrcodeImage = data['qrcode']['base64'];
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<PicPayPayment> request(
    token,
    referenceId,
    callbackUrl,
    tvalue,
    buyer, {
    expiresAt,
    returnUrl,
  }) async {}
}
