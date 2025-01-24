import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/providers/user_provider.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../models/address_model.dart';
import '../../providers/address_provider.dart';

class AddressesScreen extends StatefulWidget {
  static const String routName = "/AddressesScreen";

  const AddressesScreen({super.key});

  @override
  _AddressPageState createState() => _AddressPageState();
}
 bool isLoading = false;

class _AddressPageState extends State<AddressesScreen> {
  Future<void> fetchAddresses() async{
    try{
      setState(() {
        isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      UserModel user = await userProvider.fetchUserInfoById(FirebaseAuth.instance.currentUser!.uid) as UserModel;
      Provider.of<AddressProvider>(context, listen: false)
          .fetchCurrentUserAddresses(user.userAddressList);
    }
    catch(err){
      Fluttertoast.showToast(msg: "Whoops! try later please",backgroundColor: Colors.red, textColor: Colors.white);
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return LoadingWidget(isLoading: isLoading,
    child: Scaffold(
      appBar: AppBar(
        title: AppNameText(titleText: "My Addresses"),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        },
            icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple,)
        ),
      ),
      body: addressProvider.addresses.isEmpty
          ? const Center(
            child: SubTitleTextWidget(label: "There is no any address yet.",fontSize: 18,color: Colors.purple,fontWeight: FontWeight.w600,)
      )
          : ListView.builder(
            itemCount: addressProvider.addresses.length,
            itemBuilder: (context, index) {
          final address = addressProvider.addresses[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            elevation: 4, // Gölge efekti
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Yuvarlatılmış köşeler
            ),
            color: Colors.purple[50], // Kart arka plan rengi
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              title: Text(
                address.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              subtitle: Text(
                address.fullAddress,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.purple.shade700,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    tooltip: "Edit Address",
                    onPressed: () {
                      _showUpdateAddressDialog(
                        context,
                        addressProvider,
                        address,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    tooltip: "Delete Address",
                    onPressed: () {
                      addressProvider.deleteAddress(address.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: address.isActive ? Colors.green : Colors.grey,
                    ),
                    tooltip: address.isActive
                        ? "Active Address"
                        : "Set as Active Address",
                    onPressed: () {
                      addressProvider.setActiveAddress(address.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 25),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 24,
              ),
            ),
            icon: const Icon(
              Icons.add,
              size: 24,
              color: Colors.white,
            ),
            label: const Text(
              "Add New Address",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              _showAddAddressBottomSheet(context, addressProvider);
            },
          ),
        ),
      )
    );
  }

  void _showAddAddressBottomSheet(
      BuildContext context, AddressProvider addressProvider) {
    final titleController = TextEditingController();
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.purple[100], // Arka plan rengini mor yapıyoruz
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0), // Köşelere yuvarlatma
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Address Title",
                  labelStyle: const TextStyle(color: Colors.purple),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.purple, width: 2),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Full address",
                  labelStyle: const TextStyle(color: Colors.purple),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.purple, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Buton arka plan rengi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                onPressed: () {
                  final newAddress = AddressModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text.trim(),
                    fullAddress: addressController.text.trim(),
                    isActive: false,
                  );

                  addressProvider.addAddress(newAddress);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.add,
                  size: 16,
                  weight: 25,
                  color: Colors.white,
                ),
                label: const SubTitleTextWidget(
                  label: "Add",
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        );
      },
    );
  }

  void _showUpdateAddressDialog(
      BuildContext context, AddressProvider addressProvider, AddressModel address) {
    final titleController = TextEditingController(text: address.title);
    final addressController = TextEditingController(text: address.fullAddress);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.purple[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SubTitleTextWidget(
                  label: "Update Address",
                  fontSize: 20,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Address Title",
                    labelStyle: const TextStyle(color: Colors.purple, fontSize: 18,fontWeight: FontWeight.w600),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.purple, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: "Full Address",
                    labelStyle: const TextStyle(color: Colors.purple,fontSize: 18,fontWeight: FontWeight.w600),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.purple, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const SubTitleTextWidget(
                        label: "Cancel",
                        color: Colors.purple,
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      onPressed: () {
                        final updatedAddress = AddressModel(
                          id: address.id,
                          title: titleController.text.trim(),
                          fullAddress: addressController.text.trim(),
                          isActive: address.isActive,
                        );

                        addressProvider.updateAddress(updatedAddress);
                        Navigator.pop(context);
                      },
                      child: const SubTitleTextWidget(
                        label: "Update",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
