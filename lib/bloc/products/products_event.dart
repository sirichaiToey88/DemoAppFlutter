part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductsEventFetchProduct extends ProductsEvent {}

class ProductsEventAddToCart extends ProductsEvent {
  final List<CartModel> cart;

  ProductsEventAddToCart(this.cart);
}

class ProductsIncreaseQuantityEvent extends ProductsEvent {
  final List<CartModel> cart;
  final int productId;

  ProductsIncreaseQuantityEvent(this.cart, this.productId);
}

class ProductsReduceQuantityEvent extends ProductsEvent {
  final List<CartModel> cart;
  final int productId;

  ProductsReduceQuantityEvent(this.cart, this.productId);
}

class ProductsDeleteItemInCartEvent extends ProductsEvent {
  final List<CartModel> cart;
  final int productId;

  ProductsDeleteItemInCartEvent(this.cart, this.productId);
}
