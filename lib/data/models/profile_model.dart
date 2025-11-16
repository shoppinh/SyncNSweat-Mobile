import 'package:equatable/equatable.dart';

enum FitnessGoal { strength, endurance, weightLoss, recomposition, general }
enum FitnessLevel { beginner, intermediate, advanced }

FitnessGoal fitnessGoalFromString(String? raw) {
  switch (raw) {
    case 'strength':
      return FitnessGoal.strength;
    case 'endurance':
      return FitnessGoal.endurance;
    case 'weight_loss':
      return FitnessGoal.weightLoss;
    case 'recomposition':
      return FitnessGoal.recomposition;
    default:
      return FitnessGoal.general;
  }
}

String fitnessGoalToString(FitnessGoal goal) {
  switch (goal) {
    case FitnessGoal.strength:
      return 'strength';
    case FitnessGoal.endurance:
      return 'endurance';
    case FitnessGoal.weightLoss:
      return 'weight_loss';
    case FitnessGoal.recomposition:
      return 'recomposition';
    case FitnessGoal.general:
      return 'general';
  }
}

FitnessLevel fitnessLevelFromString(String? raw) {
  switch (raw) {
    case 'beginner':
      return FitnessLevel.beginner;
    case 'advanced':
      return FitnessLevel.advanced;
    default:
      return FitnessLevel.intermediate;
  }
}

String fitnessLevelToString(FitnessLevel level) {
  switch (level) {
    case FitnessLevel.beginner:
      return 'beginner';
    case FitnessLevel.intermediate:
      return 'intermediate';
    case FitnessLevel.advanced:
      return 'advanced';
  }
}

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.fitnessGoal,
    required this.fitnessLevel,
    required this.availableDays,
    required this.workoutDurationMinutes,
  });

  final int id;
  final int userId;
  final String name;
  final FitnessGoal fitnessGoal;
  final FitnessLevel fitnessLevel;
  final List<String> availableDays;
  final int workoutDurationMinutes;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String? ?? '',
      fitnessGoal: fitnessGoalFromString(json['fitness_goal'] as String?),
      fitnessLevel: fitnessLevelFromString(json['fitness_level'] as String?),
      availableDays: (json['available_days'] as List?)?.cast<String>() ?? const [],
      workoutDurationMinutes: json['workout_duration_minutes'] as int? ?? 45,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'fitness_goal': fitnessGoalToString(fitnessGoal),
      'fitness_level': fitnessLevelToString(fitnessLevel),
      'available_days': availableDays,
      'workout_duration_minutes': workoutDurationMinutes,
    };
  }

  @override
  List<Object?> get props => [id, userId, name, fitnessGoal, fitnessLevel, availableDays, workoutDurationMinutes];
}
