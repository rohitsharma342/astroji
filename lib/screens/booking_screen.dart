import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/astrologer.dart';
import '../models/booking.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class BookingScreen extends StatefulWidget {
  final Astrologer astrologer;

  const BookingScreen({super.key, required this.astrologer});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedTime;
  ConsultationType selectedType = ConsultationType.chat;
  String selectedPaymentMethod = 'razorpay';
  bool isLoading = false;

  final Map<ConsultationType, String> consultationTypes = {
    ConsultationType.chat: 'Chat',
    ConsultationType.voice: 'Voice Call',
    ConsultationType.video: 'Video Call',
  };

  final Map<ConsultationType, double> typeMultipliers = {
    ConsultationType.chat: 1.0,
    ConsultationType.voice: 1.2,
    ConsultationType.video: 1.5,
  };

  final Map<String, String> paymentMethods = {
    'razorpay': 'Razorpay',
    'paytm': 'Paytm',
    'googlepay': 'Google Pay',
    'phonepe': 'PhonePe',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Book Consultation'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAstrologerSummary(),
                  const SizedBox(height: 24),
                  _buildDateSelection(),
                  const SizedBox(height: 24),
                  _buildTimeSelection(),
                  const SizedBox(height: 24),
                  _buildConsultationTypeSelection(),
                  const SizedBox(height: 24),
                  _buildPaymentMethodSelection(),
                  const SizedBox(height: 24),
                  _buildPriceSummary(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildAstrologerSummary() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: widget.astrologer.profileImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.astrologer.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.astrologer.expertise.join(', '),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.astrologer.rating} (${widget.astrologer.reviewCount} reviews)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                selectedTime = null;
              });
            },
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    final availableTimes = widget.astrologer.availableSlots
        .where((slot) => isSameDay(slot, selectedDate))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (availableTimes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Text(
              'No available slots for this date',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableTimes.map((time) {
              final isSelected = selectedTime != null && 
                  selectedTime!.hour == time.hour &&
                  selectedTime!.minute == time.minute;
              
              return GestureDetector(
                onTap: () => setState(() => selectedTime = time),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    DateHelper.formatTime(time),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildConsultationTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consultation Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: consultationTypes.entries.map((entry) {
            final type = entry.key;
            final label = entry.value;
            final multiplier = typeMultipliers[type] ?? 1.0;
            final price = widget.astrologer.pricePerMinute * multiplier;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: RadioListTile<ConsultationType>(
                value: type,
                groupValue: selectedType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedType = value);
                  }
                },
                title: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  PriceHelper.formatPricePerMinute(price),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                activeColor: AppColors.primary,
                tileColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: paymentMethods.entries.map((entry) {
            final method = entry.key;
            final label = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: RadioListTile<String>(
                value: method,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedPaymentMethod = value);
                  }
                },
                title: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                activeColor: AppColors.primary,
                tileColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    final multiplier = typeMultipliers[selectedType] ?? 1.0;
    final basePrice = widget.astrologer.pricePerMinute * multiplier;
    final sessionMinutes = 30; // Default session duration
    final subtotal = basePrice * sessionMinutes;
    final tax = subtotal * 0.18; // 18% GST
    final total = subtotal + tax;

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${consultationTypes[selectedType]} ($sessionMinutes mins)',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                PriceHelper.formatPrice(subtotal),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GST (18%)',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                PriceHelper.formatPrice(tax),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                PriceHelper.formatPrice(total),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final canBook = selectedTime != null;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canBook && !isLoading ? _confirmBooking : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  void _confirmBooking() async {
    if (selectedTime == null) return;

    setState(() => isLoading = true);

    try {
      // Simulate payment process
      await Future.delayed(const Duration(seconds: 2));

      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user_1',
        astrologerId: widget.astrologer.id,
        dateTime: selectedTime!,
        type: selectedType,
        status: BookingStatus.confirmed,
        amount: _calculateTotal(),
        createdAt: DateTime.now(),
        astrologer: widget.astrologer,
      );

      Get.back();
      Get.snackbar(
        'Booking Confirmed',
        'Your consultation has been booked successfully!',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Booking Failed',
        'There was an error processing your booking. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  double _calculateTotal() {
    final multiplier = typeMultipliers[selectedType] ?? 1.0;
    final basePrice = widget.astrologer.pricePerMinute * multiplier;
    final sessionMinutes = 30;
    final subtotal = basePrice * sessionMinutes;
    final tax = subtotal * 0.18;
    return subtotal + tax;
  }
}