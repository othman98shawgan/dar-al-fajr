import 'dart:async';
import 'package:flutter/widgets.dart';

Future<void> prefetchImageNoContext(ImageProvider provider) {
  final completer = Completer<void>();
  final stream = provider.resolve(const ImageConfiguration());
  late final ImageStreamListener listener;
  listener = ImageStreamListener((_, __) {
    stream.removeListener(listener);
    if (!completer.isCompleted) completer.complete();
  }, onError: (_, __) {
    stream.removeListener(listener);
    if (!completer.isCompleted) completer.complete(); // fail open
  });
  stream.addListener(listener);
  return completer.future;
}
