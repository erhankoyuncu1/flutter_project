import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/constans/app_constans.dart';
import 'package:flutter_project/constans/validator.dart';
import 'package:flutter_project/providers/product_provider.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/product_model.dart';
import '../../services/app_functions.dart';
import '../../services/cloudinary_service.dart';  // <-- Bu satır eklendi
import '../../widgets/titles/title_text_widget.dart';

class EditUploadProductScreen extends StatefulWidget {
  static const routName = "/EditUploadProductScreen";
  const EditUploadProductScreen({super.key, this.productModel});

  final ProductModel? productModel;

  @override
  State<EditUploadProductScreen> createState() => _EditUploadProductScreenState();
}

bool _isLoading = false;

class _EditUploadProductScreenState extends State<EditUploadProductScreen> {

  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  late TextEditingController
  _titleController,
      _priceController,
      _descriptionController,
      _quantityController;
  late String _categoryValue;
  bool isEditing = false;

  String? productNetworkImage;

  final CloudinaryService _cloudinaryService = CloudinaryService();

  @override
  void initState() {
    if (widget.productModel != null) {
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
      _categoryValue = widget.productModel!.productCategory;
    }
    else{
      _categoryValue = AppConstans.categoryList[0];
    }

    _titleController = TextEditingController(text: widget.productModel?.productTitle);
    _priceController = TextEditingController(text: widget.productModel?.productPrice.toString());
    _descriptionController = TextEditingController(text: widget.productModel?.productDescription);
    _quantityController = TextEditingController(text: widget.productModel?.productQuantity.toString());

    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _titleController.dispose();
      _priceController.dispose();
      _descriptionController.dispose();
      _quantityController.dispose();
    }
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();

    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }

  Future<void> addProduct() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (_pickedImage == null) {
      AppFunctions.showErrorOrWarningDialog(context: context, subtitle: "Please add image", function: () {}, isError: false);
      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        String? imageUrl = await _cloudinaryService.uploadImage(File(_pickedImage!.path));
        var uuid = Uuid();

        if (imageUrl != null) {
          ProductModel newProduct = ProductModel(
            productTitle: _titleController.text,
            productPrice: double.parse(_priceController.text),
            productDescription: _descriptionController.text,
            productQuantity: double.parse(_quantityController.text),
            productCategory: _categoryValue,
            productImage: imageUrl,
            productId: uuid.v4(),
            createdAt: Timestamp.now(),
          );

          productProvider.addProduct(newProduct);
        }
      } catch (err) {
        Fluttertoast.showToast(msg: "Failed to add product: ${err.toString()}");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  Future<void> editProduct() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl = _pickedImage != null
          ? await _cloudinaryService.uploadImage(File(_pickedImage!.path))
          : productNetworkImage;

      if (imageUrl != null) {
        ProductModel updatedProduct = ProductModel(
          productId: widget.productModel!.productId,
          productTitle: _titleController.text,
          productPrice: double.parse(_priceController.text),
          productCategory: _categoryValue,
          productDescription: _descriptionController.text,
          productImage: imageUrl,
          productQuantity: double.parse(_quantityController.text),
          createdAt: widget.productModel!.createdAt,
        );

        await FirebaseFirestore.instance
            .collection('products')
            .doc(updatedProduct.productId)
            .update(updatedProduct.toMap());

        Fluttertoast.showToast(msg: "Product updated successfully!",backgroundColor: Colors.green, textColor: Colors.white);
        Navigator.of(context).pop();
      }
    }
  }


  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await AppFunctions.imagePickerDialog(
        context: context,
        cameraFct: () async {
          _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
          setState(() {});
        },
        galleryFct: () async {
          _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
          setState(() {});
        },
        removeFct: () async {
          setState(() {
            _pickedImage = null;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return LoadingWidget(isLoading: _isLoading,
      child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
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
                label: isEditing ? "Edit Product" : "Add new product",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                if (isEditing && productNetworkImage != null) ...{
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        productNetworkImage!,
                        height: size.width * 0.7,
                        alignment: Alignment.center,
                      ))
                } else if (_pickedImage == null) ...{
                  SizedBox(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    child: DottedBorder(
                      borderType: BorderType.Rect,
                      color: Colors.purple,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image,
                              size: 60,
                              color: Colors.purple,
                            ),
                            TextButton(
                                onPressed: () {
                                  localImagePicker();
                                },
                                child: SubTitleTextWidget(
                                  label: "Select Image",
                                  color: Colors.purple,
                                ))
                          ],
                        ),
                      ),
                    ),
                  )
                } else ...{
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_pickedImage!.path),
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  )
                },
                if (_pickedImage != null || productNetworkImage != null) ...{
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            localImagePicker();
                          },
                          child: SubTitleTextWidget(
                            label: "Select Image",
                            color: Colors.purple,
                          ))
                    ],
                  ),
                },
                const SizedBox(
                  height: 20,
                ),
                DropdownButton(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: Colors.purple,
                  items: AppConstans.categoriesDropDownList,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black),
                  value: _categoryValue,
                  hint: const Text("Select a category"),
                  onChanged: (String? value) {
                    setState(() {
                      _categoryValue = value!;
                    });
                  },
                  menuMaxHeight: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          key: const ValueKey("Title"),
                          minLines: 1,
                          maxLines: 2,
                          maxLength: 100,
                          buildCounter: (context,
                              {required int currentLength,
                                required bool isFocused,
                                required int? maxLength}) {
                            if (currentLength == maxLength) {
                              return Text(
                                '$currentLength/$maxLength',
                                style: const TextStyle(color: Colors.red),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: "Product Title",
                          ),
                          validator: (value) {
                            return AppValidators.uploadProductText(value: _titleController.text, toBeReturnedString: "Please enter a valid title.");
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                  controller: _priceController,
                                  key: const ValueKey("Price \$"),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Product Price",
                                  ),
                                  validator: (value) {
                                    return AppValidators.uploadProductText(value: _priceController.text, toBeReturnedString: "Please enter a valid title");
                                  }),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                  controller: _quantityController,
                                  key: const ValueKey("Quantity"),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Product Quantity",
                                  ),
                                  validator: (value) {
                                    return AppValidators.uploadProductText(value: _quantityController.text, toBeReturnedString: "Please enter a valid quantity");
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          key: const ValueKey("Description"),
                          maxLength: 200,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Product Description",
                          ),
                          validator: (value) {
                            return AppValidators.uploadProductText(value: _descriptionController.text, toBeReturnedString: "Please enter a valid description");
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            if (isEditing) {
                              editProduct();
                            } else {
                              addProduct();
                            }
                          },
                          icon: Icon(
                            isEditing ? Icons.done : Icons.add,
                            color: Colors.white,
                          ),
                          label: SubTitleTextWidget(
                            label: isEditing ? "Edit Product" : "Add Product",
                            color: Colors.white,
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
      ),)
    );
  }
}
