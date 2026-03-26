import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/config/app_scroll_behaviour.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../presentation/bindings/initial_binding.dart';
import '../presentation/routes/app_pages.dart';
import '../presentation/routes/app_route_observer.dart';
import '../presentation/routes/app_routes.dart';


double kDesignHeight = 874;
double kDesignWidth = 402;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: true,
      ),
    );
    return ScreenUtilInit(
      designSize: Size(kDesignWidth, kDesignHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Hello Vibess Agen',
          theme: AppTheme.theme(),
          defaultTransition: Transition.native,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splash,
          initialBinding: InitialBinding(),
          getPages: AppPages.pages,
          navigatorObservers: [AppRouteObserver()],
          scrollBehavior: AppScrollBehavior(),
        );
      },
    );
  }
}
