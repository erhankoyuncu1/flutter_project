import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/providers/user_provider.dart';
import 'package:flutter_project/widgets/admin/user/user_widget.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:provider/provider.dart';

import '../../services/app_functions.dart';
import '../../services/assets_manager.dart';
import '../../widgets/titles/app_name_text_widget.dart';

class AllUsersScreen extends StatefulWidget {
  static const routName = "/AllUsersScreen";
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late TextEditingController searchTextController;
  bool hasText = false;

  @override
  void dispose(){
    searchTextController.dispose();
    super.dispose();
  }

  List<UserModel> userListSearch = [];
  List<UserModel> userList = [];
  bool _isLoading = false;

  Future<void> getAllUsers() async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userList = (await userProvider.fetchAllUsers()).cast<UserModel>();
    }
    catch(error) {
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

  Future<void> usersBySearchText(String searchText) async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try{
      setState(() {
        _isLoading = true;
      });
      userListSearch = (await userProvider.findByUserName(searchText)).cast<UserModel>();
    }
    catch(error) {
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
    getAllUsers();
    searchTextController = TextEditingController();
    searchTextController.addListener((){
      setState(() {
        hasText = searchTextController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }
              )
            ),
            title: AppNameText(titleText:"All Users", titleColor: Colors.purple,)
        ),
        body:LoadingWidget(
          isLoading: _isLoading,
          child:userList.isEmpty ?
          const Center(
            child: SubTitleTextWidget(label: "No User"),
          )
          :Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    hintText: "search by user name...",
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: hasText ? GestureDetector(
                      onTap: (){
                        setState(() {
                          FocusScope.of(context).unfocus();
                          searchTextController.clear();
                        });
                      },
                      child: const Icon(Icons.clear),
                    )
                        : null,
                  ),
                  onSubmitted: (value) async {
                    setState(() {
                      _isLoading = true;
                    });
                    await usersBySearchText(searchTextController.text);
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if(searchTextController.text.isNotEmpty && userListSearch.isEmpty)...[
                  const Center(
                    child: SubTitleTextWidget(label: "No user found"),
                  )
                ],
                Expanded(
                    child: DynamicHeightGridView(
                      mainAxisSpacing: 12,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      itemCount: searchTextController.text.isNotEmpty ?
                      userListSearch.length :
                      userList.length,
                      builder: (context, index){
                        return  AdminUserWidget(
                            userId: searchTextController.text.isNotEmpty
                            ? userListSearch[index].userId
                                : userList[index].userId,
                        );
                      },
                    )
                ),
              ],
            ),
          )
      ),
      )
    );
  }
}
