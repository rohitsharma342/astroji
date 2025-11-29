import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isFromUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isFromUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
        left: isFromUser ? 50 : 0,
        right: isFromUser ? 0 : 50,
      ),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromUser) ...[    
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150',
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromUser
                    ? AppColors.primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(isFromUser ? 20 : 5),
                  bottomRight: Radius.circular(isFromUser ? 5 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.text)
                    Text(
                      message.content,
                      style: AppTextStyles.bodyText.copyWith(
                        color: isFromUser
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    )
                  else if (message.type == MessageType.image)
                    Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(message.content),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          color: isFromUser
                              ? Colors.white
                              : AppColors.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Document',
                          style: AppTextStyles.bodyText.copyWith(
                            color: isFromUser
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: AppTextStyles.captionText.copyWith(
                      color: isFromUser
                          ? Colors.white70
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromUser) ...[    
            SizedBox(width: 8),
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}