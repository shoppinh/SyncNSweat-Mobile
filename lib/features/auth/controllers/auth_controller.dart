import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/token_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';

class AuthState {
  const AuthState._({
    this.user,
    this.requiresOnboarding = true,
  });

  final UserModel? user;
  final bool requiresOnboarding;

  bool get isAuthenticated => user != null;

  const AuthState.signedOut() : this._(user: null, requiresOnboarding: true);

  AuthState copyWith({
    UserModel? user,
    bool? requiresOnboarding,
  }) {
    return AuthState._(
      user: user ?? this.user,
      requiresOnboarding: requiresOnboarding ?? this.requiresOnboarding,
    );
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends AsyncNotifier<AuthState> {
  late final AuthRepository _authRepository;
  late final ProfileRepository _profileRepository;
  late final TokenStorage _tokenStorage;

  @override
  Future<AuthState> build() async {
    _authRepository = ref.read(authRepositoryProvider);
    _profileRepository = ref.read(profileRepositoryProvider);
    _tokenStorage = ref.read(tokenStorageProvider);

    final token = await _tokenStorage.readToken();
    if (token == null) {
      return const AuthState.signedOut();
    }

    try {
      final authState = await _loadUser();
      return authState;
    } catch (_) {
      await _tokenStorage.clear();
      return const AuthState.signedOut();
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.register(email: email, password: password, name: name);
      final token = await _authenticate(email: email, password: password);
      await _tokenStorage.saveToken(token);
      return _loadUser();
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final token = await _authenticate(email: email, password: password);
      await _tokenStorage.saveToken(token);
      return _loadUser();
    });
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    state = const AsyncValue.data(AuthState.signedOut());
  }

  Future<void> refreshSession() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadUser);
  }

  Future<AuthState> _loadUser() async {
    final user = await _authRepository.me();
    final profile = await _profileRepository.fetchProfile();
    return AuthState._(
      user: user,
      requiresOnboarding: profile == null,
    );
  }

  Future<String> _authenticate({
    required String email,
    required String password,
  }) async {
    final tokenResponse = await _authRepository.login(email: email, password: password);
    return tokenResponse.accessToken;
  }
}
