part of 'products_bloc.dart';

enum FetchStatus {
  fetching,
  success,
  failed,
  init,
  showDeleteConfirmation
}

class ProductsState extends Equatable {
  const ProductsState({
    this.products = const [],
    this.cart = const [],
    this.status = FetchStatus.init,
  });
  final List<ProductsModels> products;
  final List<CartModel> cart;
  final FetchStatus status;

  ProductsState copyWith({
    List<ProductsModels>? products,
    List<CartModel>? cart,
    FetchStatus? status,
  }) {
    return ProductsState(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        products,
        status,
        cart,
      ];
}
