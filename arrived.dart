
import 'package:flutter/material.dart';

class ArrivedScreen extends StatelessWidget {
  final String destinationLabel;
  const ArrivedScreen({super.key, required this.destinationLabel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Completed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 96, color: Colors.green),
            const SizedBox(height: 12),
            Text('Arrived safely at\n$destinationLabel', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Done'),
            )
          ],
        ),
      ),
    );
  }
}
