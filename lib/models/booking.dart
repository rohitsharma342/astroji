import 'package:flutter/material.dart';
import 'astrologer.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }
enum ConsultationType { chat, voice, video }

class Booking {
  final String id;
  final String userId;
  final String astrologerId;
  final DateTime dateTime;
  final ConsultationType type;
  final BookingStatus status;
  final double amount;
  final String? notes;
  final DateTime createdAt;
  final Astrologer? astrologer;

  Booking({
    required this.id,
    required this.userId,
    required this.astrologerId,
    required this.dateTime,
    required this.type,
    required this.status,
    required this.amount,
    this.notes,
    required this.createdAt,
    this.astrologer,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      astrologerId: json['astrologer_id'],
      dateTime: DateTime.parse(json['date_time']),
      type: ConsultationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      amount: json['amount'].toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      astrologer: json['astrologer'] != null
          ? Astrologer.fromJson(json['astrologer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'astrologer_id': astrologerId,
      'date_time': dateTime.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'amount': amount,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'astrologer': astrologer?.toJson(),
    };
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case BookingStatus.pending:
        return const Color(0xFFED8936);
      case BookingStatus.confirmed:
        return const Color(0xFF0020BD);
      case BookingStatus.completed:
        return const Color(0xFF48BB78);
      case BookingStatus.cancelled:
        return const Color(0xFFE53E3E);
    }
  }
}