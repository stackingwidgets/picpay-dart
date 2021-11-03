import 'package:picpay/picpay.dart';
import 'dart:math';

void main() async {
  var token = '5b008f2367b2-1399-5b008cef';

  var buyer = PicPayBuyer(
    "Luiz",
    "Eduardo",
    "123.345.678.99",
    "luizeof@gmail.com",
    "+551212345678",
  );
  Random _rand = Random();
  var payment = await PicPayPayment.create(
    token,
    _rand.nextInt(999999).toString(),
    'https://retorno.seusite.com.br',
    10,
    buyer,
  );

  print(payment.paymentUrl);

  print(payment.qrcodeContent);

  print(payment.qrcodeImage);

  var paymentStatus = await PicPayPaymentStatus.create(token, payment.referenceId);

  print((paymentStatus.toString()));

  var paymentCancel = await PicPayCancelPayment.create(token, payment.referenceId);

  print(paymentCancel);
}
