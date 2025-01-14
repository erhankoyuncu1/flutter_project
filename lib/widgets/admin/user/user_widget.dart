import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/providers/user_provider.dart';
import 'package:flutter_project/screens/admin/edit_upload_user_screen.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:provider/provider.dart';

import '../../../services/app_functions.dart';

class AdminUserWidget extends StatefulWidget {
  const AdminUserWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<AdminUserWidget> createState() => _AdminUserWidgetState();
}

class _AdminUserWidgetState extends State<AdminUserWidget> {
  UserModel? user;
  bool _isLoading = false;

  Future<void> fetchUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      user = await userProvider.fetchUserInfoById(widget.userId);
    } catch (error) {
      await AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        function: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async{
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return EditUploadUserScreen(
                  userModel: user,
                );
              }
          )
          );
        },
        child: Column(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: user!.userImage.isNotEmpty
                      ? FancyShimmerImage(
                    imageUrl: user!.userImage,
                    height: size.height * 0.2,
                    width: size.width * 0.2,
                  )
                      : const Icon(Icons.person, size: 60),
                ),
                const SizedBox(width: 10),
                SubTitleTextWidget(label: user!.userName),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
