import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import 'spotify_connect_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const path = '/auth';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        final message = next.error?.toString() ?? 'Authentication failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    });

    final isLoading = authAsync.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('SyncNSweat Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              isSelected: [_isRegister, !_isRegister],
              onPressed: (index) {
                setState(() {
                  _isRegister = index == 0;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Create account'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Login'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isRegister)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isLoading ? null : () => _submit(ref),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(isLoading ? 'Please wait...' : (_isRegister ? 'Create account' : 'Login')),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            const Text('Prefer connecting with Spotify?'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: isLoading ? null : () => _startSpotifyFlow(context, ref),
              icon: const Icon(Icons.music_note),
              label: const Text('Continue with Spotify'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(WidgetRef ref) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final authController = ref.read(authControllerProvider.notifier);

    if (_isRegister) {
      final name = _nameController.text.trim();
      await authController.register(email: email, password: password, name: name);
    } else {
      await authController.login(email: email, password: password);
    }
  }

  Future<void> _startSpotifyFlow(BuildContext context, WidgetRef ref) async {
    final authRepository = ref.read(authRepositoryProvider);
    final authUrl = await authRepository.getSpotifyAuthUrl();
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SpotifyConnectScreen(authUrl: authUrl)),
      );
    } else {
      final uri = Uri.parse(authUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
