
import 'package:flutter/material.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/screens/homePage/components/best_selling_products.dart';
import 'package:tech_barter/screens/homePage/components/explore_our_products.dart';
import 'package:tech_barter/screens/homePage/components/home_category_list.dart';

import 'components/home_banner.dart';
import 'components/recyclable_products.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      curIndex: 0,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 32),
              height: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: CategoryList(),
                  ),
                  SizedBox(width: 32),
                  Expanded(
                    flex: 7,
                    child: HomeBanner(),
                  ),
                ]
              ),
            ),
            BestSellingProducts(),
            ExploreOurProducts(),
            RecyclableProducts(),
          ],
        ),
      ),
    );
  }
}
