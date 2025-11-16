import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/playlist_model.dart';

class PlaylistRepository {
  PlaylistRepository(this._dio);

  final Dio _dio;

  Future<PlaylistRecommendation> fetchRecommendation() async {
    final response = await _dio.get<Map<String, dynamic>>('/playlists/spotify/recommendations');
    return PlaylistRecommendation.fromJson(response.data ?? const {});
  }

  Future<List<PlaylistRecommendation>> fetchUserPlaylists() async {
    final response = await _dio.get<Map<String, dynamic>>('/playlists/spotify/playlists');
    final items = response.data?['playlists'] as List<dynamic>? ?? [];
    return items
        .map((json) => PlaylistRecommendation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<PlaylistRecommendation> getPlaylistForWorkout(int workoutId) async {
    final response = await _dio.get<Map<String, dynamic>>('/playlists/workout/$workoutId');
    return PlaylistRecommendation.fromJson(response.data ?? const {});
  }

  Future<PlaylistRecommendation> refreshPlaylistForWorkout(int workoutId) async {
    final response = await _dio.get<Map<String, dynamic>>('/playlists/workout/$workoutId/refresh');
    return PlaylistRecommendation.fromJson(response.data ?? const {});
  }
}

final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PlaylistRepository(dio);
});
