import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class SearchResultsList extends StatelessWidget {
  final bool isSearching;
  final String? errorMessage;
  final List<GeocodeResult> searchResults;
  final bool showNoResults;
  final Function(GeocodeResult) onResultSelected;

  const SearchResultsList({
    super.key,
    required this.isSearching,
    required this.errorMessage,
    required this.searchResults,
    required this.showNoResults,
    required this.onResultSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    if (showNoResults) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('No results found', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = searchResults[index];
        return ListTile(
          leading: Icon(Icons.location_on, color: Colors.teal[400]),
          title: Text(
            result.address['road'] ?? result.displayName.split(',')[0],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            result.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          onTap: () => onResultSelected(result),
        );
      },
    );
  }
}
