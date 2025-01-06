import 'package:flutter/material.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:provider/provider.dart';

class QuantityBottomSheet extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const QuantityBottomSheet({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 8,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 25,
            itemBuilder: (context, index) {
              final currentQuantity = index + 1;
              return InkWell(
                hoverColor: Colors.black,
                onTap: () {
                  onQuantityChanged(currentQuantity);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubTitleTextWidget(
                      label: "${currentQuantity}",
                      color: currentQuantity == quantity
                          ? Colors.green
                          : themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
