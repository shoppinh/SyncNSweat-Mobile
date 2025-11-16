import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/playlist_controller.dart';
import '../../../features/home/widgets/workout_card.dart';

class PlaylistPreviewSheet extends ConsumerWidget {
  const PlaylistPreviewSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistAsync = ref.watch(playlistControllerProvider);

    return playlistAsync.when(
      data: (playlists) => ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return ListTile(
            leading: const Icon(Icons.queue_music),
            title: Text(playlist.name),
            subtitle: Text(playlist.description ?? 'View on Spotify'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => WorkoutCard.launchExternal(playlist.externalUrl),
          );
        },
      ),
      error: (error, _) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
