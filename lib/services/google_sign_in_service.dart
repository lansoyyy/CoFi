import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential?> signInWithGoogle({bool forceAccountSelection = false}) async {
    try {
      // Trigger the authentication flow
      GoogleSignInAccount? googleUser;
      
      if (forceAccountSelection) {
        // Force account selection by signing out first
        await _googleSignIn.signOut();
        // Then sign in with forced account selection
        googleUser = await _googleSignIn.signIn();
      } else {
        // Normal sign in flow
        googleUser = await _googleSignIn.signIn();
      }

      // Return null if user cancels the sign-in flow
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Create or update user data in Firestore
      await _createOrUpdateUser(userCredential.user!);

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  static Future<void> _createOrUpdateUser(User user) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Check if user already exists
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // Create new user document
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL,
        'commitment': false,
        'address': '',
        'bookmarks': [],
        'visited': [],
        'reviews': [],
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Update last login time for existing user
      await userDoc.update({
        'lastLoginAt': FieldValue.serverTimestamp(),
        'displayName': user.displayName,
        'photoUrl': user.photoURL,
      });
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
