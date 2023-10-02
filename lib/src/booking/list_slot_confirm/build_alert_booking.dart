import 'dart:convert';

import 'package:demo_app/bloc/list_brandStadium/list_brand_stadium_bloc.dart';
import 'package:demo_app/model/bookingStadium/listBrandWithStadium.dart';
import 'package:demo_app/src/booking/list_slot_confirm/list_slot_of_stadium_page.dart';
import 'package:demo_app/utils/date_format.dart';
import 'package:demo_app/utils/textFromField/text_from_field_number.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Future<void> showBookingAlert(BuildContext context, Stadium stadium, String token, String userId, ListBrandWithStadium brand) async {
  DateTime? selectedDate;
  final TextEditingController reservationHoursController = TextEditingController();
  String? reservationDateError;
  String? reservationHoursError;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            title: Text('findSlots'.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        reservationDateError = null;
                      });
                    } else {
                      setState(() {
                        reservationDateError = 'pleaseSelectDate'.tr();
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'reservationDate'.tr(),
                      errorText: reservationDateError,
                    ),
                    child: Text(
                      selectedDate != null ? formatShortDateThai(DateFormat('yyyy-MM-dd').format(selectedDate!)) : 'selectDate'.tr(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFromFieldNumber(
                  controller: reservationHoursController,
                  lableText: 'reservationHours'.tr(),
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  validator: (value) {
                    return null;
                  },
                  errorMessage: reservationHoursError,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('cancel'.tr()),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDate != null && reservationHoursController.text.isNotEmpty) {
                    _onBookNowPressed(context, stadium, token, userId, DateFormat('yyyy-MM-dd').format(selectedDate!), int.parse(reservationHoursController.text), brand);
                  } else {
                    setState(() {
                      reservationDateError = selectedDate == null ? 'pleaseSelectDate'.tr() : null;
                      reservationHoursError = reservationHoursController.text.isEmpty ? 'pleaseEnterHours'.tr() : null;
                    });
                  }
                },
                child: Text('book'.tr()),
              ),
            ],
          );
        },
      );
    },
  );
}

void _onBookNowPressed(BuildContext context, Stadium stadium, String token, String userId, String reservationDate, int reservationHours, ListBrandWithStadium brand) {
  Map<String, dynamic> args = {
    'brand_id': stadium.brandId,
    'reservationDate': reservationDate,
    'reservationHours': reservationHours,
    'stadium_id': stadium.id,
  };

  String jsonStrSlot = jsonEncode(args);
  print("Json lot ${jsonStrSlot}");

  // Pass the arguments to the event using named parameters
  BlocProvider.of<ListBrandStadiumBloc>(context).add(ListSlotOfStadiumFetchEvent(args, token, userId));

  // Navigator.pushReplacementNamed(
  //   context,
  //   AppRoute.listSlotOfStadiumPages,
  //   arguments: args,
  // );
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ListSlotOfStadiumPages(
        args: args,
        token: token,
        userId: userId,
        brand: brand,
      ),
    ),
  );
}
