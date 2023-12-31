import 'dart:convert';

BooksModel booksModelFromJson(String str) => BooksModel.fromJson(json.decode(str));

String booksModelToJson(BooksModel data) => json.encode(data.toJson());

class BooksModel {
  final String status;
  final int code;
  final int total;
  final List<Books> data;

  BooksModel({
    required this.status,
    required this.code,
    required this.total,
    required this.data,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
        status: json["status"],
        code: json["code"],
        total: json["total"],
        data: List<Books>.from(json["data"].map((x) => Books.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Books {
  final int id;
  final String title;
  final String author;
  final String genre;
  final String description;
  final String isbn;
  final String image;
  final DateTime published;
  final String publisher;

  Books({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.isbn,
    required this.image,
    required this.published,
    required this.publisher,
  });

  factory Books.fromJson(Map<String, dynamic> json) => Books(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        genre: json["genre"],
        description: json["description"],
        isbn: json["isbn"],
        image: json["image"],
        published: DateTime.parse(json["published"]),
        publisher: json["publisher"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "genre": genre,
        "description": description,
        "isbn": isbn,
        "image": image,
        "published": "${published.year.toString().padLeft(4, '0')}-${published.month.toString().padLeft(2, '0')}-${published.day.toString().padLeft(2, '0')}",
        "publisher": publisher,
      };
}
