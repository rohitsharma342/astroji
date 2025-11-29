class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final DateTime dateOfBirth;
  final String timeOfBirth;
  final String placeOfBirth;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.placeOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profile_image'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      timeOfBirth: json['time_of_birth'],
      placeOfBirth: json['place_of_birth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'time_of_birth': timeOfBirth,
      'place_of_birth': placeOfBirth,
    };
  }
}