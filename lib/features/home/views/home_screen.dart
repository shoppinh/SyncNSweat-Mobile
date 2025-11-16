import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/navigation_drawer.dart';
import '../../playlists/views/playlist_preview_sheet.dart';
import '../../workouts/views/workout_detail_screen.dart';
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
          IconButton(
            onPressed: homeAsync.isLoading ? null : () => ref.read(homeControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: homeAsync.when(
        data: (data) => _HomeBody(data: data, ref: ref),
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'aiWorkout',
            onPressed: homeAsync.isLoading ? null : () => ref.read(homeControllerProvider.notifier).suggestWorkout(),
            icon: const Icon(Icons.auto_fix_high),
            label: const Text('AI Workout'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'regenerate',
            onPressed: homeAsync.isLoading ? null : () => ref.read(homeControllerProvider.notifier).regenerateSchedule(),
            icon: const Icon(Icons.calendar_today),
            label: const Text('Regenerate week'),
          ),
        ],
      ),
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
      return const Center(child: Text('No workout available yet. Generate your first schedule!'));
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          workout.focus,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        if (playlist != null)
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
                  onPressed: () => ref.read(homeControllerProvider.notifier).refreshPlaylist(),
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
