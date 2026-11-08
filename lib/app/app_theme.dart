import 'package:flutter/material.dart';

/// Mesmo visual do spec do Redesign, mas sem `google_fonts` para
/// compilar na pasta `BLACK TIE` (espaço no caminho quebra o hook
/// `objective_c` do `google_fonts` → `path_provider`).
/// Usa `fontFamily: 'Inter'` + helpers `_inter`.
class AppTheme {
  const AppTheme._();

  static const Color lost = Color(0xFFC0570A);
  static const Color found = Color(0xFF1A6B4A);

  static Color lostBg(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
      ? const Color(0xFF4A1800)
      : const Color(0xFFFEF0E6);

  static Color foundBg(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
      ? const Color(0xFF0A2518)
      : const Color(0xFFE6F4EE);

  static Color lostText(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
      ? const Color(0xFFFFB088)
      : lost;

  static Color foundText(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
      ? const Color(0xFF7BCCA0)
      : found;

  static const _fontFamily = 'Inter';

  /// Azul do chip "Todos" selecionado: usa o `primary` do tema claro para o
  /// chip ficar com o mesmo tom escuro no modo claro e no modo escuro.
  static final Color primaryBlue = light.colorScheme.primary;

  /// Botão "Cadastrar objeto": mesmo par de cores do modo escuro
  /// (`primaryContainer`/`onPrimaryContainer` do seed 0xFF0F4C75) aplicado
  /// também no tema claro, para o botão ter a mesma cor nos dois modos.
  static const Color fabBackground = Color(0xFF0D4A73);
  static const Color fabForeground = Color(0xFFCEE5FF);

  static TextTheme _interTextTheme(TextTheme base) =>
      base.apply(fontFamily: _fontFamily);

  static TextStyle _inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) => TextStyle(
    fontFamily: _fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );

  static ThemeData get light {
    final cs = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F4C75),
      brightness: Brightness.light,
    );
    final base = ThemeData.light();
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: cs,
      scaffoldBackgroundColor: const Color(0xFFF7F4F0),
      textTheme: _interTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: const Color(0xFFF7F4F0),
        surfaceTintColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        titleTextStyle: _inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
          height: 1.15,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.6),
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        showCheckmark: false,
        labelStyle: _inter(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        floatingLabelStyle: TextStyle(color: cs.primary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppTheme.fabBackground,
        foregroundColor: AppTheme.fabForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        extendedPadding: EdgeInsets.symmetric(horizontal: 20),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: _inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static ThemeData get dark {
    final cs = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F4C75),
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: cs,
      // Fundo da lista mais escuro que o card para garantir contraste
      // (sem isso o scaffold usa cs.surface e o card "some" no dark).
      scaffoldBackgroundColor: const Color(0xFF0A0D12),
      textTheme: _interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        titleTextStyle: _inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
          height: 1.15,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        showCheckmark: false,
        labelStyle: _inter(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppTheme.fabBackground,
        foregroundColor: AppTheme.fabForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        extendedPadding: EdgeInsets.symmetric(horizontal: 20),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: _inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
