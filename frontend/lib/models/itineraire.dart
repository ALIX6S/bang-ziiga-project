import 'site.dart';

class Itineraire {
  final String id;
  final String name;
  final String description;
  final String duration; // Ex: "2h30", "1 journée"
  final String difficulty; // facile, moyen, intense
  final String? distance; // Ex: "5 km"
  final List<Site> sites;
  final String imageUrl;
  final DateTime? createdAt;

  Itineraire({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    this.distance,
    required this.sites,
    required this.imageUrl,
    this.createdAt,
  });

  factory Itineraire.fromJson(Map<String, dynamic> json) {
    List<Site> sitesList = [];
    if (json['sites'] != null) {
      sitesList = (json['sites'] as List)
          .map((siteJson) => Site.fromJson(siteJson))
          .toList();
    }

    return Itineraire(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      difficulty: json['difficulty'] ?? 'moyen',
      distance: json['distance'],
      sites: sitesList,
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'distance': distance,
      'sites': sites.map((site) => site.toJson()).toList(),
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  int get sitesCount => sites.length;
}