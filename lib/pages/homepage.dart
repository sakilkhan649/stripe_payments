import 'package:flutter/material.dart';

import '../services/stripe_services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stripe Payments")),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            MaterialButton(
              onPressed: () {
                StripeServices.instance.makePayment();
              },
              color: Colors.green,
              child: Text("Purchase"),
            ),
          ],
        ),
      ),
    );
  }
}
