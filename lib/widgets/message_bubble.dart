import 'package:flutter/material.dart';
import '../models/message.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isFromMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isFromMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromMe) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isFromMe 
                    ? AppColors.primary 
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isFromMe ? 20 : 4),
                  bottomRight: Radius.circular(isFromMe ? 4 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessageContent(),
                  const SizedBox(height: 4),
                  _buildMessageInfo(),
                ],
              ),
            ),
          ),
          if (isFromMe) ...[
            const SizedBox(width: 8),
            _buildAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (!isFromMe) {
      return const CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        ),
      );
    }
    return const CircleAvatar(
      radius: 16,
      backgroundImage: NetworkImage(
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 14,
            color: isFromMe ? Colors.white : AppColors.textPrimary,
            height: 1.4,
          ),
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.fileUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.fileUrl!,
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            if (message.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 14,
                  color: isFromMe ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ],
        );
      case MessageType.file:
        return Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              color: isFromMe ? Colors.white : AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.fileName ?? 'File',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isFromMe ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 12,
                        color: isFromMe 
                            ? Colors.white.withOpacity(0.8) 
                            : AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      case MessageType.system:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: isFromMe 
                ? Colors.white.withOpacity(0.8) 
                : AppColors.textSecondary,
          ),
        );
    }
  }

  Widget _buildMessageInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.timestamp),
          style: TextStyle(
            fontSize: 10,
            color: isFromMe 
                ? Colors.white.withOpacity(0.7) 
                : AppColors.textSecondary,
          ),
        ),
        if (isFromMe) ...[
          const SizedBox(width: 4),
          Icon(
            message.statusIcon,
            size: 12,
            color: message.statusColor,
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    if (DateHelper.isToday(dateTime)) {
      return DateHelper.formatTime(dateTime);
    } else if (DateHelper.isYesterday(dateTime)) {
      return 'Yesterday ${DateHelper.formatTime(dateTime)}';
    } else {
      return '${DateHelper.formatDate(dateTime)} ${DateHelper.formatTime(dateTime)}';
    }
  }
}