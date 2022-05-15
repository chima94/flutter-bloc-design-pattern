import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';

abstract class AppThemeEvent extends Equatable {
  const AppThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeEvent extends AppThemeEvent {
  final bool value;
  const ThemeEvent({required this.value});
}
