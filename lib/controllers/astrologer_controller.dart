import 'package:get/get.dart';
import '../models/astrologer.dart';
import '../utils/constants.dart';

class AstrologerController extends GetxController {
  final RxList<Astrologer> astrologers = <Astrologer>[].obs;
  final RxList<Astrologer> trendingAstrologers = <Astrologer>[].obs;
  final RxList<Astrologer> filteredAstrologers = <Astrologer>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;

  final List<String> categories = [
    'All',
    'Vedic',
    'Tarot',
    'Numerology',
    'Palmistry',
    'Vastu'
  ];

  @override
  void onInit() {
    super.onInit();
    loadAstrologers();
  }

  void loadAstrologers() {
    isLoading.value = true;
    
    Future.delayed(const Duration(seconds: 1), () {
      astrologers.value = [
        Astrologer(
          id: 'ast_1',
          name: 'Dr. Rajesh Sharma',
          profileImage: ImageUrls.defaultAstrologer,
          expertise: ['Vedic', 'Palmistry'],
          rating: 4.8,
          reviewCount: 1250,
          pricePerMinute: 45.0,
          description: 'Expert in Vedic astrology with 15+ years of experience.',
          languages: ['Hindi', 'English'],
          experience: 15,
          isOnline: true,
          isAvailable: true,
          availableSlots: _generateAvailableSlots(),
        ),
        Astrologer(
          id: 'ast_2',
          name: 'Priya Mehta',
          profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b5bb?w=400',
          expertise: ['Tarot', 'Numerology'],
          rating: 4.9,
          reviewCount: 987,
          pricePerMinute: 55.0,
          description: 'Tarot card reading expert with intuitive insights.',
          languages: ['Hindi', 'English', 'Gujarati'],
          experience: 12,
          isOnline: true,
          isAvailable: true,
          availableSlots: _generateAvailableSlots(),
        ),
        Astrologer(
          id: 'ast_3',
          name: 'Arun Kumar',
          profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
          expertise: ['Numerology', 'Vastu'],
          rating: 4.7,
          reviewCount: 756,
          pricePerMinute: 40.0,
          description: 'Numerology and Vastu consultant for life guidance.',
          languages: ['Hindi', 'English', 'Tamil'],
          experience: 10,
          isOnline: false,
          isAvailable: true,
          availableSlots: _generateAvailableSlots(),
        ),
        Astrologer(
          id: 'ast_4',
          name: 'Meera Singh',
          profileImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
          expertise: ['Vedic', 'Tarot'],
          rating: 4.6,
          reviewCount: 432,
          pricePerMinute: 50.0,
          description: 'Combined approach of Vedic astrology and Tarot reading.',
          languages: ['Hindi', 'English', 'Punjabi'],
          experience: 8,
          isOnline: true,
          isAvailable: false,
          availableSlots: _generateAvailableSlots(),
        ),
      ];
      
      trendingAstrologers.value = astrologers.take(3).toList();
      filteredAstrologers.value = astrologers;
      isLoading.value = false;
    });
  }

  List<DateTime> _generateAvailableSlots() {
    final now = DateTime.now();
    final slots = <DateTime>[];
    
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      for (int hour = 9; hour <= 21; hour += 2) {
        slots.add(DateTime(date.year, date.month, date.day, hour));
      }
    }
    
    return slots;
  }

  void searchAstrologers(String query) {
    searchQuery.value = query;
    _filterAstrologers();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _filterAstrologers();
  }

  void _filterAstrologers() {
    var filtered = astrologers.where((astrologer) {
      final matchesSearch = searchQuery.value.isEmpty ||
          astrologer.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          astrologer.expertise.any((exp) => 
              exp.toLowerCase().contains(searchQuery.value.toLowerCase()));
      
      final matchesCategory = selectedCategory.value == 'All' ||
          astrologer.expertise.contains(selectedCategory.value);
      
      return matchesSearch && matchesCategory;
    }).toList();
    
    filteredAstrologers.value = filtered;
  }

  Astrologer? getAstrologerById(String id) {
    return astrologers.firstWhereOrNull((astrologer) => astrologer.id == id);
  }
}