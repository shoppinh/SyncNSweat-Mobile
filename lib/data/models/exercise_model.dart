import 'package:equatable/equatable.dart';

class ExerciseModel extends Equatable {
  const ExerciseModel({
    required this.id,
    required this.name,
    this.bodyPart,
    this.target,
    this.equipment,
    this.gifUrl,
  });

  final int id;
  final String name;
  final String? bodyPart;
  final String? target;
  final String? equipment;
  final String? gifUrl;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      bodyPart: json['body_part'] as String?,
      target: json['target'] as String?,
      equipment: json['equipment'] as String?,
      gifUrl: json['gif_url'] as String? ?? json['gifUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, bodyPart, target, equipment, gifUrl];
}
