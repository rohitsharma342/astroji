import 'astrologer.dart';

class Booking {
  final String id;
  final Astrologer astrologer;
  final DateTime dateTime;
  final String consultationType;
  final double amount;
  final String status;
  final String? notes;
  
  Booking({
    required this.id,
    required this.astrologer,
    required this.dateTime,
    required this.consultationType,
    required this.amount,
    required this.status,
    this.notes,
  });
}