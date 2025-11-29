import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/astrologer.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class AstrologerCard extends StatelessWidget {
  final Astrologer astrologer;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const AstrologerCard({
    super.key,
    required this.astrologer,
    this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isHorizontal ? _buildHorizontalLayout() : _buildVerticalLayout(),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        _buildProfileImage(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameAndStatus(),
              const SizedBox(height: 8),
              _buildExpertise(),
              const SizedBox(height: 8),
              _buildRatingAndReviews(),
              const SizedBox(height: 12),
              _buildPriceAndAvailability(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfileImage(),
        const SizedBox(height: 16),
        _buildNameAndStatus(),
        const SizedBox(height: 8),
        _buildExpertise(),
        const SizedBox(height: 8),
        _buildRatingAndReviews(),
        const SizedBox(height: 16),
        _buildPriceAndAvailability(),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: isHorizontal ? 64 : 80,
          height: isHorizontal ? 64 : 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF667EEA).withOpacity(0.1),
                const Color(0xFF764BA2).withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF667EEA).withOpacity(0.2),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: astrologer.profileImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[200]!,
                      Colors.grey[300]!,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[200]!,
                      Colors.grey[300]!,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 2,
          bottom: 2,
          child: Container(
            width: isHorizontal ? 16 : 20,
            height: isHorizontal ? 16 : 20,
            decoration: BoxDecoration(
              color: astrologer.isOnline ? const Color(0xFF10B981) : const Color(0xFF6B7280),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameAndStatus() {
    return Column(
      crossAxisAlignment: isHorizontal 
          ? CrossAxisAlignment.start 
          : CrossAxisAlignment.center,
      children: [
        Text(
          astrologer.name,
          style: TextStyle(
            fontSize: isHorizontal ? 16 : 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
            letterSpacing: -0.2,
          ),
          textAlign: isHorizontal ? TextAlign.start : TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${astrologer.experience} years experience',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildExpertise() {
    return Wrap(
      alignment: isHorizontal ? WrapAlignment.start : WrapAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: astrologer.expertise.take(2).map((expertise) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF667EEA).withOpacity(0.1),
                const Color(0xFF764BA2).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF667EEA).withOpacity(0.2),
            ),
          ),
          child: Text(
            expertise,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatingAndReviews() {
    return Row(
      mainAxisAlignment: isHorizontal 
          ? MainAxisAlignment.start 
          : MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFF59E0B),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                astrologer.rating.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '(${astrologer.reviewCount} reviews)',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndAvailability() {
    return Row(
      mainAxisAlignment: isHorizontal 
          ? MainAxisAlignment.spaceBetween 
          : MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: isHorizontal 
              ? CrossAxisAlignment.start 
              : CrossAxisAlignment.center,
          children: [
            Text(
              PriceHelper.formatPricePerMinute(astrologer.pricePerMinute),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: astrologer.isAvailable 
                    ? const Color(0xFFD1FAE5) 
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                astrologer.isAvailable ? 'Available' : 'Busy',
                style: TextStyle(
                  fontSize: 11,
                  color: astrologer.isAvailable 
                      ? const Color(0xFF065F46) 
                      : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (isHorizontal) ..[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ],
    );
  }
}