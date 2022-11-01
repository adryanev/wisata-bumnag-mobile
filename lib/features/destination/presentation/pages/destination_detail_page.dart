import 'package:flutter/material.dart';

class DestinationDetailPage extends StatelessWidget {
  const DestinationDetailPage({
    super.key,
    required this.destinationId,
  });
  final String? destinationId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SafeArea(child: Column()),
    );
  }
}
