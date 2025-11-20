import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/router/navigation_drawer.dart';

import '../controllers/history_controller.dart';
import '../../workouts/views/workout_detail_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  static const path = '/history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyControllerProvider);

    return Scaffold(
      drawer: const MainNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Workout History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: historyAsync.isLoading ? null : () => ref.read(historyControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: historyAsync.when(
        data: (workouts) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: workouts.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return ListTile(
              title: Text(workout.focus),
              subtitle: Text('${workout.date.toLocal().toIso8601String().split('T').first} · ${workout.exercises.length} exercises'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailScreen(workoutId: workout.id),
                  ),
                );
              },
            );
          },
        ),
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
