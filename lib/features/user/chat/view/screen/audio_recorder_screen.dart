import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:upi_pay/features/user/chat/provider/audio_service.dart';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({Key? key}) : super(key: key);

  @override
  State<AudioRecorderScreen> createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  final _audioService = AudioService();
  
  bool _isRecording = false;
  String? _recordedFilePath;
  String? _responseText;
  String? _responseAudioPath;
  bool _isLoading = false;
  bool _isPlayingResponse = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      // Request microphone permissions
      if (await _audioRecorder.hasPermission()) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String filePath = '${appDocDir.path}/audio_recording_$timestamp.aac';

        // Configure audio recording settings
        await _audioRecorder.start(
          RecordConfig(
            encoder: AudioEncoder.aacLc, // AAC codec for better compatibility
            bitRate: 128000, // 128 kbps
            sampleRate: 44100, // 44.1 kHz
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
          _recordedFilePath = filePath;
          _responseText = null;
          _responseAudioPath = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission not granted')),
        );
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start recording: $e')),
      );
    }
  }

  Future<void> _stopRecordingAndProcess() async {
    try {
      if (!_isRecording) return;
      
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _isLoading = true;
      });

      if (path != null) {
        await _processRecording(File(path));
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      setState(() {
        _isRecording = false;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop recording: $e')),
      );
    }
  }

  Future<void> _processRecording(File audioFile) async {
    try {
      final response = await _audioService.sendAudioAndGetResponse(audioFile);
      
      setState(() {
        _responseText = response['text'];
        _responseAudioPath = response['audioPath'];
        _isLoading = false;
      });

      // Automatically play the response audio if available
      if (response['success'] && response['audioPath'] != null) {
        _playResponseAudio();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseText = "Error processing recording: $e";
      });
    }
  }

  Future<void> _playResponseAudio() async {
    if (_responseAudioPath == null) return;
    
    try {
      setState(() {
        _isPlayingResponse = true;
      });
      
      // Configure audio player
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
      await _audioPlayer.setSource(DeviceFileSource(_responseAudioPath!));
      
      // Play the audio
      await _audioPlayer.resume();
      
      // Listen for playback completion
      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          _isPlayingResponse = false;
        });
      });
    } catch (e) {
      debugPrint('Error playing response audio: $e');
      setState(() {
        _isPlayingResponse = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play response audio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Chat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status text
            if (_isRecording)
              const Text(
                'Recording in progress...',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              
            // Response display
            if (_responseText != null && !_isLoading)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Response:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _responseText!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        
                        // Audio controls if response audio is available
                        if (_responseAudioPath != null) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _isPlayingResponse ? null : _playResponseAudio,
                            icon: Icon(_isPlayingResponse ? Icons.stop : Icons.volume_up),
                            label: Text(_isPlayingResponse ? 'Playing...' : 'Play Response'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              
            // Loading indicator
            if (_isLoading)
              Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Processing your audio...'),
                ],
              ),
              
            const Spacer(),
            
            // Microphone button
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: GestureDetector(
                onTapDown: (_) => _isLoading ? null : _startRecording(),
                onTapUp: (_) => _isLoading ? null : _stopRecordingAndProcess(),
                onTapCancel: () => _isLoading ? null : _stopRecordingAndProcess(),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            
            const Text(
              'Press and hold to record',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}