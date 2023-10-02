import 'dart:io';

import 'package:demo_app/bloc/brandStadium/brand_stadium_bloc.dart';
import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/src/brand/componance/brandSubmit.dart';
import 'package:demo_app/src/brand/componance/stadiumItem.dart';
import 'package:demo_app/utils/textFromField/text_from_field_number.dart';
import 'package:demo_app/utils/textFromField/text_from_field_text.dart';
import 'package:demo_app/utils/textFromField/text_from_field_tiime_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class MainCreateBrand extends StatefulWidget {
  const MainCreateBrand({super.key});

  @override
  State<MainCreateBrand> createState() => _MainCreateBrandState();
}

class _MainCreateBrandState extends State<MainCreateBrand> {
  final List<StadiumInfo> stadiums = []; // รายการ Stadium
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _timeOpenController = TextEditingController();
  final TextEditingController _timeCloseController = TextEditingController();
  final TextEditingController _tellController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? brandNameError;
  String? courtNumberError;
  String? courtPriceError;
  String? timeOpenError;
  String? timeCloseError;
  String? tellError;
  String? addressError;
  bool isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();
  PickedFile? _pickedImage; // รูปภาพที่ถูกเลือก
  PickedFile? _pickedImageStadium;
  List<PickedFile?> selectedImages = [];

  // Dropdown items สำหรับ Type_stadium
  final List<String> typeStadiumOptions = [
    'volleyball'.tr(),
    'badminton'.tr()
  ];

  String? selectedTypeStadium; // ค่าที่ถูกเลือกจาก Dropdown

  void deleteImage(int index) {
    setState(() {
      stadiums[index].image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDetail = context.select((LoginBloc bloc) => bloc.state.user);
    final toKen = context.select((LoginBloc bloc) => bloc.state.token);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('addBrand'.tr()),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigator.pushReplacementNamed(
            //   navigatorState.currentContext!,
            //   AppRoute.listSlotOfStadiumPages,
            // );
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<BrandStadiumBloc, BrandStadiumState>(
        builder: (context, state) {
          if (isLoading == true && state.status.toString() == 'FetchStatus.init') {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                strokeWidth: 5.0,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'brandInformation'.tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextFromFieldText(
                    controller: _brandNameController,
                    lableText: 'brandTitle'.tr(),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return null;
                    },
                    errorMessage: brandNameError,
                  ),
                  TimeTextField(
                    controller: _timeOpenController,
                    labelText: 'open'.tr(),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return null;
                    },
                    errorMessage: timeOpenError,
                  ),
                  TimeTextField(
                    controller: _timeCloseController,
                    labelText: 'closing'.tr(),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return null;
                    },
                    errorMessage: timeCloseError,
                  ),
                  TextFromFieldNumber(
                    controller: _tellController,
                    lableText: 'phoneNumber'.tr(),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: (value) {
                      return null;
                    },
                    errorMessage: tellError,
                  ),
                  TextFromFieldText(
                    controller: _addressController,
                    lableText: 'address'.tr(),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return null;
                    },
                    errorMessage: addressError,
                  ),
                  const SizedBox(height: 16),
                  showBottomImage(context),
                  if (_pickedImage != null)
                    Column(
                      children: [
                        Image.file(File(_pickedImage!.path), height: 200),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _pickedImage = null;
                            });
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_sweep,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  Text(
                    'stadiumInformation'.tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // รายการ Stadium
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: stadiums.length,
                    itemBuilder: (context, index) {
                      return StadiumItem(
                        stadiumInfo: stadiums[index],
                        onDelete: () {
                          setState(() {
                            stadiums.removeAt(index);
                          });
                        },
                        onDeleteImage: () {
                          deleteImage(index);
                        },
                        // ส่งค่า options และค่าที่ถูกเลือกจาก Dropdown
                        typeStadiumOptions: typeStadiumOptions,
                        selectedTypeStadium: selectedTypeStadium,
                        // Callback เมื่อเลือก Type_stadium
                        onTypeStadiumChanged: (newValue) {
                          setState(() {
                            selectedTypeStadium = newValue;
                          });
                        },
                        courtNumberError: courtNumberError,
                        courtPriceError: courtPriceError,
                      );
                    },
                  ),

                  // ปุ่ม + เพิ่ม Stadium
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final newStadium = StadiumInfo();
                        newStadium.typeStadium = 'pleaseSelect'.tr(); // กำหนด typeStadium ในรายการใหม่
                        stadiums.add(newStadium); // เพิ่มรายการ Stadium ใหม่
                      });
                    },
                    child: Text('addStadium'.tr()),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   isLoading = true;
                      // });
                      BrandSubmit.submitBrandInfo(
                        context,
                        _brandNameController,
                        _timeOpenController,
                        _timeCloseController,
                        _tellController,
                        _addressController,
                        _pickedImage,
                        stadiums,
                        toKen,
                      );
                    },
                    child: Text('submit'.tr()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  GestureDetector showBottomImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text('chooseFromGallery'.tr()),
                  onTap: () async {
                    final imagePicker = ImagePicker();
                    final pickedFile = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _pickedImage = PickedFile(pickedFile.path);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: Text('takeAPhoto'.tr()),
                  onTap: () async {
                    final imagePicker = ImagePicker();
                    final pickedFile = await imagePicker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _pickedImage = PickedFile(pickedFile.path);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
          const Icon(Icons.camera),
          const SizedBox(width: 8),
          Text('image'.tr()),
        ],
      ),
    );
  }
}
