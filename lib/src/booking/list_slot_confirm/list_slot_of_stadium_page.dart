import 'package:demo_app/bloc/list_brandStadium/list_brand_stadium_bloc.dart';
import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/model/bookingStadium/listBrandWithStadium.dart';
import 'package:demo_app/src/booking/list_slot_confirm/build_alert_confirm.dart';
import 'package:demo_app/src/booking/list_stadium/list_stadium_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListSlotOfStadiumPages extends StatelessWidget {
  final ListBrandWithStadium brand;
  final Map<String, dynamic>? args;
  final String? token;
  final String? userId;
  const ListSlotOfStadiumPages({
    Key? key,
    required this.args,
    required this.token,
    required this.userId,
    required this.brand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetail = context.select((LoginBloc bloc) => bloc.state.user);
    final toKen = context.select((LoginBloc bloc) => bloc.state.token);

    return Scaffold(
      appBar: AppBar(
        title: Text('slotTime'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
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

          if (state.slotTime.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.event_busy,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'slotNotAvailable'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'availableSlots'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StadiumPage(brand: brand),
                          ),
                          (route) => false, // ลบทุกเส้นทางที่เหลือออกทั้งหมด
                        );
                      },
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            );
          }
          final slotTime = state.slotTime;
          return Container(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: slotTime.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${'startTime'.tr()}: ${slotTime[index].startTime}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${'endTime'.tr()}: ${slotTime[index].endTime}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            String? brandId;
                            String? stadiumId;
                            String? reservationDate;
                            String? reservationHours;
                            if (args != null) {
                              brandId = args?['brand_id'].toString();
                              stadiumId = args?['stadium_id'].toString();
                              reservationDate = args?['reservationDate'].toString();
                              reservationHours = args?['reservationHours'].toString();
                            }

                            showBookingConfirmation(context, brandId!, stadiumId, reservationDate, reservationHours, slotTime[index].startTime, slotTime[index].endTime, toKen, userDetail[0].userId);
                          },
                          child: Text("book".tr()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
