import 'package:bli/services/api_service.dart';
import 'package:bli/theme/app_theme.dart';
import 'package:flutter/material.dart';

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
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessage!,
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    }

    if (showNoResults) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No results found',
          style: TextStyle(color: AppColors.greyMedium),
        ),
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
          leading: Icon(Icons.location_on, color: AppColors.primaryLight),
          title: Text(
            result.address['road'] ?? result.displayName.split(',')[0],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            result.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: AppColors.greyMedium),
          ),
          onTap: () => onResultSelected(result),
        );
      },
    );
  }
}
