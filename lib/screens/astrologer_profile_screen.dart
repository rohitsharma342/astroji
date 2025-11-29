import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/astrologer.dart';
import 'booking_screen.dart';
import 'chat_screen.dart';

class AstrologerProfileScreen extends StatefulWidget {
  final Astrologer astrologer;

  const AstrologerProfileScreen({Key? key, required this.astrologer}) : super(key: key);

  @override
  _AstrologerProfileScreenState createState() => _AstrologerProfileScreenState();
}

class _AstrologerProfileScreenState extends State<AstrologerProfileScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.astrologer.profileImage),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.astrologer.name,
                      style: AppTextStyles.heading1.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBarIndicator(
                          rating: widget.astrologer.rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${widget.astrologer.rating} (${widget.astrologer.reviewCount} reviews)',
                          style: AppTextStyles.bodyText.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(),
                  SizedBox(height: 20),
                  _buildExpertiseSection(),
                  SizedBox(height: 20),
                  _buildDescriptionSection(),
                  SizedBox(height: 20),
                  _buildAvailabilitySection(),
                  SizedBox(height: 20),
                  _buildReviewsSection(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
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
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      astrologerId: widget.astrologer.id,
                      astrologerName: widget.astrologer.name,
                    ),
                  ),
                ),
                icon: Icon(Icons.chat, color: AppColors.primaryColor),
                label: Text(
                  'Chat',
                  style: AppTextStyles.buttonText.copyWith(color: AppColors.primaryColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: Size(0, 50),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _selectedTime != null ? () => _navigateToBooking() : null,
                icon: Icon(Icons.video_call, color: Colors.white),
                label: Text('Book Now', style: AppTextStyles.buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: Size(0, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Experience', style: AppTextStyles.captionText),
                  Text(widget.astrologer.experience, style: AppTextStyles.bodyText),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price per minute', style: AppTextStyles.captionText),
                  Text('₹${widget.astrologer.price}', style: AppTextStyles.bodyText),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.astrologer.isOnline ? AppColors.successColor : AppColors.errorColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.astrologer.isOnline ? 'Online' : 'Offline',
                style: AppTextStyles.captionText.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertiseSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expertise', style: AppTextStyles.heading2),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: widget.astrologer.expertise.map((expertise) {
                return Chip(
                  label: Text(expertise),
                  backgroundColor: AppColors.secondaryColor,
                  labelStyle: AppTextStyles.captionText.copyWith(
                    color: AppColors.primaryColor,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text('Languages', style: AppTextStyles.bodyText),
            Text(
              widget.astrologer.languages.join(', '),
              style: AppTextStyles.captionText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About', style: AppTextStyles.heading2),
            SizedBox(height: 10),
            Text(widget.astrologer.description, style: AppTextStyles.bodyText),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Date & Time', style: AppTextStyles.heading2),
            SizedBox(height: 10),
            TableCalendar<String>(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 30)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedTime = null;
                });
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            SizedBox(height: 20),
            Text('Available Times', style: AppTextStyles.bodyText),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: widget.astrologer.availableTimes.map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryColor : AppColors.dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      time,
                      style: AppTextStyles.bodyText.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reviews', style: AppTextStyles.heading2),
            SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: Text('U${index + 1}'),
                  ),
                  title: Row(
                    children: [
                      Text('User ${index + 1}', style: AppTextStyles.bodyText),
                      SizedBox(width: 10),
                      RatingBarIndicator(
                        rating: 4.5 + (index * 0.1),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Great consultation! Very insightful and helpful.',
                    style: AppTextStyles.captionText,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          astrologer: widget.astrologer,
          selectedDate: _selectedDay,
          selectedTime: _selectedTime!,
        ),
      ),
    );
  }
}