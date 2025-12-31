import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/router/navigation_drawer.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/views/spotify_connect_screen.dart';
import '../controllers/profile_controller.dart';
import 'profile_edit_screen.dart';
import 'preferences_edit_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const path = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value?.user;

    return Scaffold(
      drawer: const MainNavigationDrawer(),
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(user.email),
              subtitle: Text(user.spotifyConnected
                  ? 'Spotify connected'
                  : 'Spotify not connected',),
            ),
            Consumer(
              builder: (context, ref, child) {
                final profileAsync = ref.watch(profileControllerProvider);
                return ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Profile'),
                  subtitle: profileAsync.when(
                    data: (profile) =>
                        profile == null ? const Text('Create Profile') : null,
                    error: (_, __) => const Text('Error loading profile'),
                    loading: () => const Text('Loading...'),
                  ),
                  onTap: () {
                    profileAsync.whenData((profile) {
                      if (profile != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfileEditScreen(profile: profile),
                          ),
                        );
                      } else {
                        // Handle create profile case if needed, or just show edit with default
                        // For now assuming profile exists or we handle creation elsewhere
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Profile not found, please create one first',),),
                        );
                      }
                    });
                  },
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final preferencesAsync =
                    ref.watch(preferencesControllerProvider);
                return ListTile(
                  leading: const Icon(Icons.tune),
                  title: const Text('Edit Preferences'),
                  subtitle: preferencesAsync.when(
                    data: (prefs) =>
                        prefs == null ? const Text('Set up preferences') : null,
                    error: (_, __) => const Text('Error loading preferences'),
                    loading: () => const Text('Loading...'),
                  ),
                  onTap: () {
                    preferencesAsync.whenData((prefs) {
                      if (prefs != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PreferencesEditScreen(preferences: prefs),
                          ),
                        );
                      } else {
                        // Handle create case or show default
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Preferences not found, please try again later',),),
                        );
                      }
                    });
                  },
                );
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Connect Spotify'),
            onTap: () => _connectSpotify(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }

  Future<void> _connectSpotify(BuildContext context, WidgetRef ref) async {
    final authRepository = ref.read(authRepositoryProvider);
    final authUrl = await authRepository.getSpotifyAuthUrl();
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpotifyConnectScreen(authUrl: authUrl),
      ),
    );
  }
}
