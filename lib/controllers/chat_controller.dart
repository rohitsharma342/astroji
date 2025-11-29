import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';

class ChatController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final String currentUserId = 'user_1';
  final String astrologerId;

  ChatController(this.astrologerId);

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() {
    isLoading.value = true;
    
    Future.delayed(const Duration(seconds: 1), () {
      messages.value = [
        Message(
          id: const Uuid().v4(),
          senderId: astrologerId,
          receiverId: currentUserId,
          content: 'Hello! Welcome to Astroji. How can I help you today?',
          type: MessageType.text,
          status: MessageStatus.read,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        Message(
          id: const Uuid().v4(),
          senderId: currentUserId,
          receiverId: astrologerId,
          content: 'Hi, I wanted to know about my career prospects.',
          type: MessageType.text,
          status: MessageStatus.read,
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        ),
        Message(
          id: const Uuid().v4(),
          senderId: astrologerId,
          receiverId: currentUserId,
          content: 'Sure! I can help you with that. Could you please share your birth details?',
          type: MessageType.text,
          status: MessageStatus.read,
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
      ];
      isLoading.value = false;
    });
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final message = Message(
      id: const Uuid().v4(),
      senderId: currentUserId,
      receiverId: astrologerId,
      content: content.trim(),
      type: MessageType.text,
      status: MessageStatus.sent,
      timestamp: DateTime.now(),
    );

    messages.add(message);

    _simulateResponse();
  }

  void _simulateResponse() {
    isTyping.value = true;
    
    Future.delayed(const Duration(seconds: 2), () {
      isTyping.value = false;
      
      final responses = [
        'Thank you for sharing that information.',
        'Based on your query, I can provide some insights.',
        'Let me analyze your birth chart for better guidance.',
        'I understand your concern. Here\'s what I suggest...',
        'That\'s an interesting question. Let me help you with that.',
      ];
      
      final randomResponse = responses[DateTime.now().millisecond % responses.length];
      
      final response = Message(
        id: const Uuid().v4(),
        senderId: astrologerId,
        receiverId: currentUserId,
        content: randomResponse,
        type: MessageType.text,
        status: MessageStatus.sent,
        timestamp: DateTime.now(),
      );
      
      messages.add(response);
    });
  }

  void markAsRead(String messageId) {
    final messageIndex = messages.indexWhere((msg) => msg.id == messageId);
    if (messageIndex != -1) {
      final message = messages[messageIndex];
      messages[messageIndex] = Message(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        type: message.type,
        status: MessageStatus.read,
        timestamp: message.timestamp,
        fileName: message.fileName,
        fileUrl: message.fileUrl,
      );
    }
  }
}