import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class GoogleLoginButtonWidget extends StatelessWidget {
  const GoogleLoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
      ),
      icon: const Icon(Ionicons.logo_google,color: Colors.white,),
      label: Text("Login with google", style: TextStyle(color: Colors.white),),
      onPressed: (){},
    );
  }
}
