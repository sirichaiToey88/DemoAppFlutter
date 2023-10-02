import 'package:bloc/bloc.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/model/products_model.dart';
import 'package:demo_app/src/services/webapi_service.dart';
import 'package:equatable/equatable.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(const ProductsState()) {
    on<ProductsEventFetchProduct>((event, emit) async {
      emit(state.copyWith(products: [], cart: [], status: FetchStatus.init));
      await Future.delayed(const Duration(seconds: 1));
      List<ProductsModels> dataResult = await WebApiService().getProducts();
      emit(state.copyWith(products: dataResult, status: FetchStatus.success));
    });

    // on<ProductsEventAddToCart>((event, emit) {
    //   List<CartModel> cartItems = List.from(state.cart);
    //   // List<CartModel> cartItems = List.from(state.cart)..addAll(event.cart);

    //   for (CartModel productsToAdd in event.cart) {
    //     int existingIndex = cartItems.indexWhere((cartItems) => cartItems.id == productsToAdd.id);
    //     if (existingIndex != -1) {
    //       int newCount = cartItems[0].count + 1;
    //       print("NEW COUNT ${newCount}");
    //       print("existingIndex ${existingIndex}");
    //       cartItems[existingIndex] = cartItems[existingIndex].copyWith(count: newCount);
    //       print("existingIndex_add ${cartItems[existingIndex].count}");
    //     } else {
    //       cartItems.add(productsToAdd);
    //     }
    //   }
    //   // cartItems[0].count =12;
    //   print("Work This count : ${cartItems[0].count}");
    //   // print("Work This price : ${cartItems[0].price}");
    //   // print("Work This id : ${cartItems[0].id}");
    //   // print("Work This cat : ${cartItems[0].category}");
    //   emit(state.copyWith(cart: cartItems));
    // });

    // on<ProductsEventAddToCart>((event, emit) async {
    //   //Create list and Read data from state
    //   List<CartModel> cartItems = List.from(state.cart);

    //   for (CartModel productsToAdd in event.cart) {
    //     // Check if a product with the same ID already exists in the cart
    //     int existingIndex = cartItems.indexWhere((cartItems) => cartItems.id == productsToAdd.id);
    //     if (existingIndex != -1) {
    //       // Product already exists in the cart, increase its count
    //       int newQuantity = (cartItems[existingIndex].quantity) + 1;
    //       double newPrice = (cartItems[existingIndex].total) * newQuantity;
    //       cartItems[existingIndex] = cartItems[existingIndex].copyWith(quantity: newQuantity, total: newPrice);
    //     } else {
    //       cartItems.add(productsToAdd);
    //     }
    //   }
    //   emit(state.copyWith(cart: cartItems));
    // });

    on<ProductsEventAddToCart>((event, emit) async {
      // Create a new list to hold the updated cart items
      List<CartModel> cartItems = List.from(state.cart);

      for (CartModel productToAdd in event.cart) {
        // Check if a product with the same ID already exists in the cart
        int existingIndex = cartItems.indexWhere((cartItem) => cartItem.id == productToAdd.id);

        if (existingIndex != -1) {
          // Product already exists in the cart, increase its quantity and update the total price
          int newQuantity = cartItems[existingIndex].quantity + 1;
          double newTotal = productToAdd.price * newQuantity;
          cartItems[existingIndex] = cartItems[existingIndex].copyWith(quantity: newQuantity, total: newTotal);
        } else {
          // Product doesn't exist in the cart, add it with the initial quantity and total price
          cartItems.add(productToAdd.copyWith(quantity: 1, total: productToAdd.price));
        }
      }

      emit(state.copyWith(cart: cartItems));
    });

    on<ProductsIncreaseQuantityEvent>((event, emit) {
      List<CartModel> cartItems = List.from(state.cart);

      for (CartModel productToUpdate in event.cart) {
        // Find the product by ID
        int existingIndex = cartItems.indexWhere((cartItem) => cartItem.id == productToUpdate.id && cartItem.id == event.productId);
        if (existingIndex != -1) {
          // Update the quantity and price
          CartModel existingProduct = cartItems[existingIndex];
          int newQuantity = existingProduct.quantity + 1;
          double newPrice = existingProduct.price * newQuantity;

          // Create a new CartModel instance with updated values
          CartModel updatedProduct = existingProduct.copyWith(quantity: newQuantity, total: newPrice);

          // Replace the existing product in the cartItems list
          cartItems[existingIndex] = updatedProduct;
        }
      }

      emit(state.copyWith(cart: cartItems));
    });

    on<ProductsReduceQuantityEvent>((event, emit) {
      List<CartModel> cartItems = List.from(state.cart);

      for (CartModel productToUpdate in event.cart) {
        // Find the product by ID
        int existingIndex = cartItems.indexWhere((cartItem) => cartItem.id == productToUpdate.id && cartItem.id == event.productId);
        if (existingIndex != -1) {
          // Update the quantity and price
          CartModel existingProduct = cartItems[existingIndex];
          int newQuantity = existingProduct.quantity - 1;
          double newPrice = existingProduct.price * newQuantity;

          // Create a new CartModel instance with updated values
          CartModel updatedProduct = existingProduct.copyWith(quantity: newQuantity, total: newPrice);

          // Replace the existing product in the cartItems list
          cartItems[existingIndex] = updatedProduct;
        }
      }

      emit(state.copyWith(cart: cartItems));
    });

    on<ProductsDeleteItemInCartEvent>((event, emit) {
      List<CartModel> cartItems = List.from(state.cart);

      try {
        // Find the product by ID
        cartItems.removeWhere((cartItem) => cartItem.id == event.productId);
      } catch (e) {}

      emit(state.copyWith(cart: cartItems));
    });
    
  }
}
