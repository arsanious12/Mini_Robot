import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:mini_robo/core/networking/api_constants.dart';

class HttpService {
  final http.Client client = http.Client();

  Future<http.Response> sendAiRequest({
    required String mode,
    dynamic body,
  }) async {
    final url = Uri.parse(ApiConstants.aiBaseUrl);
    // if (body != null) {}

    final headers = {
      'mode': mode,
      'Content-Type': body != null ? 'image/jpeg' : 'application/json',
    };

    var temp = await client
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 60));
    log("Sent to AI: $mode");

    return temp;
  }

  Future<void> sendCommand(String url) async {
    try {
      log("sending: $url");
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        log("Command $url sent successfully!");
      }
    } catch (e) {
      log("Error sending command: $e");
    }
  }

  void startDancing() => sendCommand(ApiConstants.aiBaseUrl);

  void startGreeting() => sendCommand(ApiConstants.aiBaseUrl);
}
