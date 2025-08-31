
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'active_trip.dart';

class StartTripScreen extends StatefulWidget {
  const StartTripScreen({super.key});

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  final TextEditingController _dest = TextEditingController(text: 'Connaught Place, Delhi');
  bool _sharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-Time Safety & Trust')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Destination', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _dest,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter destination',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('Map preview (static for MVP)')),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ActiveTripScreen(destinationLabel: _dest.text),
                      ));
                    },
                    child: const Text('Start Trip'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _sharing ? null : _shareLink,
              icon: const Icon(Icons.ios_share),
              label: const Text('Share Trip Link'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _shareLink() async {
    setState(() => _sharing = true);
    final uri = Uri.parse('https://example.com/track?tripId=DEMO-DEL-CP&token=demo');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    setState(() => _sharing = false);
  }
}
