class PetModel {
  final int? id;
  final String name;
  final String? imageUrl;
  final String? breed;
  final int? age;
  final String? type;

  PetModel({
    this.id,
    required this.name,
    this.imageUrl,
    this.breed,
    this.age,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'breed': breed,
      'age': age,
      'type': type,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      breed: map['breed'],
      age: map['age'],
      type: map['type'],
    );
  }
}
