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
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.fetchProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
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
    state = const AsyncValue.loading();
    try {
      final updatedProfile = await _repository.saveProfile(
        name: name,
        fitnessGoal: fitnessGoal,
        fitnessLevel: fitnessLevel,
        availableDays: availableDays,
        workoutDurationMinutes: workoutDurationMinutes,
      );
      state = AsyncValue.data(updatedProfile);
    } catch (e, st) {
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
    state = const AsyncValue.loading();
    try {
      final preferences = await _repository.fetchPreferences();
      state = AsyncValue.data(preferences);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePreferences({
    required List<String> availableEquipment,
    required List<String> targetMuscleGroups,
    required List<String> musicGenres,
    String? musicTempo,
  }) async {
    state = const AsyncValue.loading();
    try {
      final updatedPreferences = await _repository.savePreferences(
        availableEquipment: availableEquipment,
        targetMuscleGroups: targetMuscleGroups,
        musicGenres: musicGenres,
        musicTempo: musicTempo,
      );
      state = AsyncValue.data(updatedPreferences);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<ProfileModel?>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  // Watch auth state to invalidate when user logs out
  ref.watch(authControllerProvider);
  return ProfileController(repository);
});

final preferencesControllerProvider =
    StateNotifierProvider<PreferencesController, AsyncValue<PreferencesModel?>>(
        (ref) {
  final repository = ref.watch(profileRepositoryProvider);
  // Watch auth state to invalidate when user logs out
  ref.watch(authControllerProvider);
  return PreferencesController(repository);
});
