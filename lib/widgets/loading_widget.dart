import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText = "Loading..."
  });

  final Widget child;
  final bool isLoading;
  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.8),
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.cyan,
                      strokeWidth: 6,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SubTitleTextWidget(
                  label: loadingText,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
