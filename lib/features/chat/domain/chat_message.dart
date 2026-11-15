import 'dart:convert';
import 'dart:typed_data';

class ChatAttachment {
  const ChatAttachment({
    required this.name,
    required this.mimeType,
    required this.bytes,
  });

  final String name;
  final String mimeType;
  final Uint8List bytes;

  Map<String, String> toJson() => {
    'mimeType': mimeType,
    'data': base64Encode(bytes),
  };
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.createdAt,
    this.attachment,
    this.isError = false,
  });

  final String text;
  final bool isUser;
  final DateTime createdAt;
  final ChatAttachment? attachment;
  final bool isError;

  Map<String, String> toHistory() => {
    'role': isUser ? 'user' : 'model',
    'text': text,
  };
}
