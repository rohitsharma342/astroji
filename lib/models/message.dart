class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isFromUser;
  final MessageType type;
  
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isFromUser,
    this.type = MessageType.text,
  });
}

enum MessageType {
  text,
  image,
  file,
}