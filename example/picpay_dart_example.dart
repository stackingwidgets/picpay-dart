import 'package:picpay/picpay.dart';

void main() async {
  var token = '5b008f2367b2-1399-4e53-5b008c-5b008cef';

  var buyer = PicPayBuyer("Luiz", "Eduardo", "123.345.678.99",
      "luizeof@gmail.com", "+551212345678");

  var payment = await PicPayPayment.create(
      token, "9999999", 'https://retorno.seusite.com.br', 10, buyer);

  print(payment.paymentUrl);

  print(payment.qrcodeContent);

  print(payment.qrcodeImage);

  var paymentStatus = await PicPayPaymentStatus.create(token, "1234");

  print(paymentStatus.status);

  var paymentCancel = await PicPayCancelPayment.create(token, "1234");

  print(paymentCancel.isRequestSuccess);
}
