import 'package:flutter/material.dart';

import '../features/lost_found/presentation/pages/create_item_page.dart';
import '../features/lost_found/presentation/pages/item_list_page.dart';

class AppRouter {
  const AppRouter._();

  static const String itemList = '/';
  static const String createItem = '/create';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      createItem => MaterialPageRoute<void>(
        builder: (_) => const CreateItemPage(),
        settings: settings,
      ),
      _ => MaterialPageRoute<void>(
        builder: (_) => const ItemListPage(),
        settings: settings,
      ),
    };
  }
}
