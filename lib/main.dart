import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // A inicialização nunca pode impedir a interface de abrir: se o Firebase
  // falhar, o app ainda inicia e a listagem exibe o erro com nova tentativa
  // em vez de travar no splash nativo (tela preta/logo no Android release).
  try {
    await _initializeFirebase();
  } catch (error) {
    // Detalhe técnico preservado para diagnóstico via `flutter logs`/logcat.
    debugPrint('Firebase initialization failed: $error');
  }

  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  } catch (_) {
    // Settings só pode ser definido antes do 1º uso do Firestore.
  }

  runApp(const ProviderScope(child: ReencontrappApp()));
}

/// Inicializa o Firebase conforme a plataforma.
///
/// Na Web as opções explícitas são obrigatórias. No Android, quando a chave
/// injetada via `--dart-define-from-file` está ausente (build sem o `.env`),
/// usa a configuração nativa de `android/app/google-services.json` em vez
/// de opções com `apiKey` vazia, que impedem a criação do app Firebase.
Future<void> _initializeFirebase() {
  if (!kIsWeb &&
      const String.fromEnvironment('FIREBASE_ANDROID_API_KEY').isEmpty) {
    return Firebase.initializeApp();
  }

  // O await é obrigatório: sem ele a listagem chama FirebaseFirestore.instance
  // antes do app existir e falha com "No Firebase App has been created".
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
