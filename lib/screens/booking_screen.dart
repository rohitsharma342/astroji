import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/astrologer.dart';
import '../models/booking.dart';
import '../services/data_service.dart';
import 'dashboard_screen.dart';

class BookingScreen extends StatefulWidget {
  final Astrologer astrologer;
  final DateTime selectedDate;
  final String selectedTime;

  const BookingScreen({
    Key? key,
    required this.astrologer,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String _selectedConsultationType = 'Video Call';
  String _selectedPaymentMethod = 'UPI';
  final List<String> _consultationTypes = ['Video Call', 'Audio Call', 'Chat'];
  final List<String> _paymentMethods = ['UPI', 'Credit Card', 'Debit Card', 'Net Banking'];
  bool _isBooking = false;

  @override
  Widget build(BuildContext context) {
    final duration = _selectedConsultationType == 'Chat' ? 30 : 15;
    final totalAmount = widget.astrologer.price * duration;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Book Consultation'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAstrologerSummary(),
            SizedBox(height: 20),
            _buildBookingDetails(),
            SizedBox(height: 20),
            _buildConsultationTypeSection(),
            SizedBox(height: 20),
            _buildPaymentSection(),
            SizedBox(height: 20),
            _buildPriceSummary(duration, totalAmount),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isBooking ? null : () => _confirmBooking(totalAmount),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            minimumSize: Size(double.infinity, 55),
          ),
          child: _isBooking
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Confirm Booking - ₹${totalAmount.toStringAsFixed(0)}',
                  style: AppTextStyles.buttonText,
                ),
        ),
      ),
    );
  }

  Widget _buildAstrologerSummary() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.astrologer.profileImage),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.astrologer.name, style: AppTextStyles.heading2),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 5),
                      Text(
                        '${widget.astrologer.rating} (${widget.astrologer.reviewCount})',
                        style: AppTextStyles.captionText,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.astrologer.expertise.join(', '),
                    style: AppTextStyles.captionText,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Online',
                style: AppTextStyles.captionText.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking Details', style: AppTextStyles.heading2),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primaryColor),
                SizedBox(width: 10),
                Text(
                  DateFormat('EEEE, MMM dd, yyyy').format(widget.selectedDate),
                  style: AppTextStyles.bodyText,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primaryColor),
                SizedBox(width: 10),
                Text(widget.selectedTime, style: AppTextStyles.bodyText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationTypeSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consultation Type', style: AppTextStyles.heading2),
            SizedBox(height: 15),
            Column(
              children: _consultationTypes.map((type) {
                return RadioListTile<String>(
                  title: Text(type),
                  value: type,
                  groupValue: _selectedConsultationType,
                  onChanged: (value) {
                    setState(() {
                      _selectedConsultationType = value!;
                    });
                  },
                  activeColor: AppColors.primaryColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Method', style: AppTextStyles.heading2),
            SizedBox(height: 15),
            Column(
              children: _paymentMethods.map((method) {
                return RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  activeColor: AppColors.primaryColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(int duration, double totalAmount) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price Summary', style: AppTextStyles.heading2),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration', style: AppTextStyles.bodyText),
                Text('$duration minutes', style: AppTextStyles.bodyText),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rate per minute', style: AppTextStyles.bodyText),
                Text('₹${widget.astrologer.price}', style: AppTextStyles.bodyText),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Taxes & Fees', style: AppTextStyles.bodyText),
                Text('₹0', style: AppTextStyles.bodyText),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount', style: AppTextStyles.heading2),
                Text(
                  '₹${totalAmount.toStringAsFixed(0)}',
                  style: AppTextStyles.heading2.copyWith(color: AppColors.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(double totalAmount) async {
    setState(() {
      _isBooking = true;
    });

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2));

    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      astrologer: widget.astrologer,
      dateTime: DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        int.parse(widget.selectedTime.split(':')[0]),
        int.parse(widget.selectedTime.split(':')[1].split(' ')[0]),
      ),
      consultationType: _selectedConsultationType,
      amount: totalAmount,
      status: 'Confirmed',
    );

    Provider.of<DataService>(context, listen: false).addBooking(booking);

    setState(() {
      _isBooking = false;
    });

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.successColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Booking Confirmed!',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Your consultation with ${widget.astrologer.name} has been confirmed.',
                style: AppTextStyles.bodyText,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text('Go to Dashboard', style: AppTextStyles.buttonText),
              ),
            ],
          ),
        );
      },
    );
  }
}