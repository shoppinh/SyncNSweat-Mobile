import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/data/models/profile_model.dart';
import 'package:syncnsweat_mobile/data/models/weekly_schedule_model.dart';

class ScheduleRepository {
  Future<WeeklyScheduleModel> generateWeeklySchedule(
      ProfileModel profile) async {
    // Mock logic to generate schedule based on profile
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final workouts = <DailyWorkoutModel>[];

    for (final day in days) {
      if (profile.availableDays.contains(day)) {
        String focus = 'General Fitness';
        String? playlistName;

        switch (profile.fitnessGoal) {
          case FitnessGoal.strength:
            focus = 'Strength Training';
            playlistName = 'Power Workout';
            break;
          case FitnessGoal.endurance:
            focus = 'Cardio & Endurance';
            playlistName = 'Running Hits';
            break;
          case FitnessGoal.weightLoss:
            focus = 'HIIT & Cardio';
            playlistName = 'High Energy';
            break;
          case FitnessGoal.recomposition:
            focus = 'Strength & Cardio';
            playlistName = 'Mix Tape';
            break;
          case FitnessGoal.general:
            focus = 'Full Body';
            playlistName = 'Feel Good';
            break;
        }

        workouts.add(DailyWorkoutModel(
          dayOfWeek: day,
          focus: focus,
          playlistName: playlistName,
          playlistUrl: 'https://open.spotify.com/playlist/mock',
          isRestDay: false,
        ));
      } else {
        workouts.add(DailyWorkoutModel(
          dayOfWeek: day,
          focus: 'Rest & Recovery',
          isRestDay: true,
        ));
      }
    }

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
  return ScheduleRepository();
});
