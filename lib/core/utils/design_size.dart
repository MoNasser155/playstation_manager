import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

setDesignSize(BuildContext context) {
   if (kIsWeb) {
      return const Size(1920, 1080); 
    }
    
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.windows ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.linux) {
      return const Size(1920, 1080); 
    }
    
    return const Size(375, 812); 
}
