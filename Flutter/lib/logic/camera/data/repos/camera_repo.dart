import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mini_robo/logic/camera/data/models/ai_response.dart';
import '../../../../core/networking/http_service.dart';

class CameraRepo {
  final HttpService apiService;
  CameraRepo(this.apiService);

  Future<Uint8List> compressImage(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 800,
      minHeight: 800,
      quality: 80,
      format: CompressFormat.jpeg,
    );
    return result!;
  }

  Future<bool> register(String name, File imageFile) async {
    try {
      final bytes = await compressImage(imageFile);

      final response = await apiService.sendAiRequest(mode: name, body: bytes);
      return response.statusCode == 200;
    } on Exception catch (e) {
      debugPrint("Register Error: $e");
      return false;
    }
  }

  Future<String?> getDetectedName(String mode) async {
    try {
      final response = await apiService.sendAiRequest(mode: mode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return data['name'];
      } else {
        return "Unknown";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> activateMode(String mode) async {
    try {
      String modeChar;
      if (mode == "face") {
        modeChar = "F";
      } else if (mode == "object") {
        modeChar = "O";
      } else if (mode == "dance") {
        modeChar = "D";
      } else if (mode == "greeting") {
        modeChar = "G";
      } else {
        modeChar = "R";
      }
      //send mode to ai
      final response = await apiService.sendAiRequest(mode: modeChar);
      //send mode to iot
      // await apiService.sendCommand(
      //   "${ApiConstants.iotBaseUrl}/set_mode?m=$modeChar",
      // );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<AiResponse?> getDetectedResult(String mode) async {
    try {
      final response = await apiService.sendAiRequest(mode: mode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AiResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

   Future<bool> info(String mode) async {
    try {
      //send mode to ai 
      final response = await apiService.sendAiRequest(mode: mode);
      //send mode to iot
      await apiService.sendCommand(mode);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
