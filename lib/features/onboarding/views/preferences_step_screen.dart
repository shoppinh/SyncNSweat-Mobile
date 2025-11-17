import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';
import '../../home/views/home_screen.dart';

class PreferencesStepScreen extends ConsumerStatefulWidget {
  const PreferencesStepScreen({super.key});

  static const path = '/onboarding/preferences';

  @override
  ConsumerState<PreferencesStepScreen> createState() => _PreferencesStepScreenState();
}

class _PreferencesStepScreenState extends ConsumerState<PreferencesStepScreen> {
  final _equipmentController = TextEditingController();
  final _targetsController = TextEditingController();
  final _genresController = TextEditingController();
  String? _tempo;

  @override
  void dispose() {
    _equipmentController.dispose();
    _targetsController.dispose();
    _genresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingAsync = ref.watch(onboardingControllerProvider);
    final isLoading = onboardingAsync.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildChipInput(_equipmentController, 'Equipment (comma separated)'),
            const SizedBox(height: 16),
            _buildChipInput(_targetsController, 'Target muscles (comma separated)'),
            const SizedBox(height: 16),
            _buildChipInput(_genresController, 'Music genres (comma separated)'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Preferred tempo (optional)'),
              initialValue: _tempo,
              items: const [
                DropdownMenuItem(value: 'high', child: Text('High energy')),
                DropdownMenuItem(value: 'medium', child: Text('Moderate pace')),
                DropdownMenuItem(value: 'low', child: Text('Calm / focus')),
              ],
              onChanged: (value) => setState(() => _tempo = value),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: isLoading ? null : () => _submit(ref),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(isLoading ? 'Saving...' : 'Finish'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipInput(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        helperText: 'Use commas to separate values',
      ),
    );
  }

  Future<void> _submit(WidgetRef ref) async {
    final equipment = _equipmentController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final targets = _targetsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final genres = _genresController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    final controller = ref.read(onboardingControllerProvider.notifier);
    await controller.savePreferences(
      equipment: equipment,
      targets: targets,
      genres: genres,
      tempo: _tempo,
    );

    if (mounted) {
      context.go(HomeScreen.path);
    }
  }
}
