import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/workout_detail_controller.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  const WorkoutDetailScreen({super.key, required this.workoutId});

  final int workoutId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutAsync = ref.watch(workoutDetailControllerProvider(workoutId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: workoutAsync.isLoading
                ? null
                : () => ref.read(workoutDetailControllerProvider(workoutId).notifier).refresh(),
          ),
        ],
      ),
      body: workoutAsync.when(
        data: (workout) => ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: workout.exercises.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final exercise = workout.exercises[index];
            return Card(
              child: ListTile(
              leading: CircleAvatar(child: Text('${exercise.order ?? index + 1}')),
              title: Text(exercise.exercise?.name ?? 'Exercise'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('${exercise.sets ?? '-'} sets · ${exercise.reps ?? '-'} reps'),
                if (exercise.exercise?.instructions != null && exercise.exercise!.instructions!.isNotEmpty)
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: exercise.exercise!.instructions!.map((instruction) => Text('• $instruction', style: const TextStyle(fontSize: 12))).toList(),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.swap_horiz),
                onPressed: () => ref
                  .read(workoutDetailControllerProvider(workoutId).notifier)
                  .swapExercise(exercise.id),
              ),
              ),
            );
          },
        ),
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
