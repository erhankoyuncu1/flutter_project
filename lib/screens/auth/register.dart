import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/constans/validator.dart';
import 'package:flutter_project/root_screen.dart';
import 'package:flutter_project/services/app_functions.dart';
import 'package:flutter_project/widgets/image_picker_widget.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/titles/app_name_text_widget.dart';
import '../../widgets/titles/subtitle_text_widget.dart';
import '../../widgets/titles/title_text_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = "/RegisterScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscrueText = true;
  late final TextEditingController _nameController,
  _emailController,
  _passwordController,
  _passwordRepeatController;

  late final FocusNode _nameFocusNode,
  _emailFocusNode,
  _passwordFocusNode,
  _passwordRepeatFocusNode;

  final _formkey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState(){
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordRepeatController = TextEditingController();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordRepeatFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    if(mounted) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _passwordRepeatController.dispose();

      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _passwordRepeatFocusNode.dispose();
    }

    super.dispose();
  }

  Future<void> registerFct() async{
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid) {
      try{
        setState(() {
          isLoading = true;
        });
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
        );
        final User? user = auth.currentUser;
        final String uid = user!.uid;

        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId': uid,
          'userName' : _nameController.text,
          'userImage' : "",
          'userEmail' : _emailController.text.toLowerCase(),
          'userPassword' : _passwordController.text,
          'isAdmin' : false,
          'createdAt' : Timestamp.now(),
          'userCart' : [],
          'userFavoriteList' : [],
          'userAddressList' : []
        });
        Fluttertoast.showToast(msg: "Account has been created successfully");
        if(!mounted)
          return;
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      }
      on FirebaseException catch(error)
      {
        await AppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(),
          function: (){}
        );
      }
      catch(error){
        await AppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(),
          function: (){}
        );
      }
      finally{
        isLoading = false;
      }
    }
  }

  Future<void> localImagePicker() async{
    final ImagePicker imagePicker = ImagePicker();
    await AppFunctions.imagePickerDialog(
      context: context,
      cameraFct: () async{
        _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
        setState(() {

        });
      },
      galleryFct: () async{
        _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {

        });
      },
      removeFct: () async{
        setState(() {
          _pickedImage = null;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(onPressed: (){
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
            },
                icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple)),
            title: AppNameText(
              titleText: "Register Page",
            ),
          ),
        body: LoadingWidget(
          isLoading: isLoading,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: TitleTextWidget(label: "Welcome! Join us by registering here.",color: Colors.purple, fontWeight: FontWeight.w600,),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple),
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: SizedBox(
                    height: size.height * 0.18,
                    width: size.width * 0.32,
                    child: ImagePickerWidget(function: (){
                      localImagePicker();
                    },pickedImage: _pickedImage,),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Full Name",
                          prefixIcon: Icon(Icons.drive_file_rename_outline)
                        ),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        validator: (name) {
                          return AppValidators.displayNameValidator(name);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "e-mail",
                          prefixIcon: Icon(Icons.email_outlined)
                        ),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                        validator: (email) {
                          return AppValidators.emailValidator(email);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscrueText,
                        decoration: InputDecoration(
                          hintText: "password",
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                obscrueText = !obscrueText;
                              });
                            },
                            icon: Icon(
                              obscrueText ? Icons.visibility_outlined :
                                Icons.visibility_off_outlined
                            ),
                          )
                        ),
                        onFieldSubmitted: (password) {
                          FocusScope.of(context).requestFocus(_passwordRepeatFocusNode);
                        },
                        validator: (password) {
                          return AppValidators.passwordValidator(password);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _passwordRepeatController,
                        focusNode: _passwordRepeatFocusNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscrueText,
                        decoration: InputDecoration(
                          hintText: "repeat password",
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                obscrueText = !obscrueText;
                              });
                            },
                            icon: Icon(
                                obscrueText ? Icons.visibility_outlined :
                                Icons.visibility_off_outlined
                            ),
                          )
                        ),
                        onFieldSubmitted: (passwordRepeat) async{
                        },
                        validator: (password) {
                          return AppValidators.passwordValidator(password);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: size.width*0.75,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 3, 113, 3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              padding: const EdgeInsets.all(12)
                          ),
                          icon: Icon(IconlyLight.addUser,color: Colors.white,),
                          label: SubTitleTextWidget(label: "Sign up",fontWeight: FontWeight.w600,color: Colors.white,),
                          onPressed: () async{
                            await  registerFct();
                          },
                        ),
                      )
                    ]
                  ),
                )
              ]
            )
          )
          )
        )
      )
    );
  }
}
