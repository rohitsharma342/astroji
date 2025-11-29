class Astrologer {
  final String id;
  final String name;
  final String profileImage;
  final List<String> expertise;
  final double rating;
  final int reviewCount;
  final String experience;
  final double price;
  final bool isOnline;
  final String description;
  final List<String> languages;
  final List<String> availableTimes;
  
  Astrologer({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.expertise,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.price,
    required this.isOnline,
    required this.description,
    required this.languages,
    required this.availableTimes,
  });
}