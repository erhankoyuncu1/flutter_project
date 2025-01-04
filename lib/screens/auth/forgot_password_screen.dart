import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../widgets/title/app_name_text_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static String routName = "/ForgetPasswordScreen";

  const ForgetPasswordScreen({super.key});


  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    if(mounted){
      _emailController.dispose();
    }
    super.dispose();
  }

  Future<void> _resetPasswordFct() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        },
            icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple,)),
        title: AppNameText(
          titleText: "Forgot Password",
        ),
      ),
    );
  }
}
