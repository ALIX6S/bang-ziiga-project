import 'site.dart';

class Itineraire {
  final String id;
  final String name;
  final String description;
  final String duration; // Ex: "2h30", "1 journée"
  final String difficulty; // facile, moyen, intense
  final String? distance; // Ex: "5 km"
  final List<Site> sites; // Sites inclus dans l'itinéraire
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

  /// Conversion depuis JSON
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

  /// Conversion vers JSON
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

  /// Nombre de sites dans l'itinéraire
  int get sitesCount => sites.length;

  /// Couleur selon la difficulté
  String getDifficultyColor() {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return '#8EA58C'; // sage - vert clair
      case 'moyen':
        return '#738A6E'; // moss - vert moyen
      case 'intense':
        return '#344C3D'; // evergreen - vert foncé
      default:
        return '#738A6E'; // moss par défaut
    }
  }

  /// Icône selon la difficulté
  String getDifficultyIcon() {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return '😊'; // ou utiliser Icons.sentiment_satisfied
      case 'moyen':
        return '💪'; // ou utiliser Icons.fitness_center
      case 'intense':
        return '🔥'; // ou utiliser Icons.local_fire_department
      default:
        return '📍';
    }
  }
}