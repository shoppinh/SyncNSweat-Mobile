import 'package:equatable/equatable.dart';

class PreferencesModel extends Equatable {
  const PreferencesModel({
    required this.id,
    required this.profileId,
    this.availableEquipment = const [],
    this.targetMuscleGroups = const [],
    this.musicGenres = const [],
    this.musicTempo,
    this.spotifyConnected = false,
  });

  final int id;
  final int profileId;
  final List<String> availableEquipment;
  final List<String> targetMuscleGroups;
  final List<String> musicGenres;
  final String? musicTempo;
  final bool spotifyConnected;

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      id: json['id'] as int,
      profileId: json['profile_id'] as int,
      availableEquipment: (json['available_equipment'] as List?)?.cast<String>() ?? const [],
      targetMuscleGroups: (json['target_muscle_groups'] as List?)?.cast<String>() ?? const [],
      musicGenres: (json['music_genres'] as List?)?.cast<String>() ?? const [],
      musicTempo: json['music_tempo'] as String?,
      spotifyConnected: json['spotify_connected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'available_equipment': availableEquipment,
      'target_muscle_groups': targetMuscleGroups,
      'music_genres': musicGenres,
      'music_tempo': musicTempo,
      'spotify_connected': spotifyConnected,
    };
  }

  @override
  List<Object?> get props => [id, profileId, availableEquipment, targetMuscleGroups, musicGenres, musicTempo, spotifyConnected];
}
