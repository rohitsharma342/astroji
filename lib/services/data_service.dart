import 'package:flutter/foundation.dart';
import '../models/astrologer.dart';
import '../models/booking.dart';
import '../models/message.dart';
import '../models/user.dart';

class DataService extends ChangeNotifier {
  List<Astrologer> _astrologers = [];
  List<Booking> _bookings = [];
  List<Message> _messages = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  
  List<Astrologer> get astrologers {
    if (_searchQuery.isEmpty && _selectedCategory == 'All') {
      return _astrologers;
    }
    return _astrologers.where((astrologer) {
      final matchesSearch = _searchQuery.isEmpty ||
          astrologer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          astrologer.expertise.any((exp) => exp.toLowerCase().contains(_searchQuery.toLowerCase()));
      final matchesCategory = _selectedCategory == 'All' ||
          astrologer.expertise.contains(_selectedCategory);
      return matchesSearch && matchesCategory;
    }).toList();
  }
  
  List<Booking> get bookings => _bookings;
  List<Message> get messages => _messages;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  
  DataService() {
    _initializeData();
  }
  
  void _initializeData() {
    _astrologers = [
      Astrologer(
        id: '1',
        name: 'Dr. Priya Sharma',
        profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150',
        expertise: ['Vedic', 'Numerology'],
        rating: 4.8,
        reviewCount: 1250,
        experience: '15 years',
        price: 25.0,
        isOnline: true,
        description: 'Expert in Vedic astrology with specialization in career and relationship guidance.',
        languages: ['English', 'Hindi'],
        availableTimes: ['10:00 AM', '2:00 PM', '6:00 PM'],
      ),
      Astrologer(
        id: '2',
        name: 'Pandit Raj Kumar',
        profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        expertise: ['Tarot', 'Palmistry'],
        rating: 4.6,
        reviewCount: 890,
        experience: '12 years',
        price: 30.0,
        isOnline: false,
        description: 'Renowned tarot card reader and palmistry expert.',
        languages: ['English', 'Hindi', 'Bengali'],
        availableTimes: ['11:00 AM', '3:00 PM', '7:00 PM'],
      ),
      Astrologer(
        id: '3',
        name: 'Meera Gupta',
        profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
        expertise: ['Numerology', 'Gemstones'],
        rating: 4.9,
        reviewCount: 2100,
        experience: '20 years',
        price: 40.0,
        isOnline: true,
        description: 'Master numerologist with expertise in gemstone consultation.',
        languages: ['English', 'Hindi', 'Gujarati'],
        availableTimes: ['9:00 AM', '1:00 PM', '5:00 PM'],
      ),
    ];
    
    _bookings = [
      Booking(
        id: '1',
        astrologer: _astrologers[0],
        dateTime: DateTime.now().add(Duration(days: 1)),
        consultationType: 'Video Call',
        amount: 25.0,
        status: 'Confirmed',
      ),
    ];
    
    _messages = [
      Message(
        id: '1',
        senderId: 'user1',
        receiverId: '1',
        content: 'Hello, I would like to know about my career prospects.',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        isFromUser: true,
      ),
      Message(
        id: '2',
        senderId: '1',
        receiverId: 'user1',
        content: 'Hello! I\'d be happy to help you with career guidance. Please share your birth details.',
        timestamp: DateTime.now().subtract(Duration(minutes: 3)),
        isFromUser: false,
      ),
    ];
  }
  
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void updateSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
  
  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }
  
  Astrologer? getAstrologerById(String id) {
    return _astrologers.firstWhere((astrologer) => astrologer.id == id);
  }
}