import 'package:demo_app/src/booking/booking_lists/booking_lists.dart';
import 'package:demo_app/src/booking/main_screen/screen_booking_main_page.dart';
import 'package:demo_app/src/brand/main_create_brand.dart';
import 'package:demo_app/src/checkout/check_out.dart';
import 'package:demo_app/src/list_order/list_order.dart';
import 'package:demo_app/src/live_chat/live_chat.dart';
import 'package:demo_app/src/payment/payment_detail.dart';
import 'package:demo_app/src/payment/payment_method.dart';
import 'package:demo_app/src/payment/payment_qr_detail.dart';
import 'package:demo_app/src/payment/payment_success.dart';
import 'package:demo_app/src/home/home_user.dart';
import 'package:demo_app/src/payment/read.dart';
import 'package:demo_app/src/payment/scan_from_camera.dart';
import 'package:demo_app/src/shoppingCart/cart_shopping.dart';
import 'package:demo_app/src/home/home_page.dart';
import 'package:demo_app/src/product/main_product.dart';
import 'package:demo_app/src/pages/login/login_page.dart';
import 'package:demo_app/src/pages/login/register/register.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const home = 'home';
  static const login = 'login';
  static const register = 'register';
  static const listProduct = 'listProduct';
  static const cartShopping = 'cartShopping';
  static const checkOut = 'checkOut';
  static const paymentMethod = 'paymentMethod';
  static const homeUser = 'homeUser';
  static const paymentDetail = 'paymentDetail';
  static const paymentSuccess = 'paymentSuccess';
  static const qRScanPage = 'qRScanPage';
  static const scanQR = 'scanQR';
  static const qRViewExample = 'qRViewExample';
  static const testRead = 'testRead';
  static const listOrderPage = 'listOrderPage';
  static const mainScreenBooking = 'mainScreenBooking';
  static const stadiumPage = 'stadiumPage';
  static const listSlotOfStadiumPages = 'listSlotOfStadiumPages';
  static const bookingListPage = 'bookingListPage';
  static const qrCodeGalleryReaderPage = 'qrCodeGalleryReaderPage';
  static const chatPage = 'chatPage';
  static const registerPage = 'registerPage';
  static const mainCreateBrand = 'mainCreateBrand';

  static final all = <String, WidgetBuilder>{
    login: (context) => const LoginPage(),
    home: (context) => const HomePage(),
    listProduct: (context) => const ListProduct(),
    cartShopping: (context) => const CartShopping(),
    checkOut: (context) => const CheckOut(),
    paymentMethod: (context) => const PaymentMethod(),
    homeUser: (context) => const HomeUser(),
    paymentDetail: (context) => const PaymentDetail(
          paymentType: '',
          totalPriceBook: 0.00,
          paymentBooking: [],
          bookingID: '',
        ),
    paymentSuccess: (context) => const PaymentSuccess(
          total: 0.00,
        ),
    qRScanPage: (context) => const QRScanPage(
          barcodeDetails: [],
          takePhoto: 1,
          typePage: '',
        ),
    scanQR: (context) => const ScanQR(),
    qRViewExample: (context) => const QRViewExample(),
    listOrderPage: (context) => const ListOrderPage(),
    mainScreenBooking: (context) => const MainScreenBooking(
          token: '',
          userId: '',
        ),
    bookingListPage: (context) => const BookingListPage(
          token: '',
          userId: '',
        ),
    chatPage: (context) => const ChatPage(
          appId: '',
        ),
    registerPage: (context) => const RegisterPage(),
    mainCreateBrand: (context) => const MainCreateBrand(),
    //  qrCodeGalleryReaderPage: (context) => QrCodeGalleryReaderPage(),
    // stadiumPage: (context) => StadiumPage(brand:const {} ),
    // listSlotOfStadiumPages: (context) => const ListSlotOfStadiumPages(args: {},),
    // listSlotOfStadiumPages: (context, {arguments}) => ListSlotOfStadiumPages(args: arguments),
  };
}
