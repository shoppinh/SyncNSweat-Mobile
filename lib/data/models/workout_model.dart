import 'package:equatable/equatable.dart';
import 'package:syncnsweat_mobile/data/models/exercise_model.dart';

class WorkoutModel extends Equatable {
  const WorkoutModel({
    required this.id,
    required this.userId,
    required this.focus,
    required this.date,
    required this.durationMinutes,
    this.playlistName,
    this.playlistUrl,
    this.playlistId,
    this.exercises = const [],
  });

  final int id;
  final int userId;
  final DateTime date;
  final String focus;
  final int durationMinutes;
  final String? playlistName;
  final String? playlistUrl;
  final String? playlistId;
  final List<WorkoutExerciseModel> exercises;

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      focus: json['focus'] as String? ?? 'Full Body',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      durationMinutes: json['duration_minutes'] as int? ?? 45,
      playlistName: json['playlist_name'] as String?,
      playlistUrl: json['playlist_url'] as String?,
      playlistId: json['playlist_id'] as String?,
      exercises: (json['workout_exercises'] as List?)
              ?.map(
                (e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }

  WorkoutModel copyWith({
    int? id,
    int? userId,
    String? focus,
    DateTime? date,
    int? durationMinutes,
    String? playlistName,
    String? playlistUrl,
    String? playlistId,
    List<WorkoutExerciseModel>? exercises,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      focus: focus ?? this.focus,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      playlistName: playlistName ?? this.playlistName,
      playlistUrl: playlistUrl ?? this.playlistUrl,
      playlistId: playlistId ?? this.playlistId,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        focus,
        date,
        durationMinutes,
        playlistName,
        playlistUrl,
        exercises,
      ];
}

class WorkoutExerciseModel extends Equatable {
  const WorkoutExerciseModel(
      {required this.id,
      this.sets,
      this.reps,
      this.order,
      this.restSeconds,
      this.completedSets,
      this.weightsUsed,
      this.exercise,});

  final int id;
  final int? sets;
  final String? reps;
  final int? order;
  final int? restSeconds;
  final int? completedSets;
  final List<String>? weightsUsed;
  final ExerciseModel? exercise;

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      id: json['id'] as int? ?? json['exercise_id'] as int? ?? 0,
      sets: json['sets'] as int?,
      reps: json['reps']?.toString(),
      order: json['order'] as int?,
      restSeconds: json['rest_seconds'] as int?,
      completedSets: json['completed_sets'] as int?,
      weightsUsed: (json['weights_used'] is List &&
              (json['weights_used'] as List).isNotEmpty)
          ? (json['weights_used'] as List).map((e) => e.toString()).toList()
          : null,
      exercise: json['exercise'] != null
          ? ExerciseModel.fromJson(json['exercise'] as Map<String, dynamic>)
          : null,
    );
  }

  WorkoutExerciseModel copyWith({
    int? id,
    int? sets,
    String? reps,
    int? order,
    int? restSeconds,
    int? completedSets,
    List<String>? weightsUsed,
    ExerciseModel? exercise,
  }) {
    return WorkoutExerciseModel(
      id: id ?? this.id,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      order: order ?? this.order,
      restSeconds: restSeconds ?? this.restSeconds,
      completedSets: completedSets ?? this.completedSets,
      weightsUsed: weightsUsed ?? this.weightsUsed,
      exercise: exercise ?? this.exercise,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sets,
        reps,
        order,
        restSeconds,
        completedSets,
        weightsUsed,
        exercise
      ];
}
