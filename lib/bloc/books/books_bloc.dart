import 'package:bloc/bloc.dart';
import 'package:demo_app/model/books.model.dart';
import 'package:demo_app/src/services/webapi_service.dart';

import 'package:equatable/equatable.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc() : super(const BooksState()) {
    on<BooksEventGet>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));
      final dataResult = await WebApiService().fetchBooks();
      emit(state.copyWith(books: dataResult));
    });
  }
}
