import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/components/quantity_stepper.dart';
import 'package:tech_barter/providers/product_provider.dart';
import 'package:tech_barter/screens/productPage/components/related_products.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  int _currentQuantity = 1;

  @override
  Widget build(BuildContext context) {

    if(Provider.of<ProductProvider>(context).getSelectedProduct == null) {
      return CustomScaffold(body: Container());
    }

    return CustomScaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 100,
                          width: 100,
                          color: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "https://picsum.photos/id/1/2000/3000",
                              height: 240,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 500,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://picsum.photos/id/${Random().nextInt(500)}/2000/3000",
                            height: 500,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 500,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<ProductProvider>(
                          builder: (context, productProvider, child) {
                            return Text(
                              "${productProvider.getSelectedProduct!.name}",
                              style: Theme.of(context).textTheme.bodyLarge
                            );
                          }
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Icon(Icons.star_half, color: Colors.orange, size: 20),
                            SizedBox(width: 8),
                            Text("(150 Reviews)", style: TextStyle(color: Colors.grey)),
                            SizedBox(width: 8),
                            Text("|", style: TextStyle(color: Colors.grey)),
                            SizedBox(width: 8),
                            Text("InStock", style: TextStyle(color: Colors.green)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Consumer<ProductProvider>(
                          builder: (context, productProvider, child) {
                            return Text(
                              "${productProvider.getSelectedProduct!.price}",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                            );
                          }
                        ),
                        SizedBox(height: 8),
                        Consumer<ProductProvider>(
                          builder: (context, productProvider, child) {
                            return Text(
                              "${productProvider.getSelectedProduct!.description}",
                              style: TextStyle(color: Colors.grey),
                            );
                          }
                        ),
                        SizedBox(height: 16),
                        /// FOR COLOUR SELECTION
                        // Text("Colours:"),
                        // Row(
                        //   children: List.generate(2, (index) {
                        //     return GestureDetector(
                        //       onTap: () => provider.changeColor(index),
                        //       child: Container(
                        //         margin: EdgeInsets.only(right: 8),
                        //         width: 30,
                        //         height: 30,
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           color: index == 0 ? Colors.blue : Colors.black,
                        //           border: provider.selectedColor == index
                        //               ? Border.all(color: Colors.blue, width: 2)
                        //               : null,
                        //         ),
                        //       ),
                        //     );
                        //   }),
                        // ),
                        /// FOR COLOUR SIZE SELECTION
                        // Text("Size:"),
                        // Row(
                        //   children: ["XS", "S", "M", "L", "XL"].map((size) {
                        //     return GestureDetector(
                        //       // onTap: () => provider.changeSize(size),
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        //         margin: EdgeInsets.only(right: 8),
                        //         decoration: BoxDecoration(
                        //           border: Border.all(
                        //               color: false ? Colors.blue : Colors.grey),
                        //           borderRadius: BorderRadius.circular(8),
                        //         ),
                        //         child: Text(size),
                        //       ),
                        //     );
                        //   }).toList(),
                        // ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            // Row(
                            //   children: [
                            //     Container(
                            //       width: 40,
                            //       height: 40,
                            //       decoration: BoxDecoration(
                            //         border: Border.all(color: Colors.grey),
                            //         borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                            //       ),
                            //       child: Center(child: Icon(Icons.remove, color: Colors.black, size: 20)),
                            //     ),
                            //     Container(
                            //         width: 60,
                            //         height: 40,
                            //         decoration: BoxDecoration(
                            //           border: Border.all(color: Colors.grey),
                            //           borderRadius: BorderRadius.zero,
                            //         ),
                            //         child: Center(child: Text("1", style: TextStyle(color: Colors.black, fontSize: 20))),
                            //     ),
                            //     Container(
                            //         width: 40,
                            //         height: 40,
                            //         decoration: BoxDecoration(
                            //           border: Border.all(color: Colors.grey),
                            //           borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                            //         ),
                            //         child: Center(child: Icon(Icons.add, color: Colors.black, size: 20)),
                            //     ),
                            //   ],
                            // ),
                            Consumer<ProductProvider>(
                                builder: (context, productProvider, child) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return QuantityStepper(
                                          quantity: _currentQuantity,
                                          maxQuantity: productProvider.getSelectedProduct!.quantity!,
                                          onQuantityChanged: (value)=> setState(() {
                                            _currentQuantity = value;
                                          })
                                      );
                                    }
                                  );
                                }
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                minimumSize: Size(200, 50),
                              ),
                              child: Text("Buy Now", style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                            SizedBox(width: 16),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Center(child: Icon(Icons.favorite_border, color: Colors.black, size: 20)),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.local_shipping, color: Colors.black),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Free Delivery"),
                                  Text("Enter your postal code"),
                                ]
                              ),
                            ],
                          ),
                        ),
                      ]
                    )
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if(productProvider.getSelectedProduct!.id != null) {
                  return RelatedProducts(productId: productProvider.getSelectedProduct!.id.toString());
                }
                return Container(child: Text("no product id"));
              }
            ),
          ]
        )
      ),
    );
  }
}
