import 'dart:math';
import 'dart:typed_data';
import 'package:studentprofileretrofit/helper/GoogleAPIHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentprofileretrofit/config.dart';

import 'helper/GoogleAPIHelper.dart';

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
    var img = "f913fbef-4a72-4b2f-b035-d4767cfcb3a4.jpg";
    return ListView(
      children: [
        Image.memory(imgByte /*,height: 100,width: 100,*/),
//        Image.network(getFirebaseDownloadUrl(BUCKET_NAME, img)),
        RaisedButton(
            child: Text("Upload"),
            onPressed: () async {
              await _picker
                  .getImage(source: ImageSource.gallery)
                  .then((pickedFile) async {
                updateImage(pickedFile);
                var uniquePath =
                    uniqueStoragePath(imgPath, folder: "student_img");
                print(uniquePath);
                var response = await uploadByteToGoogleCloud(
                    BUCKET_NAME, uniquePath, await pickedFile.readAsBytes());
                if (response.statusCode == 200) {
                  print("Image Uploaded!!");
                  print(uniquePath);
                  readGoogleCloudImage(BUCKET_NAME, uniquePath).then((imgByte) {
                    setState(() {
                      this.imgByte = imgByte;
                      print("image loaded!!");
                    });
                  });
                }
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
}
