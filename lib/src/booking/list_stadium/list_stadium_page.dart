import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/src/booking/list_slot_confirm/build_alert_booking.dart';
import 'package:demo_app/src/booking/main_screen/screen_booking_main_page.dart';
import 'package:demo_app/model/bookingStadium/listBrandWithStadium.dart';
import 'package:demo_app/utils/money_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StadiumPage extends StatefulWidget {
  final ListBrandWithStadium brand;

  const StadiumPage({Key? key, required this.brand}) : super(key: key);

  @override
  _StadiumPageState createState() => _StadiumPageState();
}

class _StadiumPageState extends State<StadiumPage> {
  String _selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    final userDetail = context.select((LoginBloc bloc) => bloc.state.user);
    final toKen = context.select((LoginBloc bloc) => bloc.state.token);

//Query check item where condition
    List<Stadium> filteredStadiums = widget.brand.stadium.values.toList();
    if (_selectedType != 'All') {
      filteredStadiums = filteredStadiums.where((stadium) => stadium.typeStadium == _selectedType).toList();
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.brand.brandTitle),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreenBooking(token: toKen, userId: userDetail[0].userId),
              ),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add the dropdown search usage
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: DropdownButton<String>(
              alignment: AlignmentDirectional.centerEnd,
              value: _selectedType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              items: <String>[
                'All',
                '1',
                '2'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: Alignment.centerLeft,
                  value: value,
                  child: Text(value == 'All'
                      ? 'allTypes'.tr()
                      : value == '1'
                          ? 'volleyball'.tr()
                          : 'badminton'.tr()),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          // Add the left-right slide for stadium type filter button
          SizedBox(
            height: 30.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: [
                'All',
                '1',
                '2'
              ].length,
              itemBuilder: (BuildContext context, int index) {
                final type = [
                  'All',
                  '1',
                  '2'
                ][index];
                return SlideItem(
                  title: type == 'All'
                      ? 'allTypes'.tr()
                      : type == '1'
                          ? 'volleyball'.tr()
                          : 'badminton'.tr(),
                  isSelected: _selectedType == type,
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStadiums.length,
              itemBuilder: (context, index) {
                final stadium = filteredStadiums[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        // stadium.typeStadium == "1" ? 'assets/images/badminton/vallayball.png' : stadium.imageUrl,
                        stadium.typeStadium == "1" ? 'assets/images/badminton/vallayball.png' : 'assets/images/badminton/badminton.png',
                        height: 150.0,
                        width: 80.0,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        '${'stadium'.tr()} : ${stadium.stadiumNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${'price'.tr()}: ${formatThaiBaht(double.parse((stadium.price)))}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '${'type'.tr()}: ${stadium.typeStadium == "1" ? "volleyball".tr() : "badminton".tr()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => showBookingAlert(context, stadium, toKen, userDetail[0].userId, widget.brand),
                        child: Text('bookNow'.tr()),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SlideItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SlideItem({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
        ),
      ),
    );
  }
}
