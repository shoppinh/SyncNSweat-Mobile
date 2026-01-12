import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/data/models/profile_model.dart';
import 'package:syncnsweat_mobile/data/models/preferences_model.dart';
import 'package:syncnsweat_mobile/data/repositories/profile_repository.dart';
import 'package:syncnsweat_mobile/features/auth/controllers/auth_controller.dart';

class ProfileController extends StateNotifier<AsyncValue<ProfileModel?>> {
  ProfileController(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  final ProfileRepository _repository;

  Future<void> loadProfile() async {
    if (mounted) state = const AsyncValue.loading();
    try {
      final profile = await _repository.fetchProfile();
      if (!mounted) return;
      state = AsyncValue.data(profile);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    required String name,
    required FitnessGoal fitnessGoal,
    required FitnessLevel fitnessLevel,
    required List<String> availableDays,
    required int workoutDurationMinutes,
  }) async {
    if (mounted) state = const AsyncValue.loading();
    try {
      final updatedProfile = await _repository.saveProfile(
        name: name,
        fitnessGoal: fitnessGoal,
        fitnessLevel: fitnessLevel,
        availableDays: availableDays,
        workoutDurationMinutes: workoutDurationMinutes,
      );
      if (!mounted) return;
      state = AsyncValue.data(updatedProfile);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }
}

class PreferencesController
    extends StateNotifier<AsyncValue<PreferencesModel?>> {
  PreferencesController(this._repository) : super(const AsyncValue.loading()) {
    loadPreferences();
  }

  final ProfileRepository _repository;

  Future<void> loadPreferences() async {
    if (mounted) state = const AsyncValue.loading();
    try {
      final preferences = await _repository.fetchPreferences();
      if (!mounted) return;
      state = AsyncValue.data(preferences);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePreferences({
    required List<String> availableEquipment,
    required List<String> targetMuscleGroups,
    required List<String> musicGenres,
    String? musicTempo,
  }) async {
    if (mounted) state = const AsyncValue.loading();
    try {
      final updatedPreferences = await _repository.savePreferences(
        availableEquipment: availableEquipment,
        targetMuscleGroups: targetMuscleGroups,
        musicGenres: musicGenres,
        musicTempo: musicTempo,
      );
      if (!mounted) return;
      state = AsyncValue.data(updatedPreferences);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }
}

final profileControllerProvider = StateNotifierProvider.autoDispose<
    ProfileController, AsyncValue<ProfileModel?>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  // Watch current user so controller reloads per-user
  ref.watch(userProvider);
  return ProfileController(repository);
});

final preferencesControllerProvider = StateNotifierProvider.autoDispose<
    PreferencesController, AsyncValue<PreferencesModel?>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  // Watch current user so controller reloads per-user
  ref.watch(userProvider);
  return PreferencesController(repository);
});
