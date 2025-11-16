import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyConnectScreen extends StatelessWidget {
  const SpotifyConnectScreen({super.key, required this.authUrl});

  final String authUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect Spotify')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('We will open Spotify to complete the connection. After granting permissions, return to the app.'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                final uri = Uri.parse(authUrl);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Spotify Login'),
            ),
          ],
        ),
      ),
    );
  }
}
