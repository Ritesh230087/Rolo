import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:rolo/features/auth/presentation/view/reset_password_view.dart';

class DeepLinkService {
  final GlobalKey<NavigatorState> navigatorKey;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  DeepLinkService({required this.navigatorKey});
  Future<void> init() async {
    print("[DeepLinkService] Initializing..."); 
    _appLinks = AppLinks();

    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        print("[DeepLinkService] Initial link received: $initialUri"); 
        _handleLink(initialUri);
      } else {
        print("[DeepLinkService] No initial link found."); 
      }
    } catch (e) {
      print("[DeepLinkService] Error getting initial link: $e"); 
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print("[DeepLinkService] Link received via stream: $uri");
      _handleLink(uri);
    }, onError: (err) {
      print("[DeepLinkService] Error in link stream: $err");
    });
    print("[DeepLinkService] Initialization complete. Listening for links."); 
  }

  void _handleLink(Uri uri) {
    print("[DeepLinkService] Handling link: $uri");
    if (navigatorKey.currentContext != null) {
      if (uri.scheme == 'rolo' && uri.host == 'reset-password') {
        if (uri.pathSegments.isNotEmpty) {
          final String token = uri.pathSegments.first;
          print("[DeepLinkService] Parsed token: $token. Navigating to ResetPasswordScreen..."); 
          
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(token: token),
            ),
          );
        } else {
          print("[DeepLinkService] Link is for reset password, but no token found."); 
        }
      } else {
        print("[DeepLinkService] Link received but does not match expected format."); 
      }
    } else {
      print("[DeepLinkService] Navigator context is null. Cannot navigate."); 
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
    print("[DeepLinkService] Disposed."); 
  }
}