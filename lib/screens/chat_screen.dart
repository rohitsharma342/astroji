import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/message.dart';
import '../services/data_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String astrologerId;
  final String astrologerName;

  const ChatScreen({
    Key? key,
    required this.astrologerId,
    required this.astrologerName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.astrologerName,
                    style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Online',
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.successColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () => _startVideoCall(),
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () => _startAudioCall(),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('View Profile'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: Text('Block User'),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<DataService>(
              builder: (context, dataService, child) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16),
                  itemCount: dataService.messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == dataService.messages.length && _isTyping) {
                      return _buildTypingIndicator();
                    }
                    
                    final message = dataService.messages[index];
                    return MessageBubble(
                      message: message,
                      isFromUser: message.isFromUser,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: AppColors.primaryColor),
            onPressed: () => _showAttachmentOptions(),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                maxLines: null,
                onChanged: (value) {
                  // Handle typing indicator
                },
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150',
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Typing', style: AppTextStyles.captionText),
                SizedBox(width: 5),
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'user1',
      receiverId: widget.astrologerId,
      content: text,
      timestamp: DateTime.now(),
      isFromUser: true,
    );

    Provider.of<DataService>(context, listen: false).addMessage(message);
    _messageController.clear();

    // Simulate astrologer response
    _simulateResponse();

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _simulateResponse() {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      final responses = [
        'Thank you for sharing that information.',
        'Based on your birth chart, I can see some interesting patterns.',
        'Let me analyze this further for you.',
        'I understand your concern. Let me help you with that.',
        'Your planetary positions suggest...',
      ];

      final randomResponse = responses[DateTime.now().millisecondsSinceEpoch % responses.length];
      
      final response = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: widget.astrologerId,
        receiverId: 'user1',
        content: randomResponse,
        timestamp: DateTime.now(),
        isFromUser: false,
      );

      Provider.of<DataService>(context, listen: false).addMessage(response);
      
      setState(() {
        _isTyping = false;
      });

      // Scroll to bottom
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Attachment', style: AppTextStyles.heading2),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildAttachmentOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    label: 'Document',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
          SizedBox(height: 8),
          Text(label, style: AppTextStyles.captionText),
        ],
      ),
    );
  }

  void _startVideoCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Video Call'),
        content: Text('Starting video call with ${widget.astrologerName}...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Start Call'),
          ),
        ],
      ),
    );
  }

  void _startAudioCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Audio Call'),
        content: Text('Starting audio call with ${widget.astrologerName}...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Start Call'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}