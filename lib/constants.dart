import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color darkBlue = Color.fromARGB(255, 5, 2, 28);
  static const Color lightdarkBlue = Color.fromARGB(255,36,34,57);
  static const Color highlight = Color.fromARGB(255,62,53,218);
}

const String baseUrl = 'https://7e683af26a22.ngrok-free.app';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;

  const TopBar({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.onSurface, size: 35),
        onPressed: onBackPressed ?? () {
          Navigator.pop(context);
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
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: height * 0.05,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.roboto().copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}


