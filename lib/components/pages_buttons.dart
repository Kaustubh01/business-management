import 'package:flutter/material.dart';

class PagesButtons extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const PagesButtons({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color:  Colors.black)
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              ),
          ),
          )
        );
  }
}