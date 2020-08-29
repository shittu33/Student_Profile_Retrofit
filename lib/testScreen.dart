import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:studentprofileretrofit/config.dart';

class ImageTestScreen extends StatefulWidget {
  @override
  _ImageTestScreenState createState() => _ImageTestScreenState();
}

class _ImageTestScreenState extends State<ImageTestScreen> {
  String imgPath = "fff";
  final _picker = ImagePicker();
  PickedFile pickedFile;
  Uint8List imgByte = Uint8List(235);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.memory(imgByte),
        RaisedButton(
            child: Text("Upload"),
            onPressed: () async {
//              readImage().then((imgByte) {
//                setState(() {
//                  this.imgByte = imgByte;
//                  print("image loaded!!");
//                });
//              });
              await _picker
                  .getImage(source: ImageSource.gallery)
                  .then((pickedFile) {
                updateImage(pickedFile);
//          if (!kIsWeb) {
                uploadFile();
//          }
              });
            })
      ],
    );
  }

  void updateImage(PickedFile pickedFile) {
    setState(() {
      imgPath = pickedFile.path;
      this.pickedFile = pickedFile;
      pickedFile.readAsBytes().then((value) => this.imgByte = value);
    });
  }

  Future<Uint8List> readImage(String imagePath) async {
//    var imagePath = 'images/fe3fc2b5-4e8f-4d00-9c51-a32b50a86e0d.jpg';
    var encodedImagePath = Uri.encodeQueryComponent(imagePath);
    var uri = Uri.parse(
        'https://www.googleapis.com/storage/v1/b/$BUCKET_NAME/o/$encodedImagePath?alt=media');
    var client = http.Client();
    String accessToken = await getAccessToken(client);
    client.close();
    return http.readBytes(uri, headers: <String, String>{
      'Authorization': "Bearer $accessToken",
    });
  }

  Future<void> uploadFile() async {
    var client = http.Client();
    String accessToken = await getAccessToken(client);
    imgPath = "images/${imgPath.split("/").last}.jpg";
    var uri = Uri.parse(
        'https://www.googleapis.com/upload/storage/v1/b/$BUCKET_NAME/o?uploadType=media&name=$imgPath');
    await http
        .post(uri,
            headers: <String, String>{
              'Authorization': "Bearer $accessToken",
              'Content-Type': "image/jpeg"
            },
            body: await pickedFile.readAsBytes())
        .then((response) {
      print("Response code is ${response.statusCode}");
    });
    client.close();
    readImage(imgPath).then((imgByte) {
      setState(() {
        this.imgByte = imgByte;
        print("image loaded!!");
      });
    });
  }

  Future<String> getAccessToken(http.Client client) async {
    var accountCredentials =
        ServiceAccountCredentials.fromJson(jsonCredentials);

    var scopes = [
      'https://www.googleapis.com/auth/cloud-platform',
    ];
    AccessCredentials credentials =
        await obtainAccessCredentialsViaServiceAccount(
            accountCredentials, scopes, client);
    return credentials.accessToken.data;
  }
}
