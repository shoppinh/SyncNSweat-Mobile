import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/playlist_model.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/repositories/playlist_repository.dart';
import '../../../data/repositories/workout_repository.dart';

class HomeState {
  const HomeState({
    this.todayWorkout,
    this.playlist,
  });

  final WorkoutModel? todayWorkout;
  final PlaylistRecommendation? playlist;

  HomeState copyWith({
    WorkoutModel? todayWorkout,
    PlaylistRecommendation? playlist,
  }) {
    return HomeState(
      todayWorkout: todayWorkout ?? this.todayWorkout,
      playlist: playlist ?? this.playlist,
    );
  }
}

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeState>(HomeController.new);

class HomeController extends AsyncNotifier<HomeState> {
  late final WorkoutRepository _workoutRepository;
  late final PlaylistRepository _playlistRepository;

  @override
  Future<HomeState> build() async {
    _workoutRepository = ref.read(workoutRepositoryProvider);
    _playlistRepository = ref.read(playlistRepositoryProvider);
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
      final playlist = await _playlistRepository.refreshPlaylistForWorkout(currentState.todayWorkout!.id);
      return currentState.copyWith(playlist: playlist);
    });
  }

  Future<HomeState> _loadHome() async {
    try {
      final todayWorkout = await _workoutRepository.fetchToday();
      final playlist = await _playlistRepository.getPlaylistForWorkout(todayWorkout.id);
      return HomeState(todayWorkout: todayWorkout, playlist: playlist);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const HomeState();
      }
      rethrow;
    }
  }
}
