import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_barter/utils/route_strings.dart';

class ProfileSideMenu extends StatefulWidget {
  final int index;
  const ProfileSideMenu({super.key, this.index = 0});

  @override
  State<ProfileSideMenu> createState() => _ProfileSideMenuState();
}

class _ProfileSideMenuState extends State<ProfileSideMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      "My Profile",
                      style: TextStyle(fontWeight: FontWeight.bold, color: getTextColor(0))
                  )
              ),
              onTap: () {
                GoRouter.of(context).push(RouteName.profilePage);
              }
          ),
          GestureDetector(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      "Address",
                      style: TextStyle(fontWeight: FontWeight.bold, color: getTextColor(1))
                  ),
              ),
              onTap: () {
                GoRouter.of(context).push(RouteName.addressPage);
              }
          ),
          GestureDetector(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      "My Orders",
                      style: TextStyle(fontWeight: FontWeight.bold, color: getTextColor(2))
                  )
              ),
              onTap: () {
                GoRouter.of(context).push(RouteName.orderPage);
              }
          ),
        ]
      ),
    );
  }


  getTextColor(int i) {
    if (i == widget.index) {
      return Theme.of(context).primaryColor;
    } else {
      return Colors.grey;
    }
  }
}


