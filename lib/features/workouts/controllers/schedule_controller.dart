import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/data/models/weekly_schedule_model.dart';
import 'package:syncnsweat_mobile/data/repositories/schedule_repository.dart';
import 'package:syncnsweat_mobile/features/settings/controllers/profile_controller.dart';

class ScheduleState {
  const ScheduleState({
    this.weeklySchedule,
  });

  final WeeklyScheduleModel? weeklySchedule;

  ScheduleState copyWith({
    WeeklyScheduleModel? weeklySchedule,
  }) {
    return ScheduleState(
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
    );
  }
}
 
class ScheduleController
    extends AsyncNotifier<ScheduleState> {


  late final ScheduleRepository _repository;

  @override
  Future<ScheduleState> build() async {
    _repository = ref.read(scheduleRepositoryProvider);
    return _loadSchedule();
  }

  Future<void> generateSchedule() async {
    state = const AsyncValue.loading();
    try {
      final profileState = ref.read(profileControllerProvider);
      if (profileState.hasValue && profileState.value != null) {
        final schedule =
            await _repository.generateWeeklySchedule(state.value != null);
        state = AsyncValue.data(
            state.value!.copyWith(weeklySchedule: schedule));
      } else {
        // Wait for profile to load or handle error
        // For now, if profile is not loaded, we can't generate.
        // We could listen to profile changes, but for simplicity let's assume it's loaded or we retry.
        state = const AsyncValue.data(ScheduleState());
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadSchedule);
  }

  Future<ScheduleState> _loadSchedule() async {
    try {
      final weekly = await _repository.generateWeeklySchedule(false);
      return ScheduleState(weeklySchedule: weekly);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const ScheduleState();
      }
      rethrow;
    }
  }

}

final scheduleControllerProvider =
    AsyncNotifierProvider<ScheduleController, ScheduleState>(ScheduleController.new);
