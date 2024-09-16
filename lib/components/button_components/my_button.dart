import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isLoading;
  const MyButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                  horizontal: 50, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                // Rounded corners
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                Colors.transparent,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 19,
                    width: 19,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(buttonText),
          ),
        ],
      ),
    );
  }
}
