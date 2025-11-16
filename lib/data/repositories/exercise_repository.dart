import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/exercise_model.dart';

class ExerciseRepository {
  ExerciseRepository(this._dio);

  final Dio _dio;

  Future<List<ExerciseModel>> search({
    String? name,
    String? bodyPart,
    String? target,
    String? equipment,
  }) async {
    final response = await _dio.post<List<dynamic>>(
      '/exercises/search',
      data: {
        'name': name,
        'body_part': bodyPart,
        'target': target,
        'equipment': equipment,
      },
    );

    return response.data!
        .map((item) => ExerciseModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ExerciseRepository(dio);
});
