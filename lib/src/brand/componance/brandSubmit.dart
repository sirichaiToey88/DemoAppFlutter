import 'dart:convert';
import 'package:demo_app/bloc/brandStadium/brand_stadium_bloc.dart';
import 'package:demo_app/model/bookingStadium/createBrand.dart';
import 'package:demo_app/route/route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/src/brand/componance/stadiumItem.dart';
import 'package:demo_app/src/brand/componance/validateInputs.dart';
import 'package:demo_app/utils/custom_toast/show_toast_top.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class BrandSubmit {
  static void submitBrandInfo(
    BuildContext context,
    TextEditingController brandNameController,
    TextEditingController timeOpenController,
    TextEditingController timeCloseController,
    TextEditingController tellController,
    TextEditingController addressController,
    PickedFile? pickedImage,
    List<StadiumInfo> stadiums,
    String toKen,
  ) {
    if (stadiums.isEmpty) {
      showCustomToastTop('pleaseInsertStadium'.tr(), backgroundColor: Colors.red, textColor: Colors.white);
    }
    if (validateInputs(
      addressController: addressController,
      brandNameController: brandNameController,
      tellController: tellController,
      timeCloseController: timeCloseController,
      timeOpenController: timeOpenController,
    )) {
      //Loop check data stadium
      List<Map<String, dynamic>> stadiumListJson = [];
      String typeStadium = "";
      Map<String, dynamic> stadiumMap = {};
      bool hasDuplicateCourtNumbers = false;
      Map<String, Set<String>> stadiumNumbersByType = {};
      List<CreateBrand> createBrandsList = [];

      for (var i = 0; i < stadiums.length; i++) {
        if (stadiums[i].typeStadium == "----- รบกวนระบุประเภทสนาม -----" || stadiums[i].stadiumNumber == null || stadiums[i].stadiumPrice == null) {
          showCustomToastTop('pleaseInsertStadiumInput'.tr(), backgroundColor: Colors.red, textColor: Colors.white);
          return; // ออกจากการสร้าง JSON ถ้าข้อมูลไม่ถูกต้อง
        }

        String typeStadium = stadiums[i].typeStadium == "วอลเลย์บอล" || stadiums[i].typeStadium == "Volleyball" ? "1" : "2";

        // ตรวจสอบว่ามี stadiumNumber ซ้ำใน typeStadium เดียวกันหรือไม่
        if (stadiumNumbersByType.containsKey(stadiums[i].typeStadium)) {
          if (stadiumNumbersByType[stadiums[i].typeStadium]!.contains(stadiums[i].stadiumNumber)) {
            hasDuplicateCourtNumbers = true;
            break;
          }
        } else {
          stadiumNumbersByType[stadiums[i].typeStadium.toString()] = Set<String>();
        }

        // เพิ่ม stadiumNumber ลงใน typeStadium นั้น
        stadiumNumbersByType[stadiums[i].typeStadium]!.add(stadiums[i].stadiumNumber.toString());

        // เพิ่มข้อมูลของสนามลงใน Map
        stadiumMap[stadiums[i].toString()] = {
          "type_stadium": typeStadium,
          "image_url": stadiums[i].image?.path ?? "",
          "stadium_number": stadiums[i].stadiumNumber,
          "price": stadiums[i].stadiumPrice,
        };
      }
      createBrandsList.add(
        CreateBrand(
          brandTitle: brandNameController.text,
          imageUrl: pickedImage?.path ?? "",
          timeOpen: timeOpenController.text,
          timeClose: timeCloseController.text,
          location: "Null",
          tell: tellController.text,
          address: addressController.text,
          stadiums: stadiumMap,
        ),
      );
      if (hasDuplicateCourtNumbers) {
        showCustomToastTop('duplicateCourtNumbers'.tr(), backgroundColor: Colors.red, textColor: Colors.white);
        return; // ออกจากการสร้าง JSON ถ้ามีเลขคอร์ทที่ซ้ำกัน
      }

      String jsonString = jsonEncode(createBrandsList);
      print("object JSON => " + jsonString);
      BlocProvider.of<BrandStadiumBloc>(context).add(
        BrandStadiumSaveEvent(createBrandsList, toKen),
      );

      Navigator.pushReplacementNamed(context, AppRoute.mainScreenBooking);
    }
  }
}
