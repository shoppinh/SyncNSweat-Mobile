import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout, required this.onOpen});

  final WorkoutModel workout;
  final VoidCallback onOpen;

  static Future<void> launchExternal(String? url) async {
    if (url == null) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workout.focus, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('${workout.durationMinutes} minutes · ${workout.exercises.length} exercises'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: workout.exercises
                  .take(4)
                  .map((workoutExercise) => Chip(label: Text(workoutExercise.exercise?.name ?? 'Exercise')))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onOpen,
                child: const Text('View workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
