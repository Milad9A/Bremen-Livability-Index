import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import 'dart:async';

class AddressSearchWidget extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;
  final VoidCallback onClose;

  const AddressSearchWidget({
    super.key,
    required this.onLocationSelected,
    required this.onClose,
  });

  @override
  State<AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<GeocodeResult> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final results = await _apiService.geocodeAddress(query, limit: 5);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Search failed: $e';
        _isSearching = false;
        _searchResults = [];
      });
    }
  }

  void _selectResult(GeocodeResult result) {
    final location = LatLng(result.latitude, result.longitude);
    widget.onLocationSelected(location, result.displayName);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search bar header
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _onSearchChanged,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search for an address...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            // Results list
            if (_isSearching)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              )
            else if (_searchResults.isEmpty &&
                _searchController.text.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                      title: Text(
                        result.address['road'] ?? result.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        result.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () => _selectResult(result),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
