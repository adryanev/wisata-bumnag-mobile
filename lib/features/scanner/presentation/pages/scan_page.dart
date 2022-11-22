import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AiBarcodeScanner(
              canPop: false,
              hintText: '',
              onScan: (value) {
                debugPrint('detected: $value');
              },
            ),
            Center(
              child: Assets.animations.scanLottie.lottie(),
            )
          ],
        ),
      ),
    );
  }
}
