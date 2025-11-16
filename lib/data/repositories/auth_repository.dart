import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/token_response.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    return UserModel.fromJson(response.data!);
  }

  Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'username': email,
        'password': password,
        'grant_type': 'password',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return TokenResponse.fromJson(response.data!);
  }

  Future<UserModel> me() async {
    final response = await _dio.get<Map<String, dynamic>>('/users/me');
    return UserModel.fromJson(response.data!);
  }

  Future<String> getSpotifyAuthUrl() async {
    final response = await _dio.get<Map<String, dynamic>>('/auth/spotify/login');
    return response.data?['auth_url'] as String? ?? '';
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});
