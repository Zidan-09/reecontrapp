import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/item_form.dart';

class CreateItemPage extends StatelessWidget {
  const CreateItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text(
          'Cadastrar objeto',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: const ColoredBox(
        color: Color(0xFFF0F0F0),
        child: SafeArea(bottom: false, child: ItemForm()),
      ),
    );
  }
}
