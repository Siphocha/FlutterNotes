# FlutterNotes
SO this app is about a flutter notes taking app. BUT firebase integrations are in STORE because we'll be using FIRESTORE.

Working it:
cd FlutterNotes

Install dependencies "flutter pub get"

Firebase Setup (yk)

Create a Firebase project at console.firebase.google.com

Enable Authentication Specifically with Email/Password option.

Enable Cloud Firestore (also add a user collection)

Add Android/iOS to the Firebase project (or just one if thats your prefered device)

Download google-services.json (for Android) and/or GoogleService-Info.plist (for iOS) into the appropriate folders

In terminal run "flutter configure"

Then run the app using "flutter run"