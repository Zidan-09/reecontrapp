import 'package:flutter/material.dart';

import '../features/welcome/presentation/pages/welcome_page.dart';
import '../features/lost_found/presentation/pages/create_item_page.dart';
import '../features/lost_found/presentation/pages/item_list_page.dart';

class AppRouter {
  const AppRouter._();

  static const String welcome = '/';
  static const String itemList = '/items';
  static const String createItem = '/create';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      createItem => MaterialPageRoute<void>(
        builder: (_) => const CreateItemPage(),
        settings: settings,
      ),
      itemList => MaterialPageRoute<void>(
        builder: (_) => const ItemListPage(),
        settings: settings,
      ),
      _ => MaterialPageRoute<void>(
        builder: (_) => const WelcomePage(),
        settings: settings,
      ),
    };
  }
}
