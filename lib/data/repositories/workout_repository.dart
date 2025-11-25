import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/workout_model.dart';

class WorkoutRepository {
  WorkoutRepository(this._dio);

  final Dio _dio;

  Future<List<WorkoutModel>> fetchWorkouts({
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/workouts/',
        queryParameters: {
          if (start != null) 'start_date': start.toIso8601String(),
          if (end != null) 'end_date': end.toIso8601String(),
          'skip': 0,
          'limit': 10,
        },
      );

      return response.data!
          .map((json) => WorkoutModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    }
  }

  Future<WorkoutModel> fetchToday() async {
    final response = await _dio.get<Map<String, dynamic>>('/workouts/today');
    return WorkoutModel.fromJson(response.data!);
  }

  Future<WorkoutModel> fetchById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/workouts/$id');
    return WorkoutModel.fromJson(response.data!);
  }

  Future<List<WorkoutModel>> generateSchedule({bool regenerate = false}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/workouts/schedule',
      data: {'regenerate': regenerate},
    );

    final workouts = response.data?['workouts'] as List<dynamic>? ?? [];
    return workouts
        .map((json) => WorkoutModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<WorkoutModel> suggestAiWorkout() async {
    final response = await _dio
        .post<Map<String, dynamic>>('/workouts/suggest-workout-schedule');
    return WorkoutModel.fromJson(response.data!);
  }

  Future<WorkoutExerciseModel> swapExercise({
    required int workoutId,
    required int exerciseId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/workouts/$workoutId/exercises/$exerciseId/swap',
    );

    return WorkoutExerciseModel.fromJson(response.data!);
  }
}

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return WorkoutRepository(dio);
});
