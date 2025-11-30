class ChatMessage {
  final String id;
  final MessageSender sender;
  final String text;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
  });
}

enum MessageSender { user, ai }
