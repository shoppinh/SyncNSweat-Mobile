import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/workout_model.dart';
import '../../../data/repositories/workout_repository.dart';

final historyControllerProvider = AsyncNotifierProvider<HistoryController, List<WorkoutModel>>(
  HistoryController.new,
);

class HistoryController extends AsyncNotifier<List<WorkoutModel>> {
  late final WorkoutRepository _workoutRepository;

  @override
  Future<List<WorkoutModel>> build() async {
    _workoutRepository = ref.read(workoutRepositoryProvider);
    return _workoutRepository.fetchWorkouts();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _workoutRepository.fetchWorkouts());
  }
}
