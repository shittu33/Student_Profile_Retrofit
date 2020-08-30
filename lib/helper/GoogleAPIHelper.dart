import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path/path.dart';
import '../config.dart';

getGoogleCloudUploadUrl(String bucketName, String imgPath) {
  return 'https://storage.googleapis.com/upload/storage/v1/b/$bucketName/o?uploadType=media&name=$imgPath';
}

getGoogleCloudDownloadUrl(String bucketName, String imgPath) {
  var encodedImagePath = Uri.encodeQueryComponent(imgPath);
  return 'https://storage.googleapis.com/storage/v1/b/$bucketName/o/$encodedImagePath?alt=media';
}

getCloudDeleteUrl(String bucketName, String imgPath) {
  var encodedImagePath = Uri.encodeQueryComponent(imgPath);
//  var imageName = imgPath.contains("/") ? basename(imgPath) : imgPath;
  return 'https://storage.googleapis.com/storage/v1/b/$bucketName/o/$encodedImagePath';
}

getFirebaseDownloadUrl(String bucketName, String imgPath) {
  var encodedImagePath = Uri.encodeQueryComponent(imgPath);
  return "https://firebasestorage.googleapis.com/v0/b/$bucketName/o/$encodedImagePath?alt=media";
}

extractPathFromFirebaseUrl(
  String firebaseStorageUrl,
) {
  String raw = basename(firebaseStorageUrl).split("?").first;
//  return raw;
  return Uri.decodeComponent(raw);
}

Future<String> getAccessToken() async {
  var client = http.Client();
  var accountCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);
  var scopes = [
    'https://www.googleapis.com/auth/cloud-platform',
  ];
  AccessCredentials credentials =
      await obtainAccessCredentialsViaServiceAccount(
          accountCredentials, scopes, client);
  client.close();
  return credentials.accessToken.data;
}

Future<Uint8List> readGoogleCloudImage(
  String bucketName,
  String imagePath,
) async {
//    var imagePath = 'images/fe3fc2b5-4e8f-4d00-9c51-a32b50a86e0d.jpg';
//  var encodedImagePath = Uri.encodeQueryComponent(imagePath);
  var uri = Uri.parse(getGoogleCloudDownloadUrl(bucketName, imagePath));
  String accessToken = await getAccessToken();
//  client.close();
  return http.readBytes(uri, headers: <String, String>{
    'Authorization': "Bearer $accessToken",
  });
}

Future<http.Response> uploadByteToGoogleCloud(
    String bucketName, String imgPath, Uint8List byteData) async {
  String accessToken = await getAccessToken();
  var uri = Uri.parse(getGoogleCloudUploadUrl(bucketName, imgPath));
  return await http.post(uri,
      headers: <String, String>{
        'Authorization': "Bearer $accessToken",
        'Content-Type': "image/jpeg"
      },
      body: byteData);
}

Future<http.Response> deleteImageFromGoogleCloud(
    String bucketName, String firebaseStorageUrl) async {
  String accessToken = await getAccessToken();
  var storagePath = extractPathFromFirebaseUrl(
    firebaseStorageUrl,
  );
  print("Delete path is $storagePath");
  var deleteCloudUrl = getCloudDeleteUrl(bucketName, storagePath);
  print("Delete Url is $deleteCloudUrl");
  var uri = Uri.parse(deleteCloudUrl);
  return await http.delete(
    uri,
    headers: <String, String>{
      'Authorization': "Bearer $accessToken",
//      'Content-Type': "image/jpeg"
    },
  );
}

isPathUrl(String path) {
  var urlPattern =
      r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  var firstMatch = new RegExp(urlPattern, caseSensitive: false);
  return path.contains(firstMatch);
}

String uniqueStoragePath(String path, {String folder}) {
  return "${folder != null ? "$folder/" : ""}${path.split("/").last}-${Random().nextInt(3243539)}.jpg";
}
