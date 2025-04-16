import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    const borderColor = Color(0xFFD7F300);
    const bgColor = Color(0xFF161616);
    const textColor = Color(0xFFEFEdfa);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/images/zzzback.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(color: borderColor, width: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        width: 320,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTextField(
                              controller: emailController,
                              hint: 'Email',
                              textColor: textColor,
                              borderColor: borderColor,
                              fillColor: bgColor,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: passwordController,
                              hint: 'Password',
                              obscureText: true,
                              textColor: textColor,
                              borderColor: borderColor,
                              fillColor: bgColor,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: ()async {
                            final email = emailController.text.trim();
                            final password = passwordController.text;

                            try {
                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(email: email, password: password);

                            print('User signed up: ${userCredential.user?.uid}');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const genshinMain()),
                            );
                            } on FirebaseAuthException catch (e) {
                            String message;
                            if (e.code == 'email-already-in-use') {
                            message = 'This email is already in use.';
                            final loginCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(email: email, password: password);

                            print('User logged in: ${loginCredential.user?.uid}');

                            // ✅ Navigate after successful login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const genshinMain()),
                            );
                            } else if (e.code == 'weak-password') {
                            message = 'The password provided is too weak.';
                            } else if (e.code == 'invalid-email') {
                            message = 'Invalid email address.';
                            } else {
                            message = 'An error occurred. Please try again.';
                            }

                            print('Signup error: $message');
                            // Optionally show a snackbar or dialog with the error
                            }
                            },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: borderColor,
                                foregroundColor: bgColor,
                              ),
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text("OR",style: TextStyle(color: Color(0xFFbbd01a),fontSize: 20),),
                    SizedBox(height: 15,),

                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login, color: Color(0xFFbbd01a)),
                        label: const Text(
                          "Sign Up with Google",
                          style: TextStyle(color: Color(0xFFbbd01a)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF161616),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _signInWithGoogle(context),
                      )
                    ),

                  ],

                )

            ),
          )


        ],
      ),

    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    required Color textColor,
    required Color borderColor,
    required Color fillColor,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hint,
        hintStyle: TextStyle(color: textColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }

}
