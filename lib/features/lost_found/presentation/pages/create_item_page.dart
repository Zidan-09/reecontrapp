import 'package:flutter/material.dart';

import '../widgets/item_form.dart';

class CreateItemPage extends StatelessWidget {
  const CreateItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar objeto')),
      body: const SafeArea(child: ItemForm()),
    );
  }
}
