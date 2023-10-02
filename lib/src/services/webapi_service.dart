import 'dart:convert';

import 'package:demo_app/model/bookingStadium/add_booking_stadium.dart';
import 'package:demo_app/model/bookingStadium/bookingPayment.dart';
import 'package:demo_app/model/bookingStadium/createBrand.dart';
import 'package:demo_app/model/bookingStadium/find_slot/find_slot_of_stadium.dart';
import 'package:demo_app/model/bookingStadium/find_slot/search_slot.dart';
import 'package:demo_app/model/bookingStadium/listBrandWithStadium.dart';
import 'package:demo_app/model/bookingStadium/list_bookings/list_booking.dart';
import 'package:demo_app/model/books.model.dart';
import 'package:demo_app/model/list_product/order_data.dart';
import 'package:demo_app/model/list_product/order_user.dart';
import 'package:demo_app/model/products_model.dart';
import 'package:demo_app/model/sent_cart_model.dart';
import 'package:demo_app/utils/custom_toast/show_toast_top.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WebApiService {
  final Dio dio;
  final Map<String, String> headers;

  WebApiService()
      : dio = Dio(),
        headers = {
          'Content-Type': 'application/json',
        };

  Future<List<Books>> fetchBooks() async {
    dio.interceptors.add(LogInterceptor());
    try {
      final result = await dio.get("https://fakerapi.it/api/v1/books", options: Options(headers: headers));
      final dataRes = booksModelFromJson(jsonEncode(result.data));
      return dataRes.data;
    } catch (e) {
      throw Exception('Failed to fetch books');
    }
  }

  Future<List<ProductsModels>> getProducts() async {
    try {
      final response = await dio.get("https://fakestoreapi.com/products", options: Options(headers: headers));
      final List<dynamic> products = response.data;
      return products.map((json) => ProductsModels.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products');
    }
  }

  Future<String?> authentcateUser(String email, String mobile) async {
    Map<String, dynamic> payload = {
      'email': 'jiradech.saardnuam@krungsri.com',
      'mobile': '0655127426'
    };

    String jsonPayload = jsonEncode(payload);

    try {
      final response = await dio.post('http://localhost:8080/login', data: jsonPayload, options: Options(headers: headers));

      if (response.statusCode == 200) {
        final responseBody = response.data;
        return responseBody;
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> sentCartToAPI(List<SentCartModel> cart, String token) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await dio.post('http://localhost:8080/shopping', data: cart, options: Options(headers: headersWithToken));
    } catch (e) {
      throw Exception('Failed to send cart to API');
    }
  }

  Future<OrderData> getListOrder(String token, String userId) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };

    Map<String, dynamic> payload = {
      'User_id': userId
    };

    String jsonPayload = jsonEncode(payload);

    try {
      final response = await dio.post('http://localhost:8080/SearchOrdeyByID', data: jsonPayload, options: Options(headers: headersWithToken));
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['order'];
        double responseTotal = response.data['total'].toDouble();

        // Assuming the response is a list of order data
        List<Order> orders = responseData.map<Order>((data) => Order.fromJson(data)).toList();

        // Create a map to group orders by orderId
        Map<String, List<Order>> groupedOrders = {};
        for (Order order in orders) {
          if (groupedOrders.containsKey(order.orderId)) {
            groupedOrders[order.orderId]!.add(order);
          } else {
            groupedOrders[order.orderId] = [
              order
            ];
          }
        }
        return OrderData(
          groupedOrders: groupedOrders,
          total: responseTotal,
        );
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      throw Exception('Failed to get list of orders');
    }
  }

  Future<Map<String, ListBrandWithStadium>> getBrandWithStadium(String token, String userId) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };

    Map<String, dynamic> payload = {
      'User_id': userId
    };

    String jsonPayload = jsonEncode(payload);

    try {
      final response = await dio.get('http://localhost:8080/listAllBrand', data: jsonPayload, options: Options(headers: headersWithToken));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;

        Map<String, ListBrandWithStadium> brandData = responseData.map((k, v) => MapEntry<String, ListBrandWithStadium>(k, ListBrandWithStadium.fromJson(v)));

        return brandData;
      } else {
        throw Exception('Failed to fetch brand data');
      }
    } catch (e) {
      throw Exception('Failed to get brand with stadium data');
    }
  }

  Future<List<FindSlotInStadium>> findSlotOfStadium(
    String token,
    String userId,
    Map<String, dynamic> dataRequestSlot,
  ) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await dio.post('http://localhost:8080/Findslot', data: dataRequestSlot, options: Options(headers: headersWithToken));
      if (response.statusCode == 200) {
        List<FindSlotInStadium> slotTime = findSlotInStadiumFromJson(json.encode(response.data));

        return slotTime;
      } else if (response.statusCode == 204) {
        return List<FindSlotInStadium>.empty();
      } else {
        throw Exception('Failed to fetch slot data');
      }
    } catch (e) {
      throw Exception('Failed to find slot of stadium');
    }
  }

  Future<String?> sentBookingStadiumToAPI(List<AddBookingStadium> bookingStadium, String token) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await dio.post('http://localhost:8080/AddBooking', data: bookingStadium, options: Options(headers: headersWithToken));
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'failure';
      }
    } catch (e) {
      throw Exception('Failed to send cart to API');
    }
  }

  Future<List<ListBookings>> getAllBookings(String token, String userId) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };

    Map<String, dynamic> payload = {
      'User_id': userId
    };

    String jsonPayload = jsonEncode(payload);

    try {
      final response = await dio.post('http://localhost:8080/ListBooking', data: jsonPayload, options: Options(headers: headersWithToken));
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<ListBookings> bookingList = responseData.map((json) => ListBookings.fromJson(json)).toList();

        // String jsonString = json.encode(bookingList);
        // print("Response ${jsonString}");
        return bookingList;
      } else {
        throw Exception('Failed to fetch brand data');
      }
    } catch (e) {
      throw Exception('Failed to get brand with stadium data');
    }
  }

  Future<String?> sentBookingPaymentToAPI(List<BookingsPayment> bookingPayment, String token) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await dio.post('http://localhost:8080/PaymentBooking', data: bookingPayment, options: Options(headers: headersWithToken));
    } catch (e) {
      throw Exception('Failed to send booking payment to API');
    }
  }

  Future<String?> sentCancelBookingToAPI(String token, String userId, String bookingId) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> payload = {
      'User_id': userId,
      'Id': bookingId
    };

    String jsonPayload = jsonEncode(payload);
    try {
      final response = await dio.post('http://localhost:8080/CancelBookings', data: jsonPayload, options: Options(headers: headersWithToken));
    } catch (e) {
      throw Exception('Failed to send cancel payment to API');
    }
  }

  Future<String?> saveBrandStatdiumToAPI(String token, List<CreateBrand> brandData) async {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await dio.post('http://localhost:8080/AddNewBrandMobile', data: brandData, options: Options(headers: headersWithToken));
    } catch (e) {
      showCustomToastTop('QR not correct', backgroundColor: Colors.red, textColor: Colors.white);

      throw Exception('Failed to send data brand and statium to API');
    }
  }
}
