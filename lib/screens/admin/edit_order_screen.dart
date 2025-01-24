import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';

class EditOrderScreen extends StatefulWidget {
  static const routName = "/EditOrderScreen";
  const EditOrderScreen({super.key, this.order});

  final OrderModel? order;

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _orderAddressController;
  late OrderStatus _orderStatus;
  late Timestamp _orderDeliveryDate;

  @override
  void initState() {
    super.initState();

    _orderAddressController = TextEditingController(text: widget.order?.address ?? '');
    _orderStatus = widget.order?.orderStatus ?? OrderStatus.pending;
    _orderDeliveryDate = widget.order?.deliveryDate ?? Timestamp.now();
  }

  @override
  void dispose() {
    _orderAddressController.dispose();
    super.dispose();
  }

  Future<void> _updateOrder() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.order?.id)
            .update({
          'address': _orderAddressController.text,
          'orderStatus': _orderStatus.name,
          'deliveryDate': _orderDeliveryDate,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple,)
        ),
        title: AppNameText(titleText:'Edit Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _orderAddressController,
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  labelStyle: const TextStyle(color: Colors.purple,fontWeight: FontWeight.w500,fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.purple)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.purple, width: 2)
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the delivery address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<OrderStatus>(
                value: _orderStatus,
                decoration: InputDecoration(
                  labelText: 'Order Status',
                  labelStyle: TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.w500),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.purple)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.purple, width: 2)
                  ),
                ),
                dropdownColor: Colors.purple,
                items: OrderStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _orderStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Delivery Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _orderDeliveryDate.toDate(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _orderDeliveryDate = Timestamp.fromDate(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_orderDeliveryDate.toDate()),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateOrder,
                child: const Text('Update Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
