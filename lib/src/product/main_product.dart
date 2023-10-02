import 'package:demo_app/bloc/list_order/list_order_bloc.dart';
import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/helper/helper_function.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/product/cart_noti.dart';
import 'package:demo_app/src/product/widget_list_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListProduct extends StatefulWidget {
  final List<CartModel>? cartData;

  const ListProduct({Key? key, this.cartData}) : super(key: key);

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  String userName = "";
  String email = "";
  List<CartModel> cartData = [];
  @override
  void initState() {
    super.initState();
    gettingUserData();
    context.read<ProductsBloc>().add(ProductsEventFetchProduct());
    cartData = widget.cartData ?? [];

    // if (ModalRoute.of(context) != null) {
    //   final arguments = ModalRoute.of(context)!.settings.arguments;
    //   if (arguments != null) {
    //     cartData = arguments as List<CartModel>;
    //   }
    // }

    if (Navigator.of(context).canPop()) {
      setState(() {
        refreshListProduct();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ใช้ ModalRoute ใน didChangeDependencies เมื่อตัวแปร context เรียบร้อยแล้ว
    final previousPageArgs = ModalRoute.of(context)?.settings.arguments;
    if (previousPageArgs != null && previousPageArgs is List<CartModel>) {
      cartData = previousPageArgs;
    }
  }

  void refreshListProduct() {
    // context.read<ProductsBloc>().add(ProductsEventFetchProduct());
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailSF().then((value) {
      email = value!;
      setState(() {
        email = value;
      });
    });
    await HelperFunction.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/icons/teamwork.png',
              width: 40,
              height: 40,
            ),
            const Spacer(),
            const BuildGetListOrder(),
            const SizedBox(width: 20),
            BuildCartNoti(
              cartData: cartData,
            ),
            const SizedBox(width: 20),
            const Icon(Icons.notifications),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.homeUser);
                // AuthService().signOut();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const LoginPage()),
                // );
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          final data = state.products;
          if (state.status.toString() == 'FetchStatus.init') {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                strokeWidth: 5.0,
              ),
            );
          }
          return BuildListProduct(data: data);
        },
      ),
    );
  }
}

class BuildGetListOrder extends StatelessWidget {
  const BuildGetListOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final token = state.token;
        final userId = state.user[0].userId;
        return IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            context.read<ListOrderBloc>().add(ListOrderFetchEvent(token, userId));
            Navigator.pushNamed(context, AppRoute.listOrderPage);
          },
        );
      },
    );
  }
}
