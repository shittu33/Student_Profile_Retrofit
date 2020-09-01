## Student Profile Retrofit

A Flutter App that perform CRUD operations with Cloud Firestore and Storage Using Rest API (No Firebase SDKs) Using Bloc pattern

## Overview
The app basicly Read,Write,Update and delete Student information details including their profile picture online using Google Cloud Firestore and Storage Rest API.

## Moltivation
You might wonder why i didn't use Firebase SDKs instead? well!! while experimenting Firebase Storage on web, i found out that Firebase Storage is not yet officially supported on web, so that inspire me to think of a way to get all the job done without the sdk. Moreover the Firebase SDK will unnecessarily make my Apk size larger than usual in a case where i just need to query or perform a very simple operation on Firestore or Storage like this. its wiser to just use the Api.

## Advantage of Using REST API for Authenntication,Firestore and Cloud Storage
* Accessing Cloud Storage from a resource-constrained environment, such as Flutter Web. 
* Read and write Firestore documents data with full admin privileges.
* Create your own simplified admin console to do things like look up user data or change a user's email address for authentication.
* Generate and verify Firebase auth tokens.
* Programmatically send Firebase Cloud Messaging messages using a simple, alternative approach to the Firebase Cloud Messaging server protocols.


### App Demo
 ![Demo](url)

## Technologies
**This project was created with:**
* Cloud Firestore REST API
* Cloud Storage JSON API
* Google Identity OAuth 2.0 (to access data from Cloud Storage & Firestore with full admin privileges)

**I used following SDK:**
* Flutter SDK

**I used following main packages:**
* retrofit
* retrofit_generator: any
* build_runner: any
* json_serializable:
* image_picker:
* googleapis_auth:

## Pattern
* Bloc pattern

## Download
**To get this application :**


## Features
* Read,Write,delete Student details to cloud firestore
* Read,write,delete each student profile picture to Cloud Storage
* Colapsed toolBar and TabBar for populating Student details

## Setup
* Clone the repository
* run pub get command
* Login to your Firebase console/ create a new project,create firestore database(If you don't want to use Firebase Auth REST API or Google Identity OAuth 2.0 you should allow  read and write, but as for this project i used OAuth 2.0, so you don't have to allow read or wite).
* Navigate to the settings icon on your project Overview menu>>project setting>>General tab>> Your project>> web API key, and copy the key(weare going to use it later)
* Navigate to the settings icon on your project Overview menu>>project setting>>Service Account tab>> Firebase Admin SDK>> at the buttom you will see a 
  button(Generate new Private Key) click to download your credential,after download, open the file and copy the required values requested in the next step.
* inside the /lib folder create a file named config.dart and place the following code:
``` Dart
const API_KEY = "<<Your API KEY THAT YOU HAVE JUST COPIED ON STEP 4>>";
const PROJECT_NAME = "<<Ypur project Name ON FIREBASE>>";
const BUCKET_NAME = "<<Your firebase bucket name(e.g your-project-name.appspot.com)>>";
get jsonCredentials => <String, String>{
      "private_key_id": "<<Your privateKey id (FOUND ON THE DOWNLOADED FILE)>>",
      "private_key":<<YOUR OWN PRIVATE KEY (FOUND ON THE DOWNLOADED FILE)>>",
      "client_email":
          "<<THE EMAIL ON THE DOWNLOADED FILE >>",
      "client_id": "<<THE CLIENT_ID ON THE DOWNLOADED FILE>>",
      "type": "service_account"
    };
```
* After that just go to your terminal and type this command: 
```cmd
flutter pub run build_runner build
```
* If everything goes fine, you can now build and explore the project more!!!

## TODO
In this sample i used Google Identity OAuth 2.0 to gain full admin priviledges, in my next sample i will be using Firebase Auth REST API to authenticate user and generate Firebase ID tokens to send authenticated requests as an individual user, and limiting access with Firestore Rules on the client side.

