import 'dart:io';

class Message {
  final String text;
  final bool isUser;
  final File? image;
  final String? audioUrl;  // Added to store the path/URL to the audio file

  Message({
    required this.text,
    required this.isUser,
    this.image,
    this.audioUrl,  // New parameter for audio URL or path
  });
}