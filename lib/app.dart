import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/theme.dart';

import 'common/router.gr.dart';
import 'generated/l10n.dart';

class WalletApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletThemeProvider()),
      ],
      child: Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => MaterialApp.router(
          title: "Strings.current.appName",
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
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
            navigatorObservers: () => [AutoRouteObserver()],
          ),
          routeInformationParser: _appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
