# Google Sign-In Setup Guide

## Prerequisites
1. Firebase project set up with Android app
2. SHA-1 certificate fingerprint registered in Firebase Console

## Setup Instructions

### 1. Enable Google Sign-In in Firebase Console
1. Go to your Firebase Console
2. Select your project
3. Navigate to Authentication > Sign-in method
4. Enable Google sign-in provider

### 2. Configure OAuth Consent Screen (for Google Cloud)
1. Go to Google Cloud Console
2. Select your project
3. Navigate to APIs & Services > OAuth consent screen
4. Configure the consent screen with your app information

### 3. Add SHA-1 Fingerprint (if not already added)
1. Get your SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
2. Add it to your Firebase project:
   - Firebase Console > Project Settings > General
   - Scroll to "Your apps" section
   - Click on your Android app
   - Add the SHA-1 fingerprint

### 4. Test Google Sign-In
1. Run the app on an Android device or emulator
2. Tap on "Continue with Google" button on landing or login screen
3. Select a Google account to sign in

## Troubleshooting

### Common Issues:
1. **"Developer error" or "Config failed"**: Check that SHA-1 fingerprint is correctly added to Firebase
2. **"Google Play Services not available"**: Ensure Google Play Services is installed on the device/emulator
3. **"API not enabled"**: Make sure Google Sign-In is enabled in Firebase Authentication

### Debugging Tips:
1. Check Android logs for detailed error messages:
   ```bash
   adb logcat
   ```
2. Verify Google Services configuration file (`google-services.json`) is in the correct location:
   - Should be at `android/app/google-services.json`

## Code Implementation Details

The Google Sign-In implementation is located in:
- `lib/services/google_sign_in_service.dart`: Main service handling Google authentication
- `lib/screens/auth/landing_screen.dart`: Landing screen with Google Sign-In button
- `lib/screens/auth/login_screen.dart`: Login screen with Google Sign-In button

The implementation follows Firebase Authentication best practices and automatically creates user records in Firestore upon first sign-in.