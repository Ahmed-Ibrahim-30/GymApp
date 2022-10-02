import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/tuple.dart';
import 'dart:async';
import 'package:gym_project/widget/global.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageUploadWebService {
  final String local = Constants.defaultUrl;
  String token = Global.token;
  Future<Tuple<bool, String>> uploadImage(XFile image, String imageName) async {
    // var formData = FormData.fromMap({
    //   "image": await MultipartFile.fromFile(
    //     image.path,
    //     filename: imageName,
    //   ),
    // });
    Tuple<bool, String> result = Tuple();
    var savedImage;
    if (kIsWeb) {
      savedImage = Image.network(image.path);
    } else {
      savedImage = Image.file(File(image.path));
    }

    // var stream = new http.ByteStream(StreamView(image.openRead()));
    var length = await image.length();

    print('sending request');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '$local/api/upload-image',
      ),
    );
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
        'image',
        image.readAsBytes().asStream(),
        length,
        filename: imageName,
      ),
    );

    request.headers.addAll(headers);

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      result.item1 = true;
      result.item2 = json.decode(response.body)['image'];
      print(result.item2);
      return result;
    } else {
      throw Exception(response.body);
    }
  }
}
