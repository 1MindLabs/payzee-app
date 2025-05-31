import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:upi_pay/core/utils/base_url.dart';

class AudioService {
  // Update this with your actual base URL

  // Mock user profile for testing
  final Map<String, String> mockUserProfile = {
    "name": "Test User",
    "age": "1990-01-01",
    "location": "Test Location",
    "interest": "Testing",
  };

  // Function to send audio to backend and get response
  Future<Map<String, dynamic>> sendAudioAndGetResponse(File audioFile) async {
    try {
      debugPrint("Sending audio file: ${audioFile.path}");

      // First validate that the audio file exists
      if (!await audioFile.exists()) {
        debugPrint(
          "Error: Audio file doesn't exist at path: ${audioFile.path}",
        );
        return {
          "success": false,
          "text": "Sorry, I couldn't find the recorded audio file.",
          "audioPath": null,
        };
      }

      // Log file details
      debugPrint("Audio file size: ${await audioFile.length()} bytes");

      var uri = Uri.parse('$baseUrl/api/v1/chatbot/');
      var request = http.MultipartRequest('POST', uri);

      // Add the user profile as a JSON field
      request.fields['user_profile_json'] = json.encode(mockUserProfile);

      // Add the audio file with explicit content type
      var stream = http.ByteStream(audioFile.openRead());
      var length = await audioFile.length();

      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: path.basename(audioFile.path),
        contentType: MediaType('audio', 'aac'),
      );

      request.files.add(multipartFile);

      // Add headers
      request.headers['Accept'] = 'application/json';

      // Send the request
      debugPrint("Sending request to: $uri");
      var response = await request.send();
      var httpResponse = await http.Response.fromStream(response);

      debugPrint("Response status: ${httpResponse.statusCode}");

      if (httpResponse.statusCode == 200) {
        // Parse the response
        if (httpResponse.headers['content-type']?.contains(
              'application/json',
            ) ??
            false) {
          var jsonResponse = json.decode(httpResponse.body);
          debugPrint("Received JSON response: ${httpResponse.body}");

          String textResponse = jsonResponse['text'] ?? "No text response";
          log("textResponse: $textResponse");
          String audioUrl = jsonResponse['file'] ?? "";

          String localAudioPath = "";
          if (audioUrl.isNotEmpty) {
            localAudioPath = await _downloadAudio(audioUrl);
          }

          return {
            "success": true,
            "text": textResponse,
            "audioPath": localAudioPath.isNotEmpty ? localAudioPath : null,
          };
        } else {
          debugPrint("Non-JSON response detected. Saving response as audio.");

          final appDocDir = await getApplicationDocumentsDirectory();
          final String timestamp =
              DateTime.now().millisecondsSinceEpoch.toString();
          final String filePath =
              '${appDocDir.path}/audio_response_$timestamp.aac';

          final file = File(filePath);
          await file.writeAsBytes(httpResponse.bodyBytes);

          return {
            "success": true,
            "text": "Audio received successfully.",
            "audioPath": filePath,
          };
        }
      } else {
        debugPrint(
          'Failed to get response: ${httpResponse.statusCode}, Body: ${httpResponse.body}',
        );
        return {
          "success": false,
          "text":
              "Sorry, I couldn't process your audio message. Server responded with ${httpResponse.statusCode}",
          "audioPath": null,
        };
      }
    } catch (e, stackTrace) {
      debugPrint('Error sending audio: $e');
      debugPrint('Stack trace: $stackTrace');
      return {
        "success": false,
        "text":
            "Sorry, there was an error processing your audio message: ${e.toString()}",
        "audioPath": null,
      };
    }
  }

  // Helper method to download audio file from URL
  Future<String> _downloadAudio(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final String timestamp =
            DateTime.now().millisecondsSinceEpoch.toString();
        final String filePath =
            '${appDocDir.path}/audio_response_$timestamp.mp3';

        // Write the response bytes to a file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        debugPrint("Downloaded audio to: $filePath");
        return filePath;
      } else {
        debugPrint('Failed to download audio: ${response.statusCode}');
        return "";
      }
    } catch (e) {
      debugPrint('Error downloading audio: $e');
      return "";
    }
  }
}
