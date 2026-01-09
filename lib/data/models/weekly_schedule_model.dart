import 'package:equatable/equatable.dart';

class WeeklyScheduleModel extends Equatable {
  const WeeklyScheduleModel({
    required this.weekStartDate,
    required this.dailyWorkouts,
  });

  final DateTime weekStartDate;
  final List<DailyWorkoutModel> dailyWorkouts;

  factory WeeklyScheduleModel.fromJson(Map<String, dynamic> json) {
    return WeeklyScheduleModel(
      weekStartDate: DateTime.parse(json['week_start_date'] as String),
      dailyWorkouts: (json['daily_workouts'] as List)
          .map((e) => DailyWorkoutModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week_start_date': weekStartDate.toIso8601String(),
      'daily_workouts': dailyWorkouts.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [weekStartDate, dailyWorkouts];
}

class DailyWorkoutModel extends Equatable {
  const DailyWorkoutModel({
    required this.dayOfWeek,
    required this.focus,
    this.playlistName,
    this.playlistUrl,
  });

  final String dayOfWeek;
  final String focus;
  final String? playlistName;
  final String? playlistUrl;

  factory DailyWorkoutModel.fromJson(Map<String, dynamic> json) {
    return DailyWorkoutModel(
      dayOfWeek: json['date'] as String,
      focus: json['focus'] as String,
      playlistName: json['playlist_name'] as String?,
      playlistUrl: json['playlist_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'focus': focus,
      'playlist_name': playlistName,
      'playlist_url': playlistUrl,
    };
  }

  @override
  List<Object?> get props =>
      [dayOfWeek, focus, playlistName, playlistUrl];
}
