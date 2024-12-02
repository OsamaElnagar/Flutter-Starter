import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helpers/route_helper.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Start building amazing products!',
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(RouteHelper.paymentTest),
              icon: const Icon(Icons.payment),
              label: const Text('Test Payment Integration'),
            ),
          ],
        ),
      ),
    );
  }
}
