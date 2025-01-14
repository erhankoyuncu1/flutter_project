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
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();
    searchTextController.addListener(() {
      setState(() {
        hasText = searchTextController.text.isNotEmpty;
      });
    });
    fetchAllUsers();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  Future<void> fetchAllUsers() async {
    setState(() => _isLoading = true);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      allUsers = await userProvider.fetchAllUsers();
      filteredUsers = allUsers;
    } catch (error) {
      await AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Failed to fetch users: ${error.toString()}",
        function: () {},
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void filterUsers(String searchText) {
    setState(() {
      filteredUsers = allUsers.where((user) {
        return user.userName.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(IconlyLight.arrowLeft2, color: Colors.purple),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
          title: const AppNameText(
            titleText: "All Users",
            titleColor: Colors.purple,
          ),
        ),
        body: LoadingWidget(
          isLoading: _isLoading,
          child: filteredUsers.isEmpty
              ? const Center(
            child: SubTitleTextWidget(label: "No Users Found"),
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                TextField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    hintText: "Search by user name...",
                    hintStyle: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: hasText
                        ? GestureDetector(
                      onTap: () {
                        setState(() {
                          searchTextController.clear();
                          filteredUsers = allUsers;
                        });
                      },
                      child: const Icon(Icons.clear),
                    )
                        : null,
                  ),
                  onChanged: filterUsers,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: DynamicHeightGridView(
                    mainAxisSpacing: 12,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    itemCount: filteredUsers.length,
                    builder: (context, index) {
                      return AdminUserWidget(
                        userId: filteredUsers[index].userId,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
