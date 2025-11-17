import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/profile_model.dart';
import '../controllers/onboarding_controller.dart';
import 'preferences_step_screen.dart';

class ProfileStepScreen extends ConsumerStatefulWidget {
  const ProfileStepScreen({super.key});

  static const path = '/onboarding/profile';

  @override
  ConsumerState<ProfileStepScreen> createState() => _ProfileStepScreenState();
}

class _ProfileStepScreenState extends ConsumerState<ProfileStepScreen> {
  final _nameController = TextEditingController();
  FitnessGoal _goal = FitnessGoal.strength;
  FitnessLevel _level = FitnessLevel.beginner;
  final Set<String> _days = {'monday', 'wednesday', 'friday'};
  double _duration = 45;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingAsync = ref.watch(onboardingControllerProvider);
    final isLoading = onboardingAsync.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Tell us about you')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<FitnessGoal>(
              initialValue: _goal,
              decoration: const InputDecoration(labelText: 'Goal'),
              items: FitnessGoal.values
                  .map((goal) => DropdownMenuItem(
                        value: goal,
                        child: Text(goal.name),
                      ),)
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _goal = value);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<FitnessLevel>(
              initialValue: _level,
              decoration: const InputDecoration(labelText: 'Experience level'),
              items: FitnessLevel.values
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level.name),
                      ),)
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _level = value);
                }
              },
            ),
            const SizedBox(height: 24),
            const Text('Workout days'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _weekdayChips(),
            ),
            const SizedBox(height: 24),
            Text('Session duration: ${_duration.round()} minutes'),
            Slider(
              min: 20,
              max: 90,
              value: _duration,
              divisions: 14,
              onChanged: (value) => setState(() => _duration = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isLoading ? null : () => _submit(ref),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(isLoading ? 'Saving...' : 'Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _weekdayChips() {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    return days
        .map(
          (day) => FilterChip(
            label: Text(day.substring(0, 3).toUpperCase()),
            selected: _days.contains(day),
            onSelected: (value) {
              setState(() {
                if (value) {
                  _days.add(day);
                } else {
                  _days.remove(day);
                }
              });
            },
          ),
        )
        .toList();
  }

  Future<void> _submit(WidgetRef ref) async {
    final controller = ref.read(onboardingControllerProvider.notifier);
    await controller.saveProfile(
      name: _nameController.text.trim(),
      goal: _goal,
      level: _level,
      days: _days.toList(),
      durationMinutes: _duration.round(),
    );
    if (mounted) {
      context.go(PreferencesStepScreen.path);
    }
  }
}
