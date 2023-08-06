import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final bool loading;
  final String title;
  final VoidCallback onTap;

  const RoundButton(
      {
        super.key,
      required this.title,
      required this.onTap,
      this.loading = false
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.redAccent
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,) : Text(
            title,
            style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,letterSpacing: 3),
          ),
        ),
      ),
    );
  }
}
