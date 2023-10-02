part of 'sent_cart_bloc.dart';

class SentCartState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String message;

  const SentCartState({
    required this.isLoading,
    required this.isSuccess,
    required this.message,
  });

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        message
      ];
}
