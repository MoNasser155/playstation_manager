import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'console_app.dart';
import 'core/constants/app_constants.dart';
import 'core/languages/languages.dart';
// import 'core/services/backup_service.dart';
import 'core/shared/di.dart';
import 'core/utils/bloc_observer.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  Bloc.observer = CustomBlocObserver();
  await Future.wait([
    windowManager.ensureInitialized(),
    EasyLocalization.ensureInitialized(),
    ScreenUtil.ensureScreenSize(),
    Supabase.initialize(
      url: 'https://bxodxfdpacqtrqtxmvdt.supabase.co',
      publishableKey: 'sb_publishable_K0M7W2o1FsGsbWVOVW9ySw_OW2TLYip',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    ),
  ]);

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1000, 700),
    size: Size(1200, 720),
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    EasyLocalization(
      supportedLocales: Languages.suppoerLocales,
      path: AppConstants.translationPath,
      startLocale: Languages.english.locale,
      child: const ConsoleApp(),
    ),
  );
}
