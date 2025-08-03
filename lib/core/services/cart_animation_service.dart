import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartAnimationService {
  static final GlobalKey cartKey = GlobalKey();

  static Future<void> runFlyAnimation({
    required GlobalKey itemKey,
    required BuildContext context,
    required String imageUrl,
  }) async {
    // **THE FIX**: Check if both the item and the cart icon are actually on the screen.
    if (itemKey.currentContext == null || cartKey.currentContext == null) {
      // If either is not available (e.g., cart tab is not active),
      // we can't run the animation. Silently exit.
      return;
    }

    final RenderBox itemRenderBox = itemKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox cartRenderBox = cartKey.currentContext!.findRenderObject() as RenderBox;

    final Offset itemPosition = itemRenderBox.localToGlobal(Offset.zero);
    final Offset cartPosition = cartRenderBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          builder: (context, value, child) {
            final double x = itemPosition.dx + (cartPosition.dx + (cartRenderBox.size.width / 2) - itemPosition.dx) * value;
            final double y = itemPosition.dy + (cartPosition.dy + (cartRenderBox.size.height / 2) - itemPosition.dy) * value;
            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: 1.0 - (value * 0.5),
                child: Transform.scale(
                  scale: 1.0 - value,
                  child: child,
                ),
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)],
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    await Future.delayed(const Duration(milliseconds: 700));
    overlayEntry.remove();
  }
}