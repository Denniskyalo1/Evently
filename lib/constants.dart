import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBlue = Color.fromARGB(255, 5, 2, 28);
  static const Color lightdarkBlue = Color.fromARGB(255,36,34,57);
  static const Color highlight = Color.fromARGB(255,62,53,218);
}


class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;

  const TopBar({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
        onPressed: onBackPressed ?? () {
          print('Back button clicked');
          Navigator.pop(context); // Default behavior
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: height * 0.05,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEB1555),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Cash Light',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

