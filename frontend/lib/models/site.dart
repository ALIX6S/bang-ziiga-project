class Site {
  final String id;
  final String name;
  final String description;
  final String category;
  final String location;
  final String imageUrl;
  final bool isFeatured;
  final DateTime? createdAt;

  Site({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.location,
    required this.imageUrl,
    this.isFeatured = false,
    this.createdAt,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
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
      'category': category,
      'location': location,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Site copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? location,
    String? imageUrl,
    bool? isFeatured,
    DateTime? createdAt,
  }) {
    return Site(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'monument':
        return '#8EA58C'; // sage
      case 'musée':
      case 'musee':
        return '#738A6E'; // moss
      case 'parc':
        return '#344C3D'; // evergreen
      case 'plage':
        return '#BFCFBB'; // mint
      default:
        return '#8EA58C'; // sage par défaut
    }
  }
}