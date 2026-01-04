import 'dart:async';

import 'package:bli/features/map/models/models.dart';
import 'package:bli/core/services/api_service.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/core/widgets/glass_container.dart';
import 'package:bli/features/map/widgets/search_results_list.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AddressSearchWidget extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;
  final VoidCallback onClose;
  final ApiService? apiService;

  const AddressSearchWidget({
    super.key,
    required this.onLocationSelected,
    required this.onClose,
    this.apiService,
  });

  @override
  State<AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final ApiService _apiService;
  List<GeocodeResult> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    // Request focus immediately when the widget is built

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
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
      if (mounted) {
        setState(() {
          _errorMessage = 'Search failed: $e';
          _isSearching = false;
          _searchResults = [];
        });
      }
    }
  }

  void _selectResult(GeocodeResult result) {
    final location = LatLng(result.latitude, result.longitude);
    widget.onLocationSelected(location, result.displayName);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassContainer(
          borderRadius: 30,
          padding: EdgeInsets.zero,
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            autofocus: true,
            onChanged: _onSearchChanged,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search for an address...',
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: AppColors.greyMedium),
                onPressed: widget.onClose,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        if (_isSearching ||
            _errorMessage != null ||
            _searchResults.isNotEmpty ||
            (_searchController.text.isNotEmpty && _searchResults.isEmpty))
          GlassContainer(
            borderRadius: 20,
            padding: EdgeInsets.zero,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SearchResultsList(
                isSearching: _isSearching,
                errorMessage: _errorMessage,
                searchResults: _searchResults,
                showNoResults:
                    _searchResults.isEmpty && _searchController.text.isNotEmpty,
                onResultSelected: _selectResult,
              ),
            ),
          ),
      ],
    );
  }
}
