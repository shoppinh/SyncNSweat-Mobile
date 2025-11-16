import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/workout_model.dart';
import '../../../data/repositories/workout_repository.dart';

final workoutDetailControllerProvider = AutoDisposeAsyncNotifierProviderFamily<WorkoutDetailController, WorkoutModel, int>(
  WorkoutDetailController.new,
);

class WorkoutDetailController extends AutoDisposeFamilyAsyncNotifier<WorkoutModel, int> {
  late final WorkoutRepository _workoutRepository;

  @override
  Future<WorkoutModel> build(int workoutId) async {
    _workoutRepository = ref.read(workoutRepositoryProvider);
    return _workoutRepository.fetchById(workoutId);
  }

  Future<void> refresh() async {
    final workoutId = arg;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _workoutRepository.fetchById(workoutId));
  }

  Future<void> swapExercise(int exerciseId) async {
    final workout = state.value;
    if (workout == null) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedExercise = await _workoutRepository.swapExercise(
        workoutId: workout.id,
        exerciseId: exerciseId,
      );

      final updatedExercises = workout.exercises
          .map((e) => e.id == updatedExercise.id ? updatedExercise : e)
          .toList();
      return workout.copyWith(exercises: updatedExercises);
    });
  }
}
