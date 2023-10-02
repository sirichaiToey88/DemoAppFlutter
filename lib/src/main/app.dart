//Pubilc context to all file for use in navigator context
import 'package:demo_app/bloc/booking_stadium/booking_stadium_bloc.dart';
import 'package:demo_app/bloc/books/books_bloc.dart';
import 'package:demo_app/bloc/brandStadium/brand_stadium_bloc.dart';
import 'package:demo_app/bloc/list_brandStadium/list_brand_stadium_bloc.dart';
import 'package:demo_app/bloc/list_order/list_order_bloc.dart';
import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/bloc/sent_cart/sent_cart_bloc.dart';
import 'package:demo_app/bloc/transfer_qr/transfer_qr_bloc.dart';
import 'package:demo_app/helper/helper_function.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/pages/login/login_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorState = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.changeLocale(newLocale);
  }

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  final loginBloc = BlocProvider(create: (context) => LoginBloc());
  final booksBloc = BlocProvider(create: (context) => BooksBloc());
  final productsBloc = BlocProvider(create: (context) => ProductsBloc());
  final sentCartBloc = BlocProvider(create: (context) => SentCartBloc());
  final transferQR = BlocProvider(create: (context) => TransferQrBloc());
  final listOrderUser = BlocProvider(create: (context) => ListOrderBloc());
  final listBrandWithStadium = BlocProvider(create: (context) => ListBrandStadiumBloc());
  final bookingStadiumBloc = BlocProvider(create: (context) => BookingStadiumBloc());
  final brandStadiumBloc = BlocProvider(create: (context) => BrandStadiumBloc());

  bool isRequestCameraPermission = false;
  bool isRequestGalleryPermission = false;
  bool isRequestLocationPermission = false;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    //Firebase
    // getUserLoggedInStatus();
    _loadUserLoggedInStatus();
    _checkPermissionsAndRequest();
  }

  void _loadUserLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      _isSignedIn = isLoggedIn;
    });
  }

  //Firebase
  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isSignedIn = value;
      }
    });
  }

  Future<void> _checkPermissionsAndRequest() async {
    if (await _arePermissionsGranted()) {
      // Permissions are already granted, proceed with your logic here
      return;
    }

    if (!isRequestCameraPermission) {
      setState(() {
        isRequestCameraPermission = true;
      });

      // Request the permissions
      await _requestPermissions();

      setState(() {
        isRequestCameraPermission = false;
      });

      // Check the permissions again after the request
      if (await _arePermissionsGranted()) {
        // Permissions granted after request, proceed with your logic here
        return;
      } else {
        // Handle the case when permissions are still not granted after the request
        // You can show an alert dialog or guide the user to enable permissions manually.
      }
    }
  }

  void _handleDeniedPermissions(BuildContext context) {
    _showPermissionDeniedDialog(context);
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('การเข้าถึงสิทธิ์ถูกปฏิเสธ'),
          content: Text('โปรดเปิดใช้งานสิทธิ์กล้องและพื้นที่จัดเก็บข้อมูลเพื่อให้แอปพลิเคชันทำงานได้อย่างถูกต้อง'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('ตั้งค่า'),
            ),
          ],
        );
      },
    );
  }

  void _handleGrantedPermissions(BuildContext context) {
    // Handle the case when permissions are granted after the request
    // You can proceed with your logic here or show a success message.
  }

  Future<bool> _arePermissionsGranted() async {
    return await Permission.camera.isGranted && await Permission.storage.isGranted;
  }

  Future<void> _requestPermissions() async {
    // Check if each permission is not already granted before requesting
    List<Permission> permissionsToRequest = [];
    if (!await Permission.camera.isGranted) {
      permissionsToRequest.add(Permission.camera);
    }
    if (!await Permission.storage.isGranted) {
      permissionsToRequest.add(Permission.storage);
    }
    if (!await Permission.location.isGranted) {
      permissionsToRequest.add(Permission.location);
    }
    if (!await Permission.locationAlways.isGranted) {
      permissionsToRequest.add(Permission.locationAlways);
    }
    if (!await Permission.locationWhenInUse.isGranted) {
      permissionsToRequest.add(Permission.locationWhenInUse);
    }

    // Request only the permissions that are not already granted
    Map<Permission, PermissionStatus> statuses = await permissionsToRequest.request();

    // Handle the statuses and show the appropriate messages if needed
    if (statuses.containsKey(Permission.camera) && statuses[Permission.camera]!.isDenied) {
      _handleDeniedPermissions(context);
    }
    if (statuses.containsKey(Permission.storage) && statuses[Permission.storage]!.isDenied) {
      _handleDeniedPermissions(context);
    }
    if (statuses.containsKey(Permission.location) && statuses[Permission.location]!.isDenied) {
      _handleDeniedPermissions(context);
    }
    if (statuses.containsKey(Permission.locationAlways) && statuses[Permission.locationAlways]!.isDenied) {
      _handleDeniedPermissions(context);
    }
    if (statuses.containsKey(Permission.locationWhenInUse) && statuses[Permission.locationWhenInUse]!.isDenied) {
      _handleDeniedPermissions(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        loginBloc,
        booksBloc,
        productsBloc,
        sentCartBloc,
        transferQR,
        listOrderUser,
        listBrandWithStadium,
        bookingStadiumBloc,
        brandStadiumBloc,
      ],
      child: MaterialApp(
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: ThemeData.dark(),
        routes: AppRoute.all,
        navigatorKey: navigatorState,
        home: const LoginPage(),
      ),
    );
  }
}
