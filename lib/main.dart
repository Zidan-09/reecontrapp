import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // O await é obrigatório: sem ele a listagem chama FirebaseFirestore.instance
  // antes do app existir e falha com "No Firebase App has been created".
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  } catch (_) {
    // Settings só pode ser definido antes do 1º uso do Firestore.
  }

  runApp(const ProviderScope(child: ReencontrappApp()));
}
