part of 'books_bloc.dart';

class BooksState extends Equatable {
  const BooksState({
    this.books = const [],
  });
  final List<Books> books;

  BooksState copyWith({
    List<Books>? books,
  }) {
    return BooksState(
      books: books ?? this.books,
    );
  }

  @override
  List<Object> get props => [
        books,
      ];
}
