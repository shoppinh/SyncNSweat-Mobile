import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/preferences_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class OnboardingState {
  const OnboardingState({
    this.profile,
    this.preferences,
  });

  final ProfileModel? profile;
  final PreferencesModel? preferences;

  OnboardingState copyWith({
    ProfileModel? profile,
    PreferencesModel? preferences,
  }) {
    return OnboardingState(
      profile: profile ?? this.profile,
      preferences: preferences ?? this.preferences,
    );
  }
}

final onboardingControllerProvider = AsyncNotifierProvider<OnboardingController, OnboardingState>(OnboardingController.new);

class OnboardingController extends AsyncNotifier<OnboardingState> {
  late final ProfileRepository _profileRepository;

  @override
  Future<OnboardingState> build() async {
    _profileRepository = ref.read(profileRepositoryProvider);
    final profile = await _profileRepository.fetchProfile();
    final preferences = profile != null ? await _profileRepository.fetchPreferences() : null;
    return OnboardingState(profile: profile, preferences: preferences);
  }

  Future<void> saveProfile({
    required String name,
    required FitnessGoal goal,
    required FitnessLevel level,
    required List<String> days,
    required int durationMinutes,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final profile = await _profileRepository.saveProfile(
        name: name,
        fitnessGoal: goal,
        fitnessLevel: level,
        availableDays: days,
        workoutDurationMinutes: durationMinutes,
      );
      final preferences = await _profileRepository.fetchPreferences();
      return OnboardingState(profile: profile, preferences: preferences);
    });
  }

  Future<void> savePreferences({
    required List<String> equipment,
    required List<String> targets,
    required List<String> genres,
    String? tempo,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await _profileRepository.savePreferences(
        availableEquipment: equipment,
        targetMuscleGroups: targets,
        musicGenres: genres,
        musicTempo: tempo,
      );
      final profile = await _profileRepository.fetchProfile();
      await ref.read(authControllerProvider.notifier).refreshSession();
      return OnboardingState(profile: profile, preferences: prefs);
    });
  }
}
