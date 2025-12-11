import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/data/models/weekly_schedule_model.dart';
import 'package:syncnsweat_mobile/data/repositories/schedule_repository.dart';
import 'package:syncnsweat_mobile/features/settings/controllers/profile_controller.dart';

class ScheduleController
    extends StateNotifier<AsyncValue<WeeklyScheduleModel?>> {
  ScheduleController(this._repository, this._ref)
      : super(const AsyncValue.loading()) {
    generateSchedule();
  }

  final ScheduleRepository _repository;
  final Ref _ref;

  Future<void> generateSchedule() async {
    state = const AsyncValue.loading();
    try {
      final profileState = _ref.read(profileControllerProvider);
      if (profileState.hasValue && profileState.value != null) {
        final schedule =
            await _repository.generateWeeklySchedule(profileState.value!);
        state = AsyncValue.data(schedule);
      } else {
        // Wait for profile to load or handle error
        // For now, if profile is not loaded, we can't generate.
        // We could listen to profile changes, but for simplicity let's assume it's loaded or we retry.
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final scheduleControllerProvider =
    StateNotifierProvider<ScheduleController, AsyncValue<WeeklyScheduleModel?>>(
        (ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleController(repository, ref);
});
