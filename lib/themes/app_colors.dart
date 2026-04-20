import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color card;
  final Color border;
  final Color softBlue;
  final Color success;
  final Color error;
  final Color textSecondary;

  const AppColors({
    required this.card,
    required this.border,
    required this.softBlue,
    required this.success,
    required this.error,
    required this.textSecondary,
  });

  @override
  AppColors copyWith({
    Color? card,
    Color? border,
    Color? softBlue,
    Color? success,
    Color? error,
    Color? textSecondary,
  }) {
    return AppColors(
      card: card ?? this.card,
      border: border ?? this.border,
      softBlue: softBlue ?? this.softBlue,
      success: success ?? this.success,
      error: error ?? this.error,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      softBlue: Color.lerp(softBlue, other.softBlue, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}