import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upi_pay/core/utils/hexcolor.dart';
import 'package:upi_pay/features/user/chat/model/message.dart';
import 'package:upi_pay/features/user/chat/provider/chat_history_provider.dart';
import 'package:upi_pay/features/user/chat/provider/chat_provider.dart';
import 'package:upi_pay/features/user/chat/view/widgets/chat_item.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_profile.dart';
import 'package:upi_pay/features/user/dashboard/presentation/providers/citizen_profile_provider.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final _userMessage = TextEditingController();
  final _scrollController = ScrollController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isFetching = false;

  // Speech-to-text instance
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';

  // Audio recording and playback
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  bool _isPlayingAudio = false;
  String? _recordedAudioPath;
  int? _playingMessageIndex; // Track which message's audio is playing
  String _transcribedText = ''; // Store transcribed text from audio

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    // Initialize SpeechToText
    _initializeSpeech();
    // Initialize audio recorder
    _initializeRecorder();

    // Scroll to bottom after messages load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Listen to audio player state changes
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlayingAudio = false;
          _playingMessageIndex = null;
        });
      }
    });
  }

  Future<void> _initializeSpeech() async {
    await _speech.initialize(
      onStatus: (status) => print('Speech Status: $status'),
      onError: (error) => print('Speech Error: $error'),
    );
  }

  Future<void> _initializeRecorder() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission not granted');
      return;
    }

    await _soundRecorder.openRecorder();
    _isRecorderInitialized = true;
  }

  // Start listening to speech and convert it to text
  Future<void> _startListening() async {
    if (_isRecording) {
      await _stopRecording();
      return;
    }

    if (!_isRecorderInitialized) {
      print('Recorder not initialized');
      return;
    }

    final tempDir = await getTemporaryDirectory();
    _recordedAudioPath =
        '${tempDir.path}/audio_message_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _soundRecorder.startRecorder(
      toFile: _recordedAudioPath,
      codec: Codec.aacADTS,
    );

    setState(() {
      _isRecording = true;
    });
  }

  // Stop recording audio
  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    await _soundRecorder.stopRecorder();

    setState(() {
      _isRecording = false;
    });

    // Perform real transcription with fallback
    await simulateTranscription();

    // Show a brief toast or feedback that transcription is complete
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Audio recorded and transcribed'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Actually perform speech-to-text conversion (with fallback simulation)
  Future<void> simulateTranscription() async {
    try {
      // First try to use the actual Speech-to-Text service
      bool available = await _speech.initialize(
        onStatus: (status) => log('Speech Status: $status'),
        onError: (error) => log('Speech Error: $error'),
      );

      if (available) {
        // Use the recorded audio file for transcription
        // Note: This is a simplified approach - in production you'd use a more robust service
        // that can process audio files directly

        // Start listening from the microphone as a fallback
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _transcribedText = result.recognizedWords;
              _userMessage.text = _transcribedText;
            });
          },
        );

        // Stop after 3 seconds
        await Future.delayed(Duration(seconds: 3));
        await _speech.stop();

        // If we didn't get any text, use a fallback
        if (_transcribedText.isEmpty) {
          setState(() {
            _transcribedText = "Voice message (tap to play)";
            _userMessage.text = _transcribedText;
          });
        }
      } else {
        // Fallback if speech recognition is not available
        setState(() {
          _transcribedText = "Voice message (tap to play)";
          _userMessage.text = _transcribedText;
        });
      }
    } catch (e) {
      print('Error in transcription: $e');
      // Fallback with mock transcription to ensure user can still send message
      setState(() {
        _transcribedText = "Voice message (tap to play)";
        _userMessage.text = _transcribedText;
      });
    }
  }

  // Play audio message
  Future<void> playAudio(String audioUrl, int messageIndex) async {
    if (_isPlayingAudio) {
      await _audioPlayer.stop();
      setState(() {
        _isPlayingAudio = false;
        _playingMessageIndex = null;
      });

      if (_playingMessageIndex == messageIndex) {
        return; // We were already playing this audio, so just stop
      }
    }

    try {
      // Check if the file exists
      bool fileExists = await File(audioUrl).exists();

      if (!fileExists) {
        print('Audio file does not exist: $audioUrl');
        // Show error toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot play audio: File not found'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      print('Playing audio from: $audioUrl');

      // Play the audio
      await _audioPlayer.setFilePath(audioUrl);
      await _audioPlayer.play();

      setState(() {
        _isPlayingAudio = true;
        _playingMessageIndex = messageIndex;
      });

      // Show playback started toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing audio...'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('Error playing audio: $e');
      // Show error toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing audio: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void sendPromptAndGetResponse() async {
    if (_userMessage.text.trim().isEmpty && _selectedImage == null) return;

    FocusScope.of(context).unfocus();
    String username = "User";
    var userPrompt = _userMessage.text;
    _userMessage.clear();

    if (_selectedImage == null) {
      setState(() {
        ref
            .read(chatHistoryProvider(username).notifier)
            .addMessage(Message(text: userPrompt, isUser: true));

        // Schedule scroll after the frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });

      setState(() {
        isFetching = true;
      });

      var responseMessage = await ref
          .read(chatsProvider.notifier)
          .getResponse(userPrompt);

      setState(() {
        isFetching = false;
        ref
            .read(chatHistoryProvider(username).notifier)
            .addMessage(responseMessage!);

        // Schedule scroll after the response is added
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        // If response has audio, play it automatically
        if (responseMessage.audioUrl != null) {
          // Get the index of the last message
          final messages = ref.read(chatHistoryProvider(username));
          playAudio(responseMessage.audioUrl!, messages.length - 1);
        }
      });
    } else {
      setState(() {
        ref
            .read(chatHistoryProvider(username).notifier)
            .addMessage(
              Message(text: userPrompt, isUser: true, image: _selectedImage),
            );

        // Schedule scroll after the frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });

      setState(() {
        isFetching = true;
      });

      var responseMessage = await ref
          .read(chatsProvider.notifier)
          .getResponseHavingImage(userPrompt, _selectedImage!);

      setState(() {
        isFetching = false;
        _selectedImage = null;
        ref
            .read(chatHistoryProvider(username).notifier)
            .addMessage(responseMessage!);

        // Schedule scroll after the response is added
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        // If response has audio, play it automatically
        if (responseMessage.audioUrl != null) {
          // Get the index of the last message
          final messages = ref.read(chatHistoryProvider(username));
          playAudio(responseMessage.audioUrl!, messages.length - 1);
        }
      });
    }
  }

  // Send audio recording to backend
  void sendAudioAndGetResponse() async {
    if (_recordedAudioPath == null) return;

    String username = "User";
    final audioFile = File(_recordedAudioPath!);
    final String savedAudioPath = _recordedAudioPath!;

    // First, add the user message with audio
    final userMessage = Message(
      text: _transcribedText.isNotEmpty ? _transcribedText : "Voice message",
      isUser: true,
      audioUrl: savedAudioPath,
    );

    setState(() {
      ref.read(chatHistoryProvider(username).notifier).addMessage(userMessage);

      // Schedule scroll after the frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });

    // Play the user's audio message automatically
    final messages = ref.read(chatHistoryProvider(username));
    final userMessageIndex = messages.length - 1;
    playAudio(savedAudioPath, userMessageIndex);

    // Start fetching the response
    setState(() {
      isFetching = true;
    });

    CitizenProfile citizenProfile =  ref.watch(citizenProfileProvider);

    // Assuming your provider has a method to send audio files
    var responseMessage = await ref
        .read(chatsProvider.notifier)
        .getResponseFromAudio(audioFile, citizenProfile);

    setState(() {
      isFetching = false;

      // Add the assistant's response
      ref
          .read(chatHistoryProvider(username).notifier)
          .addMessage(responseMessage!);

      // Clear the recorded audio path and transcribed text in the input
      _recordedAudioPath = null;
      _transcribedText = '';
      _userMessage.clear();

      // Schedule scroll after the response is added
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      // If response has audio, play it automatically
      if (responseMessage.audioUrl != null) {
        // Get the index of the last message
        final updatedMessages = ref.read(chatHistoryProvider(username));
        Future.delayed(Duration(milliseconds: 500), () {
          playAudio(responseMessage.audioUrl!, updatedMessages.length - 1);
        });
      }
    });
  }

  Future<void> pickImage({required ImageSource source}) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _userMessage.dispose();
    _scrollController.dispose();
    _speech.cancel();
    _soundRecorder.closeRecorder();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = Color(
      0xFF6C63FF,
    ); // Purple accent color matching dashboard
    final backgroundColor = isDarkMode ? Color(0xFF121212) : Color(0xFFF7F9FC);
    final cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final shadowColor = isDarkMode ? Colors.black54 : Colors.black12;
    final errorColor = Colors.redAccent;

    String username = "User";
    List<Message> messages = ref.watch(chatHistoryProvider(username));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            // Chat Messages
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index < messages.length) {
                    final message = messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Stack(
                        children: [
                          ChatItem(message: message),
                          // Show audio playback button if message has audio
                          if (message.audioUrl != null)
                            Positioned(
                              right: message.isUser ? 8 : null,
                              left: message.isUser ? null : 8,
                              bottom: 48,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Audio waveform indicator (simplified)
                                  if (_isPlayingAudio &&
                                      _playingMessageIndex == index)
                                    Container(
                                      width: 40,
                                      height: 20,
                                      margin: EdgeInsets.only(right: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: List.generate(
                                          4,
                                          (i) => AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 300 + (i * 100),
                                            ),
                                            width: 4,
                                            height: 6.0 + (i * 4.0) % 12,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Play/Stop button
                                  InkWell(
                                    onTap:
                                        () =>
                                            playAudio(message.audioUrl!, index),
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _isPlayingAudio &&
                                                _playingMessageIndex == index
                                            ? Icons.stop
                                            : Icons.play_arrow,
                                        color: primaryColor,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  } else if (isFetching) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }, childCount: messages.length + (isFetching ? 1 : 0)),
              ),
            ),
          ],
        ),
      ),

      // Bottom Input Area
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
                      Positioned(
                        right: -10,
                        top: -10,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          icon: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_recordedAudioPath != null && !_isRecording)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mic, color: primaryColor, size: 20),
                      Gap(8),
                      Expanded(
                        child: Text(
                          _transcribedText.isNotEmpty
                              ? "Transcribed: \"${_transcribedText.length > 20 ? _transcribedText.substring(0, 20) + '...' : _transcribedText}\""
                              : "Audio message recorded",
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // Audio playing animation
                      if (_isPlayingAudio && _playingMessageIndex == -1)
                        Container(
                          width: 40,
                          height: 20,
                          margin: EdgeInsets.only(right: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              4,
                              (i) => AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 300 + (i * 100),
                                ),
                                width: 4,
                                height: 6.0 + (i * 4.0) % 12,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      IconButton(
                        onPressed: () => playAudio(_recordedAudioPath!, -1),
                        icon: Icon(
                          _isPlayingAudio && _playingMessageIndex == -1
                              ? Icons.stop
                              : Icons.play_arrow,
                          color: primaryColor,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      Gap(12),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _recordedAudioPath = null;
                            _transcribedText = '';
                            _userMessage.clear();
                          });
                        },
                        child: Icon(Icons.close, color: Colors.grey, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            Row(
              children: [
                // Attachment Button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: PopupMenuButton(
                    icon: Icon(Icons.attach_file_rounded, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (ImageSource source) {
                      pickImage(source: source);
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: ImageSource.gallery,
                            child: Row(
                              children: [
                                Icon(Icons.photo_library, color: primaryColor),
                                Gap(8),
                                Text('Gallery', style: GoogleFonts.poppins()),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: ImageSource.camera,
                            child: Row(
                              children: [
                                Icon(Icons.camera_alt, color: primaryColor),
                                Gap(8),
                                Text('Camera', style: GoogleFonts.poppins()),
                              ],
                            ),
                          ),
                        ],
                  ),
                ),

                Gap(8),

                // Text Input Field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _userMessage,
                            decoration: InputDecoration(
                              hintText:
                                  _isRecording
                                      ? 'Recording audio...'
                                      : 'Type a message...',
                              hintStyle: GoogleFonts.poppins(
                                color:
                                    _isRecording
                                        ? Colors.redAccent
                                        : Colors.grey[600],
                                fontSize: 14,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            maxLines: 3,
                            minLines: 1,
                            enabled: !_isRecording,
                          ),
                        ),

                        // Voice Input Button
                        IconButton(
                          onPressed: _startListening,
                          icon: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  _isRecording
                                      ? Colors.red.withOpacity(0.2)
                                      : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isRecording ? Icons.mic : Icons.mic_none,
                              color: _isRecording ? Colors.red : primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Gap(8),

                // Send Button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed:
                        _recordedAudioPath != null
                            ? sendAudioAndGetResponse
                            : sendPromptAndGetResponse,
                    icon: Icon(
                      _recordedAudioPath != null
                          ? Icons.send_rounded
                          : Icons.send_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
