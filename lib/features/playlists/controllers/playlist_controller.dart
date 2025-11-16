import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/playlist_model.dart';
import '../../../data/repositories/playlist_repository.dart';

final playlistControllerProvider = AsyncNotifierProvider<PlaylistController, List<PlaylistRecommendation>>(
  PlaylistController.new,
);

class PlaylistController extends AsyncNotifier<List<PlaylistRecommendation>> {
  late final PlaylistRepository _playlistRepository;

  @override
  Future<List<PlaylistRecommendation>> build() async {
    _playlistRepository = ref.read(playlistRepositoryProvider);
    return _playlistRepository.fetchUserPlaylists();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _playlistRepository.fetchUserPlaylists());
  }
}
