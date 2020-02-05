# PicPay

A [PicPay](https://picpay.com/) library for Dart developers based on [e-Commerce Public API (1.0)](https://ecommerce.picpay.com/doc/).

## Usage

A simple usage example:

### Create Payment

```dart
import 'package:picpay/picpay.dart';

void main() async {

  var token = '5b008f2367b2-1399-5b008cef';

  // Create a PicPay Buyer
  var buyer = PicPayBuyer("Luiz", "Eduardo", "123.345.678.99",
      "luizeof@gmail.com", "+551212345678");

  // Create a Payment
  var payment = await PicPayPayment.create(
      token, "9999999", 'https://retorno.seusite.com.br', 10, buyer);

  // Buyer Paymento URL
  print(payment.paymentUrl);

  // Buyer Payment QRCode Content
  print(payment.qrcodeContent);

  // Buyer Payment QRCode Image Base64
  print(payment.qrcodeImage);

}
```

### Check Payment Status

```dart
import 'package:picpay/picpay.dart';

void main() async {

  var token = '5b008f2367b2-1399-5b008cef';

  var paymentStatus = await PicPayPaymentStatus.create(token, "1234");

  print(paymentStatus.status);

}
```

### Cancel Payment

```dart
import 'package:picpay/picpay.dart';

void main() async {

  var token = '5b008f2367b2-1399-5b008cef';

  var paymentCancel = await PicPayCancelPayment.create(token, "1234");

  print(paymentCancel.isRequestSuccess);

}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/stackingwidgets/picpay-dart/issues
