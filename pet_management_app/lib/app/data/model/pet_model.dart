class PetModel {
  final int? id;
  final int userId;
  final String name;
  final String species;
  final String breed;
  final DateTime birthday;
  final String? imageUrl;
  final String? notes;
  final DateTime createdAt;

  PetModel({
    this.id,
    required this.userId,
    required this.name,
    required this.species,
    required this.breed,
    required this.birthday,
    this.imageUrl,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'species': species,
      'breed': breed,
      'birthday': birthday.toIso8601String(),
      'image_url': imageUrl,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      species: map['species'],
      breed: map['breed'],
      birthday: DateTime.parse(map['birthday']),
      imageUrl: map['image_url'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  int get age {
    final today = DateTime.now();
    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }
}
