import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/navigation_drawer.dart';
import '../../playlists/views/playlist_preview_sheet.dart';
import '../../workouts/views/workout_detail_screen.dart';
import '../../workouts/views/schedule_screen.dart';
import '../controllers/home_controller.dart';
import '../widgets/workout_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);

    return Scaffold(
      drawer: const MainNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          if (homeAsync.valueOrNull != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    '${homeAsync.value!.streak}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16,),
                  ),
                ],
              ),
            ),
          IconButton(
            onPressed: homeAsync.isLoading
                ? null
                : () => ref.read(homeControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: homeAsync.when(
        data: (data) => _HomeBody(data: data, ref: ref),
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CoolingProgressIndicator()),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AbsorbPointer(
            absorbing: homeAsync.isLoading,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: homeAsync.isLoading ? 0.6 : 1.0,
              child: FloatingActionButton.extended(
                heroTag: 'aiWorkout',
                onPressed: homeAsync.isLoading
                    ? null
                    : () =>
                    ref.read(homeControllerProvider.notifier).suggestWorkout(),
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('AI Workout'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'regenerate',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ScheduleScreen()),
              );
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('View Schedule'),
          ),
        ],
      ),
    );
  }
}

class CoolingProgressIndicator extends StatelessWidget {
  const CoolingProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Text(
          'Generating AI workout — this may take a minute',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const SizedBox(
          width: 200,
          child: LinearProgressIndicator(),
        ),
      ],
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.data, required this.ref});

  final HomeState data;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final workout = data.todayWorkout;
    final playlist = data.playlist;

    if (workout == null) {
      return const Center(
          child:
              Text('No workout available yet. Generate your first schedule!'),);
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          workout.focus,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        if (playlist != null && playlist.id.isNotEmpty)
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(playlist.name),
                  subtitle: Text(playlist.description ?? 'Open in Spotify'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => WorkoutCard.launchExternal(playlist.externalUrl),
                ),
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const PlaylistPreviewSheet(),
                    );
                  },
                  icon: const Icon(Icons.library_music),
                  label: const Text('Browse playlists'),
                ),
                TextButton.icon(
                  onPressed: () => ref
                      .read(homeControllerProvider.notifier)
                      .refreshPlaylist(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh playlist'),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        WorkoutCard(
          workout: workout,
          onOpen: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WorkoutDetailScreen(workoutId: workout.id),
              ),
            );
          },
        ),
      ],
    );
  }
}
