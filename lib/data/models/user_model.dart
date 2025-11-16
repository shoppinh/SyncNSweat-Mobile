import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    this.spotifyConnected = false,
  });

  final int id;
  final String email;
  final bool spotifyConnected;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      spotifyConnected: json['spotify_connected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'spotify_connected': spotifyConnected,
    };
  }

  @override
  List<Object?> get props => [id, email, spotifyConnected];
}
