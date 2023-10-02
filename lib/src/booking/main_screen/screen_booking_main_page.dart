import 'package:demo_app/bloc/list_brandStadium/list_brand_stadium_bloc.dart';
import 'package:demo_app/src/booking/booking_lists/booking_lists.dart';
import 'package:demo_app/src/booking/list_stadium/list_stadium_page.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/main/app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenBooking extends StatefulWidget {
  final String token;
  final String userId;

  const MainScreenBooking({Key? key, required this.token, required this.userId}) : super(key: key);

  @override
  State<MainScreenBooking> createState() => _MainScreenBookingState();
}

class _MainScreenBookingState extends State<MainScreenBooking> {
  List<StadiumInfo> stadiumList = [];
  @override
  void initState() {
    super.initState();
    context.read<ListBrandStadiumBloc>().add(ListBrandStadiumFetchEvent(widget.token, widget.userId));
    // BlocProvider.of<ListBrandStadiumBloc>(context).add(ListBrandStadiumFetchEvent(widget.token, widget.userId));
  }

  void _addStadium() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String openTime = '';
        String closeTime = '';
        String phoneNumber = '';

        return AlertDialog(
          title: const Text('เพิ่มข้อมูลสนาม'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'ชื่อสนาม'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'เวลาเปิด'),
                  onChanged: (value) {
                    openTime = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'เวลาปิด'),
                  onChanged: (value) {
                    closeTime = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'เบอร์โทร'),
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  stadiumList.add(StadiumInfo(
                    name: name,
                    openTime: openTime,
                    closeTime: closeTime,
                    phoneNumber: phoneNumber,
                  ));
                });

                Navigator.of(context).pop();
              },
              child: const Text('เพิ่ม'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('bookingPage'.tr()),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              navigatorState.currentContext!,
              AppRoute.homeUser,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.view_list,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingListPage(token: widget.token, userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ListBrandStadiumBloc, ListBrandStadiumState>(
        builder: (context, state) {
          if (state.status.toString() == 'FetchStatus.init') {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                strokeWidth: 5.0,
              ),
            );
          }
          final data = state.dataResult;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final brandEntry = data.entries.toList()[index];
              final brand = brandEntry.value;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StadiumPage(brand: brand),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'brand_${brand.id}',
                    child: Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              brand.brandTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '${'open'.tr()} : ${brand.timeOpen}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '${'close'.tr()} : ${brand.timeClose}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '${'tell'.tr()} : ${brand.tell}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StadiumPage(brand: brand),
                                  ),
                                );
                                // Navigator.pushNamed(
                                //   context,
                                //   AppRoute.stadiumPage,
                                //   arguments: brand,
                                // );
                              },
                              child: Text('seeDetail'.tr()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _addStadium,
        onPressed: () {
          Navigator.pushReplacementNamed(
            navigatorState.currentContext!,
            AppRoute.mainCreateBrand,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class StadiumInfo {
  final String name;
  final String openTime;
  final String closeTime;
  final String phoneNumber;

  StadiumInfo({
    required this.name,
    required this.openTime,
    required this.closeTime,
    required this.phoneNumber,
  });
}
