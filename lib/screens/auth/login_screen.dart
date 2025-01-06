import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/constans/validator.dart';
import 'package:flutter_project/screens/auth/forgot_password_screen.dart';
import 'package:flutter_project/screens/auth/register.dart';
import 'package:flutter_project/widgets/buttons/google_login_button.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';

class LoginScreen extends StatefulWidget {
  static const routName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose(){
    if(mounted){
      _emailController.dispose();
      _passwordController.dispose();

      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }

    super.dispose();
  }

  Future<void> _loginFct() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
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
              icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple,)),
          title: AppNameText(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleTextWidget(label: "Welcome, Please Login"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText:"\t e-mail",
                          prefixIcon: Icon(IconlyLight.message)
                        ),
                        onFieldSubmitted: (email) {
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                        validator: (email){
                          return AppValidators.emailValidator(email);
                        },
                      ),
                      const SizedBox(
                        height:20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText:"\t password",
                            prefixIcon: Icon(IconlyLight.lock)
                        ),
                        onFieldSubmitted: (value) async{
                          await _loginFct();
                        },
                        validator: (password){
                          return AppValidators.passwordValidator(password);
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: (){
                            Navigator.pushNamed(context, ForgetPasswordScreen.routName);
                          },
                          child: const SubTitleTextWidget(
                            label: "Forgot Password?",
                            color: Color.fromARGB(255, 4, 23, 117),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: size.width*0.75,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 16, 97, 21),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)
                            ),
                            padding: const EdgeInsets.all(12)
                          ),
                          icon: Icon(IconlyLight.login,color: Colors.white,),
                          label: SubTitleTextWidget(label: "Login",fontWeight: FontWeight.w600,color: Colors.white,),
                          onPressed: () async{
                            await  _loginFct();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SubTitleTextWidget(label: "Or Connect Using"),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.person,color: Colors.white,),
                            label: SubTitleTextWidget(label: "Guest",color: Colors.white,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent
                            ),
                            onPressed: () async{
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GoogleLoginButtonWidget()
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SubTitleTextWidget(label: "New User ?"),
                          const SizedBox(
                            height: 18
                          ),
                          TextButton.icon(
                            label: SubTitleTextWidget(label: "Register"),
                            icon: Icon(Icons.account_box_outlined),
                            onPressed: () {
                              Navigator.of(context).pushNamed(RegisterScreen.routName);
                            },
                          ),
                        ],
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
