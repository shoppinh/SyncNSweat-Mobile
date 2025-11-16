import 'package:equatable/equatable.dart';

class PlaylistRecommendation extends Equatable {
  const PlaylistRecommendation({
    required this.id,
    required this.name,
    this.description,
    this.externalUrl,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String? description;
  final String? externalUrl;
  final String? imageUrl;

  factory PlaylistRecommendation.fromJson(Map<String, dynamic> json) {
    return PlaylistRecommendation(
      id: json['playlist_id'] as String? ?? json['id'] as String? ?? '',
      name: json['playlist_name'] as String? ?? json['name'] as String? ?? 'Playlist',
      description: json['description'] as String?,
      externalUrl: json['external_url'] as String? ?? json['playlist_url'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, description, externalUrl, imageUrl];
}
