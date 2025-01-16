import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/constans/validator.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/providers/user_provider.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:flutter_project/services/cloudinary_service.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/app_functions.dart';
import '../../widgets/titles/title_text_widget.dart';

class EditUploadUserScreen extends StatefulWidget {
  static const routName = "/EditUploadUserScreen";

  const EditUploadUserScreen({super.key, this.userModel});

  final UserModel? userModel;

  @override
  State<EditUploadUserScreen> createState() => _EditUploadUserScreenState();
}

class _EditUploadUserScreenState extends State<EditUploadUserScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _userImage;
  late TextEditingController _userNameController;
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late ValueNotifier<bool> _isAdmin = ValueNotifier<bool>(false);
  bool isEditing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.userModel != null) {
      isEditing = true;
      _isAdmin.value = widget.userModel!.isAdmin;
    }

    _userNameController =
        TextEditingController(text: widget.userModel?.userName ?? '');
    _userEmailController =
        TextEditingController(text: widget.userModel?.userEmail ?? '');
    _userPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _isAdmin.dispose();
    super.dispose();
  }

  Future<void> saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String? uploadedImageUrl;
    if (_userImage != null) {
      try {
        uploadedImageUrl = await CloudinaryService().uploadImage(File(_userImage!.path));
      } catch (e) {
        AppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: "Image upload failed. Please try again.",
          function: () {},
          isError: true,
        );
        setState(() => isLoading = false);
        return;
      }
    }

    try {
      if (isEditing) {
        final userModel = UserModel(
          userId: widget.userModel!.userId,
          userName: _userNameController.text.trim(),
          userEmail: _userEmailController.text.trim(),
          userPassword: widget.userModel!.userPassword,
          userImage: uploadedImageUrl ?? widget.userModel!.userImage ?? "",
          createdAt: widget.userModel!.createdAt,
          isAdmin: _isAdmin.value,
          userCart: widget.userModel?.userCart ?? [],
          userFavoriteList: widget.userModel?.userFavoriteList ?? [],
          userAddressList: widget.userModel?.userAddressList ?? [],
        );
        await userProvider.updateUser(userModel);
      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _userEmailController.text.trim(),
          password: _userPasswordController.text.trim(),
        );
        final userId = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection("users").doc(userId).set({
          'userId': userId,
          'userName': _userNameController.text.trim(),
          'userImage': uploadedImageUrl ?? "",
          'userEmail': _userEmailController.text.trim().toLowerCase(),
          'userPassword': _userPasswordController.text.trim(),
          'isAdmin': false,
          'createdAt': Timestamp.now(),
          'userCart': [],
          'userFavoriteList': [],
          'userAddressList': []
        });}
      Fluttertoast.showToast(msg: "User added successfully");
      Navigator.pop(context);
    } catch (error) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        function: () {},
        isError: true,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    await AppFunctions.imagePickerDialog(
      context: context,
      cameraFct: () async {
        final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
        if (pickedImage != null) {
          setState(() {
            _userImage = pickedImage;
          });
        }
      },
      galleryFct: () async {
        final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          setState(() {
            _userImage = pickedImage;
          });
        }
      },
      removeFct: () {
        setState(() {
          _userImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () =>
            Navigator.canPop(context) ? Navigator.pop(context) : null,
            icon: const Icon(
              IconlyLight.arrowLeft2,
              color: Colors.purple,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsManager.addNewProduct,
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 12),
              TitleTextWidget(
                label: isEditing ? "Edit User" : "Add New User",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        body: LoadingWidget(
          isLoading: isLoading,
          loadingText: "Saving user...",
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  if (_userImage == null && widget.userModel?.userImage == null)
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      color: Colors.purple,
                      child: SizedBox(
                        width: size.width * 0.6,
                        height: size.width * 0.6,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.image,
                                size: 60, color: Colors.purple),
                            onPressed: pickImage,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        if (_userImage != null || widget.userModel?.userImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FancyShimmerImage(
                              imageUrl: _userImage?.path ?? widget.userModel!.userImage!,
                              height: size.height * 0.2,
                              width: size.width * 0.2,
                            ),
                          ),
                        TextButton(
                          onPressed: pickImage,
                          child: const SubTitleTextWidget(
                            label: "Select Image",
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(hintText: "Full Name"),
                            validator: (value) =>
                                AppValidators.displayNameValidator(value ?? ''),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _userEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(hintText: "Email"),
                            validator: (value) =>
                                AppValidators.emailValidator(value ?? ''),
                            readOnly: isEditing,
                          ),
                          const SizedBox(height: 16),
                          if (!isEditing)
                            TextFormField(
                              controller: _userPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(hintText: "Password"),
                              validator: (value) => AppValidators.passwordValidator(value ?? ''),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const SubTitleTextWidget(
                                label: "Admin : ",
                                fontSize: 18,
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: _isAdmin,
                                builder: (context, value, child) {
                                  return Switch(
                                    value: value,
                                    onChanged: (newValue) {
                                      _isAdmin.value = newValue;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              saveUser();
                            },
                            icon: Icon(isEditing ? Icons.done : Icons.add),
                            label: Text(isEditing ? "Edit User" : "Add User"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}