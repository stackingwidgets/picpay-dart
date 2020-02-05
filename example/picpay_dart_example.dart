import 'package:picpay/picpay.dart';

void main() async {
  // Seu Token
  var token = 'jui888fs-1399-4e53-mnuf880-ea9cdea919c5';

  var buyer = PicPayBuyer(
      "Luiz", "Eduardo", "123.345.678.99", "luizeof@gmail.com", "12 12345678");

  var payment = PicPayPayment(
      token, "9999999", 'https://retorno.seusite.com.br', 10, buyer);

  await payment.makeRequest();

  print(payment.paymentUrl);

  print(payment.qrcodeContent);

  print(payment.qrcodeImage);

  var paymentStatus = await PicPayPaymentStatus.create(token, "1234");

  print(paymentStatus.status);
}
