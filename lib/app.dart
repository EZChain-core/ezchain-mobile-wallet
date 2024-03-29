import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';

class WalletApp extends StatelessWidget {
  final _appRouter = getIt<AppRouter>();

  WalletApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletThemeProvider()),
      ],
      child: Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => MaterialApp.router(
          title: Strings.current.appName,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: provider.themeMode.secondary,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: provider.themeMode,
          localizationsDelegates: const [
            Strings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: Strings.delegate.supportedLocales,
          locale: provider.locale,
          debugShowCheckedModeBanner: false,
          routerDelegate: AutoRouterDelegate(
            _appRouter,
            navigatorObservers: () => [
              AutoRouteObserver(),
              StatusBarRouterObserver(),
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
            ],
          ),
          routeInformationParser: _appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
