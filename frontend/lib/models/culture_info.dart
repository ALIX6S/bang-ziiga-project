class CultureInfo {
  final String id;
  final String type; // tradition, gastronomie, événement
  final String title;
  final String content;
  final String imageUrl;
  final DateTime? createdAt;

  CultureInfo({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.imageUrl,
    this.createdAt,
  });

  /// Conversion depuis JSON
  factory CultureInfo.fromJson(Map<String, dynamic> json) {
    return CultureInfo(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
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
      'type': type,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Couleur selon le type
  String getTypeColor() {
    switch (type.toLowerCase()) {
      case 'tradition':
        return '#8EA58C'; // sage
      case 'gastronomie':
        return '#738A6E'; // moss
      case 'événement':
      case 'evenement':
        return '#344C3D'; // evergreen
      default:
        return '#BFCFBB'; // mint
    }
  }

  /// Icône selon le type
  String getTypeIcon() {
    switch (type.toLowerCase()) {
      case 'tradition':
        return '🎭';
      case 'gastronomie':
        return '🍽️';
      case 'événement':
      case 'evenement':
        return '🎉';
      default:
        return '📚';
    }
  }

  /// Label formaté du type
  String getTypeLabel() {
    switch (type.toLowerCase()) {
      case 'tradition':
        return 'Tradition';
      case 'gastronomie':
        return 'Gastronomie';
      case 'événement':
      case 'evenement':
        return 'Événement';
      default:
        return type;
    }
  }
}