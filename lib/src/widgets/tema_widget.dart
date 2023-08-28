import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:traductor/src/providers/main_provider.dart';

class TemaWidget extends StatefulWidget {
  const TemaWidget({Key? key}) : super(key: key);

  @override
  State<TemaWidget> createState() => _TemaWidgetState();
}

class _TemaWidgetState extends State<TemaWidget> {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 5.h),
          SwitcherButton(
            size: 38.h,
            value: mainProvider.mode,
            onChange: (bool value) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("mode", value);
              mainProvider.mode = value;
            },
          ),
          SizedBox(width: 3.h),
          mainProvider.mode
              ? Icon(
                  Icons.nightlight,
                  size: 20.h,
                )
              : Icon(
                  Icons.light_mode,
                  size: 20.h,
                ),
        ],
      ),
    );
  }
}
