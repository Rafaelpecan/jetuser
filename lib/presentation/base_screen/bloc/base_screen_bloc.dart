import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
part 'base_screen_event.dart';
part 'base_screen_state.dart';

class BaseScreenBloc extends Bloc<BaseScreenEvent, BaseScreenState> {

  final PageController pageController;
  int page = 0;


  BaseScreenBloc({required this.pageController}) : super(BaseScreenInitial()) {
    on<PageChange>((pageChange));
  }

  pageChange(PageChange event, Emitter<BaseScreenState> emit) {
    emit(PageChanging());
    if(event.page == page){
      emit(PageChanged());
    } else{
      page = event.page;
      pageController.jumpToPage(event.page);
      emit(PageChanged());
    }
  }
}