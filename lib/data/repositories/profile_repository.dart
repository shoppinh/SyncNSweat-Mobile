import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/preferences_model.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  ProfileRepository(this._dio);

  final Dio _dio;

  Future<ProfileModel?> fetchProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/profiles/me');
      return ProfileModel.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<ProfileModel> saveProfile({
    required String name,
    required FitnessGoal fitnessGoal,
    required FitnessLevel fitnessLevel,
    required List<String> availableDays,
    required int workoutDurationMinutes,
  }) async {
    final payload = {
      'name': name,
      'fitness_goal': fitnessGoalToString(fitnessGoal),
      'fitness_level': fitnessLevelToString(fitnessLevel),
      'available_days': availableDays,
      'workout_duration_minutes': workoutDurationMinutes,
    };

    try {
      final response = await _dio.put<Map<String, dynamic>>('/profiles/me', data: payload);
      return ProfileModel.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        final createResp = await _dio.post<Map<String, dynamic>>('/profiles/', data: payload);
        return ProfileModel.fromJson(createResp.data!);
      }
      rethrow;
    }
  }

  Future<PreferencesModel?> fetchPreferences() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/profiles/me/preferences');
      return PreferencesModel.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<PreferencesModel> savePreferences({
    required List<String> availableEquipment,
    required List<String> targetMuscleGroups,
    required List<String> musicGenres,
    String? musicTempo,
  }) async {
    final payload = {
      'available_equipment': availableEquipment,
      'target_muscle_groups': targetMuscleGroups,
      'music_genres': musicGenres,
      'music_tempo': musicTempo,
    };

    try {
      final response = await _dio.put<Map<String, dynamic>>('/profiles/me/preferences', data: payload);
      return PreferencesModel.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        final createResp = await _dio.post<Map<String, dynamic>>('/profiles/me/preferences', data: payload);
        return PreferencesModel.fromJson(createResp.data!);
      }
      rethrow;
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRepository(dio);
});
