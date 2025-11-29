import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/astrologer.dart';

class AstrologerCard extends StatelessWidget {
  final Astrologer astrologer;
  final VoidCallback onTap;
  final bool isHorizontal;

  const AstrologerCard({
    Key? key,
    required this.astrologer,
    required this.onTap,
    this.isHorizontal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalCard();
    }
    return _buildVerticalCard();
  }

  Widget _buildHorizontalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(astrologer.profileImage),
                    ),
                    SizedBox(height: 10),
                    Text(
                      astrologer.name,
                      style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    RatingBarIndicator(
                      rating: astrologer.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 12,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₹${astrologer.price}/min',
                      style: AppTextStyles.captionText.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: astrologer.isOnline ? AppColors.successColor : AppColors.errorColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Text(
                astrologer.isOnline ? 'Online' : 'Busy',
                style: AppTextStyles.captionText.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(astrologer.profileImage),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          astrologer.name,
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: astrologer.isOnline
                              ? AppColors.successColor
                              : AppColors.errorColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          astrologer.isOnline ? 'Online' : 'Busy',
                          style: AppTextStyles.captionText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    astrologer.expertise.join(', '),
                    style: AppTextStyles.captionText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: astrologer.rating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${astrologer.rating} (${astrologer.reviewCount})',
                        style: AppTextStyles.captionText,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '₹${astrologer.price}/min',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${astrologer.experience} exp',
                        style: AppTextStyles.captionText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(80, 35),
                  ),
                  child: Text(
                    'Chat',
                    style: AppTextStyles.captionText.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(80, 35),
                  ),
                  child: Text(
                    'Call',
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}