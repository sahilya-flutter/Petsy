class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? photoUrl;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
    };
  }
}
