import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:upi_pay/features/user/chat/provider/audio_service.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isTyping;
  final String? audioPath;

  ChatMessage({required this.text, required this.isUser, this.isTyping = false, this.audioPath});
}

class _AudioScreenState extends State<AudioScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioService _audioService = AudioService();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  String? _recordedFilePath;

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/temp.aac';
    await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);

    setState(() {
      _isRecording = true;
      _recordedFilePath = path;
    });
  }

  Future<void> _stopRecordingAndSend() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (_recordedFilePath != null) {
      File audioFile = File(_recordedFilePath!);

      // Add user's message
      setState(() {
        _messages.add(ChatMessage(text: "Voice message", isUser: true));
        _messages.add(ChatMessage(text: "AI is typing...", isUser: false, isTyping: true));
      });

      final response = await _audioService.sendAudioAndGetResponse(audioFile);

      setState(() {
        // Remove typing indicator
        _messages.removeWhere((msg) => msg.isTyping);
        // Add AI response
        _messages.add(ChatMessage(
          text: response['text'],
          isUser: false,
          audioPath: response['audioPath'],
        ));
      });

      // Play AI response if audio exists
      if (response['success'] && response['audioPath'] != null) {
        _player.play(DeviceFileSource(response['audioPath']));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response['text']}")),
        );
      }
    }
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: message.isTyping
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 6),
                  const Text('Typing...', style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(color: message.isUser ? Colors.white : Colors.black),
                  ),
                  if (message.audioPath != null)
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        _player.play(DeviceFileSource(message.audioPath!));
                      },
                    ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
                    iconSize: 30,
                    color: _isRecording ? Colors.red : Colors.blue,
                    onPressed: _isRecording ? _stopRecordingAndSend : _startRecording,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text("Tap mic to speak or tap to start/stop recording."),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
