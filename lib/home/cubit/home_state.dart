import 'package:equatable/equatable.dart';

enum HomeTab { todos, stats, settings }

class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.todos});

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
