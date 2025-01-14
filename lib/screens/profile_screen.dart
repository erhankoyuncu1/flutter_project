import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/screens/auth/login_screen.dart';
import 'package:flutter_project/screens/orders_screen.dart';
import 'package:flutter_project/services/app_functions.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'init_screens/favorite_products_screen.dart';
import 'init_screens/viewed_recently_products_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin{
  @override
  bool  get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = false;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    try{
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfoById(user!.uid);
    }
    catch(error){
      await AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        function: (){},
      );
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState(){
    fetchUserInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Image.asset(
              AssetsManager.login,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const AppNameText(
          titleText: "Profile",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body:LoadingWidget(
        isLoading: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Not Logged In User Page
            Visibility(
              visible: user == null || userModel == null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TitleTextWidget(label: "Please Login"),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.white),
                          backgroundColor: Colors.green.shade900,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(LoginScreen.routName);
                        },
                        icon: const Icon(Icons.login,color: Colors.white,),
                        label: const Text("Login",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Logged In User Page
            Visibility(
              visible: user!=null && userModel != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                              color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                              width: 3,
                            ),
                          ),
                          child:  ClipOval(
                            child: userModel != null && userModel!.userImage.isNotEmpty
                                ? Image.network(
                              userModel!.userImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                            )
                                : Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleTextWidget(label: userModel?.userName ?? "User",),
                            SubTitleTextWidget(
                                label: user?.email ?? "example@gmail.com"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // User Page Options
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          thickness: 1,
                          height: 3,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TitleTextWidget(label: "Information"),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomListTile(
                            imagePath: AssetsManager.bagImg2,
                            text: "All Orders",
                            function: () {
                              Navigator.pushNamed(context, OrdersScreen.routName);
                            }),
                        CustomListTile(
                            imagePath: AssetsManager.bagImg1,
                            text: "Favorites",
                            function: () {
                              Navigator.pushNamed(context, FavoriteProductsScreen.routName);
                            }),
                        CustomListTile(
                            imagePath: AssetsManager.recentlyViewedIcon,
                            text: "Viewed Recently",
                            function: () {
                              Navigator.pushNamed(context, ViewedRecentlyProductsScreen.routName);
                            }),
                        CustomListTile(
                            imagePath: AssetsManager.addMap,
                            text: "Address",
                            function: () {}),
                        CustomListTile(
                            imagePath: AssetsManager.settings,
                            text: "Settings",
                            function: () {}),
                      ],
                    ),
                  ),
                  // Logout button
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async{
                        await AppFunctions.showErrorOrWarningDialog(
                          context: context,
                          subtitle: "Are you sure ?",
                          function: () async {
                            try{
                              await  FirebaseAuth.instance.signOut();
                              Fluttertoast.showToast(msg: "Sign out successful");
                              setState(() {
                                user = null;
                              });
                            }
                            catch(error){
                              Fluttertoast.showToast(msg: "Sign out failed");
                            }
                          }
                        );
                      },
                      icon: const Icon(Icons.logout,color: Colors.white,),
                      label: const Text("Logout",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });

  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubTitleTextWidget(label: text, fontSize: 22),
      leading: Image.asset(
        imagePath,
        height: 34,
      ),
      trailing: const Icon(
        Icons.arrow_right,
        size: 35,
      ),
    );
  }
}
