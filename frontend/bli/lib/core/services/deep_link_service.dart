import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class DeepLinkService {
  final AuthBloc _authBloc;
  final AuthService _authService;
  final AppLinks _appLinks;
  StreamSubscription<Uri?>? _linkSubscription;

  DeepLinkService({
    required AuthBloc authBloc,
    required AuthService authService,
    AppLinks? appLinks,
  }) : _authBloc = authBloc,
       _authService = authService,
       _appLinks = appLinks ?? AppLinks();

  void init() {
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // On web, check the current URL for email link parameters
    if (kIsWeb) {
      await _handleWebEmailLink();
      return;
    }

    // On mobile, use app_links package
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        await _handleLink(initialLink);
      }
    } catch (e) {
      debugPrint('DeepLinkService: Error initializing deep links: $e');
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleLink(uri);
      },
      onError: (err) {
        debugPrint('DeepLinkService: Error in link stream: $err');
      },
    );
  }

  Future<void> _handleWebEmailLink() async {
    try {
      // Uri.base gives us the current page URL on web
      final currentUrl = Uri.base.toString();
      debugPrint('DeepLinkService: Checking web URL: $currentUrl');

      final uri = Uri.base;

      // Check if this is an email sign-in link
      if (uri.queryParameters.containsKey('oobCode') ||
          uri.queryParameters.containsKey('mode')) {
        debugPrint('DeepLinkService: Found email link parameters');

        final email = await _authService.getPendingEmail();
        debugPrint('DeepLinkService: Pending email: $email');

        if (email != null) {
          _authBloc.add(AuthEvent.emailLinkVerified(email, currentUrl));
        } else {
          // Cross-device flow: prompt user for email
          debugPrint('DeepLinkService: No pending email, will prompt user');
          _authBloc.add(AuthEvent.emailLinkPendingEmail(currentUrl));
        }
      }
    } catch (e) {
      debugPrint('DeepLinkService: Error handling web email link: $e');
    }
  }

  Future<void> _handleLink(Uri uri) async {
    final link = uri.toString();

    if (uri.queryParameters.containsKey('oobCode') ||
        uri.queryParameters.containsKey('mode') ||
        uri.path.contains('/login') ||
        uri.path.contains('/email-signin')) {
      final email = await _authService.getPendingEmail();

      if (email != null) {
        _authBloc.add(AuthEvent.emailLinkVerified(email, link));
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
