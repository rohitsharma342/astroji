class Astrologer {
  final String id;
  final String name;
  final String profileImage;
  final List<String> expertise;
  final double rating;
  final int reviewCount;
  final double pricePerMinute;
  final String description;
  final List<String> languages;
  final int experience;
  final bool isOnline;
  final bool isAvailable;
  final List<DateTime> availableSlots;

  Astrologer({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.expertise,
    required this.rating,
    required this.reviewCount,
    required this.pricePerMinute,
    required this.description,
    required this.languages,
    required this.experience,
    required this.isOnline,
    required this.isAvailable,
    required this.availableSlots,
  });

  factory Astrologer.fromJson(Map<String, dynamic> json) {
    return Astrologer(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      expertise: List<String>.from(json['expertise']),
      rating: json['rating'].toDouble(),
      reviewCount: json['review_count'],
      pricePerMinute: json['price_per_minute'].toDouble(),
      description: json['description'],
      languages: List<String>.from(json['languages']),
      experience: json['experience'],
      isOnline: json['is_online'],
      isAvailable: json['is_available'],
      availableSlots: (json['available_slots'] as List)
          .map((slot) => DateTime.parse(slot))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'expertise': expertise,
      'rating': rating,
      'review_count': reviewCount,
      'price_per_minute': pricePerMinute,
      'description': description,
      'languages': languages,
      'experience': experience,
      'is_online': isOnline,
      'is_available': isAvailable,
      'available_slots': availableSlots.map((slot) => slot.toIso8601String()).toList(),
    };
  }
}