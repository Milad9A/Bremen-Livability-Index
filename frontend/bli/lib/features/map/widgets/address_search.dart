import 'dart:async';

import 'package:bli/features/map/models/models.dart';
import 'package:bli/core/services/api_service.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

typedef SearchStateCallback =
    void Function(
      List<GeocodeResult> results,
      bool isSearching,
      String? errorMessage,
      bool hasQuery,
    );

class AddressSearchWidget extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;
  final VoidCallback onClose;
  final SearchStateCallback? onSearchStateChanged;
  final ApiService? apiService;

  const AddressSearchWidget({
    super.key,
    required this.onLocationSelected,
    required this.onClose,
    this.onSearchStateChanged,
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
      _notifySearchState();
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
    _notifySearchState();

    try {
      final results = await _apiService.geocodeAddress(query, limit: 5);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
      _notifySearchState();
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to search. Please try again.';
        _searchResults = [];
        _isSearching = false;
      });
      _notifySearchState();
    }
  }

  void _notifySearchState() {
    widget.onSearchStateChanged?.call(
      _searchResults,
      _isSearching,
      _errorMessage,
      _searchController.text.isNotEmpty,
    );
  }

  void selectResult(GeocodeResult result) {
    final location = LatLng(result.latitude, result.longitude);
    widget.onLocationSelected(location, result.displayName);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    // ONLY return the input field - results rendered separately in MapScreen
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primary.withValues(alpha: 0.3),
          selectionHandleColor: AppColors.primary,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        autofocus: true,
        onChanged: _onSearchChanged,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search for an address...',
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: AppColors.greyMedium),
            onPressed: widget.onClose,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
