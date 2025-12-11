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
                : () => ref
                    .read(workoutDetailControllerProvider(workoutId).notifier)
                    .refresh(),
          ),
        ],
      ),
      body: workoutAsync.when(
        data: (workout) => ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: workout.exercises.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final workoutExercise = workout.exercises[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${workoutExercise.order ?? index + 1}'),
                ),
                title: Text(workoutExercise.exercise?.name ?? 'Exercise'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${workoutExercise.sets ?? '-'} sets · ${workoutExercise.reps ?? '-'} reps',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (workoutExercise.exercise?.gifUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            workoutExercise.exercise!.gifUrl!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    if (workoutExercise.exercise?.instructions != null &&
                        workoutExercise.exercise!.instructions!.isNotEmpty)
                      ...workoutExercise.exercise!.instructions!.map(
                        (instruction) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(
                                  instruction,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () => ref
                      .read(workoutDetailControllerProvider(workoutId).notifier)
                      .swapExercise(workoutExercise.exercise!.id),
                ),
              ),
            );
          },
        ),
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: workoutAsync.isLoading
            ? null
            : () async {
                await ref
                    .read(workoutDetailControllerProvider(workoutId).notifier)
                    .completeWorkout();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Workout Completed! Streak updated.')),
                  );
                }
              },
        label: const Text('Complete Workout'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
