import 'package:flutter/material.dart';
import 'glass_container.dart';

class LoadingOverlay extends StatelessWidget {
  final bool showSlowLoadingMessage;

  const LoadingOverlay({super.key, required this.showSlowLoadingMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassContainer(
            borderRadius: 100,
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(),
          ),
          if (showSlowLoadingMessage) ...[
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: GlassContainer(
                opacity: 0.9,
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: Colors.teal[800],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Waking up server...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The backend is starting up. This may take up to 50 seconds.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[800], height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
