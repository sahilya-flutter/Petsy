class ReminderModel {
  final int? id;
  final int userId;
  final int? petId;
  final String title;
  final String? description;
  final DateTime reminderDate;
  final String frequency; // once, daily, weekly, monthly
  final bool isActive;
  final DateTime createdAt;

  ReminderModel({
    this.id,
    required this.userId,
    this.petId,
    required this.title,
    this.description,
    required this.reminderDate,
    this.frequency = 'once',
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'pet_id': petId,
      'title': title,
      'description': description,
      'reminder_date': reminderDate.toIso8601String(),
      'frequency': frequency,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      userId: map['user_id'],
      petId: map['pet_id'],
      title: map['title'],
      description: map['description'],
      reminderDate: DateTime.parse(map['reminder_date']),
      frequency: map['frequency'],
      isActive: map['is_active'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  ReminderModel copyWith({bool? isActive}) {
    return ReminderModel(
      id: id,
      userId: userId,
      petId: petId,
      title: title,
      description: description,
      reminderDate: reminderDate,
      frequency: frequency,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
