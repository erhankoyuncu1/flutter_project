import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project/services/app_functions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "demwg7jpa";
  final String apiKey = "667216815962736";
  final String apiSecret = "RcUYs7431iNSD8l8zS1K6LSj0Kg";

  Future<String?> uploadImage(File imageFile) async {
    final url =
    Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'public'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      final url = jsonMap['secure_url'];
      return url;
    } else {
        Fluttertoast.showToast(msg:       "Error uploading image: ${response.statusCode}");

      return null;
    }
  }
}
