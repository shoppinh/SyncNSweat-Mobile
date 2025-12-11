import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/playlist_model.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/repositories/playlist_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../data/repositories/profile_repository.dart';

class HomeState {
  const HomeState({
    this.todayWorkout,
    this.playlist,
    this.streak = 0,
  });

  final WorkoutModel? todayWorkout;
  final PlaylistRecommendation? playlist;
  final int streak;

  HomeState copyWith({
    WorkoutModel? todayWorkout,
    PlaylistRecommendation? playlist,
    int? streak,
  }) {
    return HomeState(
      todayWorkout: todayWorkout ?? this.todayWorkout,
      playlist: playlist ?? this.playlist,
      streak: streak ?? this.streak,
    );
  }
}

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, HomeState>(HomeController.new);

class HomeController extends AsyncNotifier<HomeState> {
  late final WorkoutRepository _workoutRepository;
  late final PlaylistRepository _playlistRepository;
  late final ProfileRepository _profileRepository;

  @override
  Future<HomeState> build() async {
    _workoutRepository = ref.read(workoutRepositoryProvider);
    _playlistRepository = ref.read(playlistRepositoryProvider);
    _profileRepository = ref.read(profileRepositoryProvider);
    return _loadHome();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadHome);
  }

  Future<void> regenerateSchedule() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _workoutRepository.generateSchedule(regenerate: true);
      return _loadHome();
    });
  }

  Future<void> suggestWorkout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _workoutRepository.suggestAiWorkout();
      return _loadHome();
    });
  }

  Future<void> refreshPlaylist() async {
    final currentState = state.value;
    if (currentState == null || currentState.todayWorkout == null) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final playlist = await _playlistRepository
          .refreshPlaylistForWorkout(currentState.todayWorkout!.id);
      return currentState.copyWith(playlist: playlist);
    });
  }

  Future<HomeState> _loadHome() async {
    try {
      final todayWorkout = await _workoutRepository.fetchToday();
      final profile = await _profileRepository.fetchProfile();

      return HomeState(
        todayWorkout: todayWorkout,
        playlist: PlaylistRecommendation(
          id: todayWorkout.playlistId ?? '',
          name: todayWorkout.playlistName ?? 'Workout Playlist',
          externalUrl: todayWorkout.playlistUrl ?? '',
        ),
        streak: profile?.streak ?? 0,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const HomeState();
      }
      rethrow;
    }
  }
}
