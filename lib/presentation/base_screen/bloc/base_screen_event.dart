part of 'base_screen_bloc.dart';

class BaseScreenEvent {}

class PageChange extends BaseScreenEvent{
  int page;

  PageChange({required this.page});
}
