import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_theme.dart';

class ReencontrappApp extends StatelessWidget {
  const ReencontrappApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reencontrapp',
      theme: AppTheme.light,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reencontrapp')),
      body: const Center(child: Text('Bem-vindo ao Reencontrapp')),
    );
  }
}
