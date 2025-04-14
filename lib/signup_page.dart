import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'genshin_main.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // user cancelled sign-in

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // success
      final user = FirebaseAuth.instance.currentUser;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signed in as ${user?.displayName}'),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const genshinMain()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up with Google")),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Sign Up with Google"),
          onPressed: () => _signInWithGoogle(context),
        ),
      ),
    );
  }
}
