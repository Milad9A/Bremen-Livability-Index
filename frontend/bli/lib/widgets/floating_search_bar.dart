import 'package:flutter/material.dart';
import 'glass_container.dart';

class FloatingSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 30,
        padding: EdgeInsets.zero,
        child: IgnorePointer(
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Search for an address...',
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
