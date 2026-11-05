import 'dart:async';

/// Kinds of communication failures understood by the app.
///
/// Only the cases required by CARD-014 are represented: the common
/// offline case and a generic fallback. Categories beyond these two
/// are intentionally not introduced.
enum CommunicationFailureKind { noConnection, unknown }

/// Single application-level failure for cloud communication.
///
/// Thrown by the Data layer for both reading and writing so that the
/// listing state (CARD-015), the form state (CARD-016) and the screens
/// (CARD-021 and CARD-027) share the same treatment.
///
/// [userMessage] is the only text that may reach the interface. It is
/// in Portuguese, contains no error code, exception fragment or URL
/// and always hints that the user can try again. [cause] preserves the
/// technical details for team diagnosis and must never be displayed.
class CommunicationFailure implements Exception {
  const CommunicationFailure.noConnection([this.cause])
    : kind = CommunicationFailureKind.noConnection;

  const CommunicationFailure.unknown([this.cause])
    : kind = CommunicationFailureKind.unknown;

  final CommunicationFailureKind kind;

  final Object? cause;

  String get userMessage {
    switch (kind) {
      case CommunicationFailureKind.noConnection:
        return 'Sem conexão com a internet. '
            'Verifique sua conexão e tente novamente.';
      case CommunicationFailureKind.unknown:
        return 'Não foi possível concluir a operação. Tente novamente.';
    }
  }

  @override
  String toString() => userMessage;
}

/// Maps any failure to a [CommunicationFailure].
///
/// Already-mapped failures are returned unchanged so that reading and
/// writing share exactly the same result. Timeouts and messages that
/// look like a connectivity problem become [noConnection]; everything
/// else becomes [unknown] without exposing technical details.
CommunicationFailure toCommunicationFailure(Object error) {
  if (error is CommunicationFailure) {
    return error;
  }
  if (error is TimeoutException) {
    return CommunicationFailure.noConnection(error);
  }
  if (_looksLikeNoConnection('$error')) {
    return CommunicationFailure.noConnection(error);
  }
  return CommunicationFailure.unknown(error);
}

/// Detects connectivity problems without importing `dart:io`, which is
/// unavailable on Web. Matches the text of [SocketException] and
/// equivalent network messages instead of their types.
bool _looksLikeNoConnection(String message) {
  final normalized = message.toLowerCase();
  const hints = [
    'socketexception',
    'failed host lookup',
    'failed hostlookup',
    'network is unreachable',
    'no address associated',
    'no internet',
    'connection failed',
    'connection reset',
    'network request failed',
    // Cloud Firestore reports an offline device as `unavailable`
    // (and slow networks as `deadline-exceeded`).
    'unavailable',
    'deadline-exceeded',
    'deadline exceeded',
    'sem conexão',
    'sem internet',
  ];
  return hints.any(normalized.contains);
}
