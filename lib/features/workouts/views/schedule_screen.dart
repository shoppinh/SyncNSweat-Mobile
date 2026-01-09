import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncnsweat_mobile/features/workouts/controllers/schedule_controller.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  static const path = '/schedule';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(scheduleControllerProvider.notifier)
                .generateSchedule(),
          ),
        ],
      ),
      body: scheduleAsync.when(
        data: (schedule) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: schedule.weeklySchedule!.dailyWorkouts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final day = schedule.weeklySchedule!.dailyWorkouts[index];
              final isToday =
                  day.dayOfWeek == DateFormat('E').format(DateTime.now());

              return Card(
                color: isToday
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isToday ? Theme.of(context).colorScheme.primary : null,
                    foregroundColor: isToday
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                        // Format the dayOfWeek iso string to a short day name
                    child: Text(DateFormat('E').format(DateTime.parse(day.dayOfWeek))),
                  ),
                  title: Text(day.focus),
                  subtitle: day.playlistName != null
                      ? Text('${day.playlistName}')
                      : const Text('No playlist assigned'),
                  onTap:  () {
                          // Navigate to workout detail or start workout
                          // For now just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Starting ${day.focus} workout'),),
                          );
                        },
                ),
              );
            },
          );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
