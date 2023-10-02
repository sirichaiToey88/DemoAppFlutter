import 'package:demo_app/bloc/books/books_bloc.dart';
import 'package:demo_app/model/books.model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // WebApiService().feed();
    context.read<BooksBloc>().add(BooksEventGet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('homePage'.tr()),
      ),
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          // print("Data Book ${bookData[index].title}");
          // final books = state

          final data = state.books;
          if (data.isEmpty) {
            return const LoadingIndicator();
          }
          // return Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     ...data!.map((e) => Text(e.image))
          //   ],
          // );
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    showDetailBooks(context, data, index);
                  },
                  child: Card(
                    margin: const EdgeInsets.only(top: 2, bottom: 4, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Text(data[index].title),
                            const SizedBox(
                              height: 14,
                            ),
                            Center(
                              child: Image.network(
                                'https://img.freepik.com/free-vector/sitting-brown-puppy-dog-logo-template_1051-3347.jpg',
                                width: 250,
                                height: 150,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Future<dynamic> showDetailBooks(BuildContext context, List<Books> data, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Book Details"),
            content: Text(data[index].description),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
      strokeWidth: 5.0,
    ));
  }
}
