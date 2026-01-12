import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/core/network/api_client.dart';
import 'package:syncnsweat_mobile/data/models/weekly_schedule_model.dart';

class ScheduleRepository {
  ScheduleRepository(this._dio);
  final Dio _dio;
  Future<WeeklyScheduleModel> generateWeeklySchedule(
       bool isRegenerated,) async {
    final workouts = <DailyWorkoutModel>[];

    final response = await _dio.post( '/workouts/schedule', data: {
      'regenerate': isRegenerated,
    },);

    workouts.addAll((response.data['workouts'] as List).map((e) =>
        DailyWorkoutModel.fromJson(e as Map<String, dynamic>),),);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return WeeklyScheduleModel(
      weekStartDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      dailyWorkouts: workouts,
    );
  }

}

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ScheduleRepository(dio);
});
