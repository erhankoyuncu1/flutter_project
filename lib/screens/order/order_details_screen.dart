import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/models/order_model.dart';
import 'package:flutter_project/providers/address_provider.dart';
import 'package:flutter_project/providers/order_provider.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/address_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routName = "OrderDetailsScreen";
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderModel? order;

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    String? productId = ModalRoute.of(context)!.settings.arguments as String?;
    order = orderProvider.getOrderById(productId!);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              IconlyLight.arrowLeft2,
              color: Colors.purple,
              weight: 22,
            ),
          ),
          title: const AppNameText(titleText: "Order Details"),
        ),
        body: const Center(
          child: SubTitleTextWidget(
            label: "Order details not available",
            color: Colors.purple,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            IconlyLight.arrowLeft2,
            color: Colors.purple,
            weight: 22,
          ),
        ),
        title: const AppNameText(titleText: "Order Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Card
              FutureBuilder<AddressModel?>(
                future: order?.address != null
                    ? addressProvider.fetchAddressById(order!.address)
                    : Future.value(null),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error, color: Colors.red);
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final address = snapshot.data!;
                    return _buildCard(
                      context,
                      isDarkMode,
                      IconlyBold.home,
                      "Delivery Address",
                      address.fullAddress,
                    );
                  } else {
                    return _buildCard(
                      context,
                      isDarkMode,
                      IconlyBold.home,
                      "Delivery Address",
                      "No address available",
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              // Order Details
              _buildCard(
                context,
                isDarkMode,
                IconlyBold.calendar,
                "Order Date",
                DateFormat('dd MMM yyyy').format(order!.orderDate.toDate()),
              ),
              const SizedBox(height: 20),
              _buildCard(
                context,
                isDarkMode,
                IconlyBold.calendar,
                "Delivery Date",
                order!.deliveryDate != null
                    ? DateFormat('dd MMM yyyy').format(order!.deliveryDate!.toDate())
                    : "No delivery date",
              ),
              const SizedBox(height: 20),
              _buildCard(
                context,
                isDarkMode,
                IconlyBold.infoCircle,
                "Order Status",
                order!.orderStatus.name,
              ),
              const SizedBox(height: 20),
              _buildCard(
                context,
                isDarkMode,
                IconlyBold.wallet,
                "Payment Method",
                order!.paymentMethod.name,
              ),
              const SizedBox(height: 40),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _cancelOrder(context, orderProvider, productId!);
                    },
                    icon: const Icon(IconlyBold.closeSquare,color: Colors.white),
                    label: const SubTitleTextWidget(label:"Cancel Order",color: Colors.white,fontWeight: FontWeight.w500),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _updateOrder(context, orderProvider, productId!);
                    },
                    icon: const Icon(IconlyBold.editSquare,color: Colors.white,),
                    label: const SubTitleTextWidget(label: "Update Order",color: Colors.white,fontWeight: FontWeight.w500),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool isDarkMode, IconData icon,
      String title, String value) {
    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: isDarkMode ? Colors.white : Colors.purple),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubTitleTextWidget(
                    label: title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 4),
                  SubTitleTextWidget(
                    label: value,
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.black54,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelOrder(
      BuildContext context, OrderProvider orderProvider, String orderId) async {
    bool confirm = await _showConfirmationDialog(
      context,
      "Cancel Order",
      "Are you sure you want to cancel this order?",
    );
    if (confirm) {
      orderProvider.cancelOrder(orderId);
    }
  }

  Future<void> _updateOrder(
      BuildContext context, OrderProvider orderProvider, String orderId) async {
    bool confirm = await _showConfirmationDialog(
      context,
      "Update Order",
      "Are you sure you want to update this order?",
    );
    if (confirm) {
      orderProvider.updateOrder(orderId, order!.orderStatus);
      Fluttertoast.showToast(msg:"Order updated successfully",backgroundColor:Colors.green,textColor: Colors.white);
    }
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String title, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    ) ??
        false;
  }
}
