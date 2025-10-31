class AppointmentModel {
  final int? id;
  final int userId;
  final int petId;
  final String title;
  final String? description;
  final DateTime appointmentDate;
  final String location;
  final bool isCompleted;
  final DateTime createdAt;

  AppointmentModel({
    this.id,
    required this.userId,
    required this.petId,
    required this.title,
    this.description,
    required this.appointmentDate,
    required this.location,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'pet_id': petId,
      'title': title,
      'description': description,
      'appointment_date': appointmentDate.toIso8601String(),
      'location': location,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      userId: map['user_id'],
      petId: map['pet_id'],
      title: map['title'],
      description: map['description'],
      appointmentDate: DateTime.parse(map['appointment_date']),
      location: map['location'],
      isCompleted: map['is_completed'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  AppointmentModel copyWith({bool? isCompleted}) {
    return AppointmentModel(
      id: id,
      userId: userId,
      petId: petId,
      title: title,
      description: description,
      appointmentDate: appointmentDate,
      location: location,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
