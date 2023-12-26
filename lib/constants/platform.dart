import "package:flutter/foundation.dart";

String checkForPlatForm() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'android';
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return 'iOS';
    // } else if (defaultTargetPlatform == TargetPlatform.windows) {
    //   return 'Window';
  } else {
    return 'Web';
  }
}
