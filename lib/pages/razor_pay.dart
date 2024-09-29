import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:razorpay_integration/pages/success_page.dart';

class RazorPay extends StatefulWidget {
  const RazorPay({super.key});

  @override
  State<RazorPay> createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
  final TextEditingController _amountController = TextEditingController();
  late Razorpay _razorPay;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SuccessPage()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void initState() {
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorPay.clear();
    super.dispose();
  }

  void openCheckout() async {
    var options = {
      'key': "rzp_test_zmEmTjiie5noU8",
      'amount': double.parse(_amountController.text) * 100,
      'name': 'Buy Me Coffee!',
      'description': 'Flutter Course',
      'prefill': {
        'contact': '0000000000',
        'email': 'user@example.com',
      }
    };
    try {
      _razorPay.open(options);
    } catch (err) {
      print("Error $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(
            left: 30,
          ),
          child: Text(
            "Home",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset(
              'assets/coffee.json',
              height: 350,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _amountController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: <Color>[
                          Colors.blue,
                          Colors.red,
                          Colors.greenAccent,
                          Colors.purpleAccent
                        ],
                      ).createShader(const Rect.fromLTWH(0, 0, 150, 70)),
                    // fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  label: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText("ENTER AMOUNT!"),
                      TyperAnimatedText("YOU CAN PAY ANY AMOUNT!"),
                      TyperAnimatedText("THANK YOU!"),
                    ],
                    isRepeatingAnimation: true,
                    // totalRepeatCount: 1000,
                    repeatForever: true,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.blueGrey,
                      width: 2.0,
                    ), // Border color when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ), // Border color when enabled but not focused
                  ),
                  hintText: "",
                  prefixIcon: const Icon(Icons.money),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.withOpacity(0.5),
              ),
              onPressed: openCheckout,
              child: const Text(
                "ONLINE PAY",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}