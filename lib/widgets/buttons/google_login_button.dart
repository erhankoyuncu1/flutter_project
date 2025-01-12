import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/root_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class GoogleLoginButtonWidget extends StatelessWidget {
  const GoogleLoginButtonWidget({super.key});

  Future<void> _googleSignIn({required BuildContext context}) async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;

        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResults = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );

          // Girişin başarılı olup olmadığını kontrol et
          if (authResults.user != null) {
            Fluttertoast.showToast(msg:"Google login successful: ${authResults.user?.email}");

            // Giriş başarılıysa, sayfayı yönlendirme
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacementNamed(context, RootScreen.routName);
            });
          } else {
            // Giriş başarısız
            Fluttertoast.showToast(msg:"Google login failed: No user returned");
          }
        } else {
          Fluttertoast.showToast(msg:"Google auth failed: No access token or id token");
        }
      } else {
        Fluttertoast.showToast(msg:"Google sign in failed: No account selected");
      }
    } catch (error) {
      // Hata mesajlarını işleyebilirsiniz
      Fluttertoast.showToast(msg:"Error during Google sign in: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
      ),
      icon: const Icon(Ionicons.logo_google,color: Colors.white,),
      label: Text("Login with google", style: TextStyle(color: Colors.white),),
      onPressed: () async{
        await _googleSignIn(context: context);
      },
    );
  }
}
