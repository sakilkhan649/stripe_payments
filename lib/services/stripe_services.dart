import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../conostants/consts.dart';

class StripeServices {
  StripeServices._();
  static final StripeServices instance = StripeServices._();

  ///make payment
  Future<void> makePayment() async {
    try {
      final String? paymentIntentClientSecret = await _createPaymentIntent(
        100,
        'usd',
      );
      if (paymentIntentClientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Flutter Stripe',
        ),
      );

      await _presentPaymentSheet();
    } catch (e) {
      print('Error in makePayment: $e');
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': _calculateAmount(amount),
        'currency': currency,
      };

      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        return response.data['client_secret'];
      }

      return null;
    } catch (e) {
      print('Error in _createPaymentIntent: $e');
      return null;
    }
  }

  Future<void> _presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      print('StripeException: ${e.error.localizedMessage}');
    } catch (e) {
      print('Error in _presentPaymentSheet: $e');
    }
  }

  String _calculateAmount(int amount) {
    final calculateAmount = amount * 100;
    return calculateAmount.toString();
  }
}
