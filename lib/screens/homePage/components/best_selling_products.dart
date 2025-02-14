import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_button.dart';
import 'package:tech_barter/components/product_card.dart';
import 'package:tech_barter/providers/product_provider.dart';



class BestSellingProducts extends StatefulWidget {
  const BestSellingProducts({super.key});

  @override
  State<BestSellingProducts> createState() => _BestSellingProductsState();
}

class _BestSellingProductsState extends State<BestSellingProducts> {

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).loadBestSellingProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.label, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'This Month',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Selling Products',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              CustomBlueButton(
                label: 'View All',
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return SizedBox(
                height: 400,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.getBestSellingProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: productProvider.getBestSellingProducts[index],
                    );
                  },
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}


