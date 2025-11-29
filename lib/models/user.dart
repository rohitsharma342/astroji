class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime dateOfBirth;
  final String? phone;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.dateOfBirth,
    this.phone,
  });
}