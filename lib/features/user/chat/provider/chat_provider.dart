import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_pay/core/utils/base_url.dart';
import 'package:upi_pay/features/user/chat/model/message.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_profile.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ChatsNotifier extends StateNotifier<List<dynamic>> {
  ChatsNotifier() : super([]);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Message?> getResponse(String prompt) async {
    try {
      log('in get response');
      _isLoading = true;
      state = [...state];
      String url = '';

      Map<String, String> body = {"type": "text", "message": prompt};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      String password = prefs.getString('password') ?? '';

      final header = <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: header,
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        String textResponse = jsonResponse['text'] ?? "No response";
        String? audioUrl = jsonResponse['audio_url']; // May be null

        String localAudioPath = "";
        if (audioUrl != null && audioUrl.isNotEmpty) {
          localAudioPath = await _downloadAudio(audioUrl);
        }

        return Message(
          text: textResponse,
          isUser: false,
          audioUrl: localAudioPath.isNotEmpty ? localAudioPath : null,
        );
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Message?> getResponseHavingImage(String prompt, File file) async {
    try {
      _isLoading = true;
      state = [...state];
      String url = '';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      String password = prefs.getString('password') ?? '';

      final header = <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
        'Content-Type': 'multipart/form-data',
      };

      var request =
          http.MultipartRequest('POST', Uri.parse(url))
            ..headers.addAll(header)
            ..fields['message'] = prompt
            ..fields['type'] = 'media'
            ..files.add(await http.MultipartFile.fromPath('media', file.path));

      var response = await request.send();
      log('got response');

      if (response.statusCode == 200) {
        var data = json.decode(await response.stream.bytesToString());
        final result = data['response'];
        log(result);

        final chat = Message(text: result, isUser: false);

        state = [...state, chat];
        _isLoading = false;
        state = [...state];
        return chat;
      } else {
        var data = json.decode(await response.stream.bytesToString());
        final result = data['response'];
        log(result);
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Add this method to your existing ChatProvider class

 Future<Message?> getResponseFromAudio(File audioFile, CitizenProfile citizenProfile) async {
  try {
    log("in get response from audio");
    
    // First validate that the audio file exists
    if (!await audioFile.exists()) {
      log("Error: Audio file doesn't exist at path: ${audioFile.path}");
      return Message(
        text: "Sorry, I couldn't find the recorded audio file.",
        isUser: false,
      );
    }
    
    // Log file details
    log("Audio file path: ${audioFile.path}");
    log("Audio file size: ${await audioFile.length()} bytes");
    
    var uri = Uri.parse('$baseUrl/api/v1/chat');
    var request = http.MultipartRequest('POST', uri);

    Map<String, String> body = {
      "name": citizenProfile.accountInfo.name,
      "age": citizenProfile.personalInfo.dob.toString(),
      "location": citizenProfile.personalInfo.address,
      "interest": citizenProfile.personalInfo.occupation,
    };

    // Add the body as a JSON with id "user_profile"
    request.fields['user_profile'] = json.encode(body);

    // Create a local copy of the file in a more reliable location
    final appDocDir = await getApplicationDocumentsDirectory();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String newPath = '${appDocDir.path}/audio_upload_$timestamp.aac';
    
    // Copy file to new location
    final File newAudioFile = await audioFile.copy(newPath);
    log("Copied audio file to: $newPath");
    
    // Add the audio file with explicit content type
    var stream = http.ByteStream(newAudioFile.openRead());
    var length = await newAudioFile.length();
    
    var multipartFile = http.MultipartFile(
      'file', 
      stream, 
      length,
      filename: path.basename(newPath),
      contentType: MediaType('audio', 'aac'),  // Set proper MIME type based on your audio format
    );
    
    request.files.add(multipartFile);

    // Add headers if needed (often required for authentication)
    request.headers['Accept'] = 'application/json';
    // Add any authentication headers if required
    // request.headers['Authorization'] = 'Bearer your_token_here';

    // Send the request with autofollow redirects
    var client = http.Client();
    try {
      log("Sending request to: $uri");
      // Send the request and follow redirects manually
      var streamedResponse = await client.send(request);
      
      // Follow redirects manually
      int redirectCount = 0;
      final int maxRedirects = 5;
      
      while ((streamedResponse.statusCode == 307 || 
             streamedResponse.statusCode == 301 ||
             streamedResponse.statusCode == 302 ||
             streamedResponse.statusCode == 303) && 
             redirectCount < maxRedirects) {
        
        redirectCount++;
        log("Redirect #$redirectCount: Status code ${streamedResponse.statusCode}");
        
        // Get the redirect location
        String? location = streamedResponse.headers['location'];
        if (location == null) {
          log("No location header in redirect response");
          break;  // No location header, can't redirect
        }
        
        log("Redirecting to: $location");
        
        // Create a new request to the redirected URL
        var redirectUri = Uri.parse(location);
        var redirectRequest = http.MultipartRequest('POST', redirectUri);
        
        // Copy fields and files from original request
        redirectRequest.fields.addAll(request.fields);
        
        // Re-add the file for the redirect
        var newStream = http.ByteStream(newAudioFile.openRead());
        var newLength = await newAudioFile.length();
        
        var newMultipartFile = http.MultipartFile(
          'file', 
          newStream, 
          newLength,
          filename: path.basename(newPath),
          contentType: MediaType('audio', 'aac'),
        );
        
        redirectRequest.files.add(newMultipartFile);
        
        // Copy headers
        redirectRequest.headers.addAll(request.headers);
        
        // Send the redirected request
        streamedResponse = await client.send(redirectRequest);
      }
      
      log("Final response status code: ${streamedResponse.statusCode}");
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse the response
        var jsonResponse = json.decode(response.body);
        log("Received response: ${response.body}");

        // Assuming your API returns text response and MP3 URL
        String textResponse = jsonResponse['text'] ?? "No text response";
        String audioUrl = jsonResponse['file'] ?? "";

        // Download the audio file to local storage if it's a URL
        String localAudioPath = "";
        if (audioUrl.isNotEmpty) {
          localAudioPath = await _downloadAudio(audioUrl);
        }

        return Message(
          text: textResponse,
          isUser: false,
          audioUrl: localAudioPath.isNotEmpty ? localAudioPath : null,
        );
      } else {
        log('Failed to get response: ${response.statusCode}, Body: ${response.body}');
        return Message(
          text: "Sorry, I couldn't process your audio message. Server responded with ${response.statusCode}",
          isUser: false,
        );
      }
    } finally {
      client.close();
    }
  } catch (e, stackTrace) {
    log('Error sending audio: $e');
    log('Stack trace: $stackTrace');
    return Message(
      text: "Sorry, there was an error processing your audio message: ${e.toString()}",
      isUser: false,
    );
  }
}

// Add these imports at the top of your file if not already present:
// import 'dart:io';
// import 'package:http_parser/http_parser.dart';
// import 'package:path/path.dart' as path;


  // Helper method to download audio to local storage
  Future<String> _downloadAudio(String url) async {
    try {
      // Get temporary directory
      var tempDir = await getTemporaryDirectory();
      String filePath =
          '${tempDir.path}/response_${DateTime.now().millisecondsSinceEpoch}.mp3';

      // Download the file
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        log('Failed to download audio: ${response.statusCode}');
        return "";
      }
    } catch (e) {
      log('Error downloading audio: $e');
      return "";
    }
  }
}

final chatsProvider = StateNotifierProvider<ChatsNotifier, List<dynamic>>(
  (ref) => ChatsNotifier(),
);
