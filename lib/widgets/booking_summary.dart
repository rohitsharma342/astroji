import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/data_service.dart';

class BookingSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final upcomingBookings = dataService.bookings
            .where((booking) => booking.dateTime.isAfter(DateTime.now()))
            .toList();

        if (upcomingBookings.isEmpty) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textSecondary,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  'No Upcoming Bookings',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Book a consultation with your favorite astrologer',
                  style: AppTextStyles.captionText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming Bookings', style: AppTextStyles.heading2),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: upcomingBookings.length,
              itemBuilder: (context, index) {
                final booking = upcomingBookings[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(booking.astrologer.profileImage),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.astrologer.name,
                              style: AppTextStyles.bodyText.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${DateFormat('MMM dd, yyyy').format(booking.dateTime)} at ${DateFormat('HH:mm').format(booking.dateTime)}',
                              style: AppTextStyles.captionText,
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  booking.consultationType == 'Video Call'
                                      ? Icons.videocam
                                      : booking.consultationType == 'Audio Call'
                                          ? Icons.call
                                          : Icons.chat,
                                  size: 16,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  booking.consultationType,
                                  style: AppTextStyles.captionText.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.successColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              booking.status,
                              style: AppTextStyles.captionText.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '₹${booking.amount.toStringAsFixed(0)}',
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}