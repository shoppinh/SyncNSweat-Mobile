import 'package:equatable/equatable.dart';

class WorkoutModel extends Equatable {
  const WorkoutModel({
    required this.id,
    required this.userId,
    required this.focus,
    required this.date,
    required this.durationMinutes,
    this.playlistName,
    this.playlistUrl,
    this.exercises = const [],
  });

  final int id;
  final int userId;
  final DateTime date;
  final String focus;
  final int durationMinutes;
  final String? playlistName;
  final String? playlistUrl;
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
      exercises: ((json['workout_exercises'] ?? json['exercises']) as List?)
              ?.map((e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>))
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
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [id, userId, focus, date, durationMinutes, playlistName, playlistUrl, exercises];
}

class WorkoutExerciseModel extends Equatable {
  const WorkoutExerciseModel({
    required this.id,
    required this.exerciseId,
    required this.name,
    this.description,
    this.sets,
    this.reps,
    this.order,
    this.restSeconds,
    this.muscleGroup,
    this.equipment,
  });

  final int id;
  final int exerciseId;
  final String name;
  final String? description;
  final int? sets;
  final String? reps;
  final int? order;
  final int? restSeconds;
  final String? muscleGroup;
  final String? equipment;

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      id: json['id'] as int? ?? json['exercise_id'] as int? ?? 0,
      exerciseId: json['exercise_id'] as int? ?? json['id'] as int? ?? 0,
      name: json['name'] as String? ?? json['exercise'] as String? ?? 'Exercise',
      description: json['description'] as String?,
      sets: json['sets'] as int?,
      reps: json['reps']?.toString(),
      order: json['order'] as int?,
      restSeconds: json['rest_seconds'] as int?,
      muscleGroup: json['muscle_group'] as String?,
      equipment: json['equipment'] as String?,
    );
  }

  WorkoutExerciseModel copyWith({
    int? id,
    int? exerciseId,
    String? name,
    String? description,
    int? sets,
    String? reps,
    int? order,
    int? restSeconds,
    String? muscleGroup,
    String? equipment,
  }) {
    return WorkoutExerciseModel(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      description: description ?? this.description,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      order: order ?? this.order,
      restSeconds: restSeconds ?? this.restSeconds,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
    );
  }

  @override
  List<Object?> get props => [id, exerciseId, name, sets, reps, order, restSeconds, muscleGroup, equipment];
}
