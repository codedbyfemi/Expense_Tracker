class Category {
  final int? id;
  final String name;
  final String icon;
  final String color;

  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  // Create from Map (database)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'] ?? '',
      icon: map['icon'] ?? '📝',
      color: map['color'] ?? '#2196F3',
    );
  }

  // Copy with changes
  Category copyWith({
    int? id,
    String? name,
    String? icon,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, icon: $icon)';
  }
}