import 'package:flutter/material.dart';
import 'package:tech_barter/components/custom_scaffold.dart';

import 'components/my_profile.dart';
import 'components/profile_side_menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      curIndex: 5,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ProfileSideMenu( index: 0,),
                  ),
                  Expanded(
                    flex: 8,
                    child: MyProfile(),
                  ),
                ]
            ),
          ],
        )
      )
    );
  }
}
