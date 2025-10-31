class AppConstants {
  // App Info
  static const String appName = 'Petsy';
  static const String appVersion = '1.0.0';

  // Database
  static const String dbName = 'petsy.db';
  static const int dbVersion = 1;

  // Colors
  static const primaryColor = 0xFF9C27B0; // Purple
  static const secondaryColor = 0xFF2196F3; // Blue
  static const accentColor = 0xFFFF9800; // Orange

  // Species Options
  static const List<String> petSpecies = [
    'Dog',
    'Cat',
    'Bird',
    'Fish',
    'Rabbit',
    'Hamster',
    'Guinea Pig',
    'Reptile',
    'Other',
  ];

  // Reminder Frequencies
  static const List<String> reminderFrequencies = [
    'once',
    'daily',
    'weekly',
    'monthly',
  ];
}
